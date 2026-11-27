"""Tests for the read-only SQL guard. Run: python3 -m unittest tests/test_validate_sql.py"""

import sys
import types
import unittest
from pathlib import Path

# Stub the Fabric runtime module so function_app imports outside Fabric.
fabric = types.ModuleType("fabric")
functions = types.ModuleType("fabric.functions")


class _UDF:
    def __getattr__(self, _name):
        return lambda *a, **k: (lambda f: f)


functions.UserDataFunctions = _UDF
functions.FabricSqlConnection = object
functions.FabricItem = object
fabric.functions = functions
sys.modules.update({"fabric": fabric, "fabric.functions": functions})
sys.path.insert(0, str(Path(__file__).parent.parent / "fabric" / "WWI_Agent_Functions.UserDataFunction"))

from function_app import validate_sql  # noqa: E402


class ValidateSqlTest(unittest.TestCase):
    def test_allows_select_and_cte(self):
        self.assertEqual(validate_sql("SELECT TOP 5 Customer FROM dbo.dimension_customer;"),
                         "SELECT TOP 5 Customer FROM dbo.dimension_customer")
        validate_sql("WITH s AS (SELECT CityKey, SUM(Profit) p FROM dbo.fact_sale GROUP BY CityKey) SELECT * FROM s")
        validate_sql("select Description from dbo.fact_sale where Description like '%updated%'")

    def test_rejects_writes_and_tricks(self):
        for q in [
            "DELETE FROM dbo.fact_sale",
            "SELECT 1; DROP TABLE dbo.fact_sale",
            "SELECT * INTO dbo.x FROM dbo.fact_sale",
            "WITH a AS (SELECT 1 x) UPDATE dbo.fact_sale SET Quantity = 0",
            "SELECT 1 -- comment",
            "EXEC sp_who",
            "SELECT * FROM OPENROWSET(BULK 'x')",
            "",
        ]:
            with self.subTest(q=q), self.assertRaises(ValueError):
                validate_sql(q)


if __name__ == "__main__":
    unittest.main()
