-- WWI_Warehouse: row counts vs. source parquet metadata. Every row should say OK.

SELECT t.table_name, t.actual_rows, e.expected_rows,
       CASE WHEN t.actual_rows = e.expected_rows THEN 'OK' ELSE 'MISMATCH' END AS status
FROM (
          SELECT 'dimension_city'       AS table_name, COUNT_BIG(*) AS actual_rows FROM dbo.dimension_city
    UNION ALL SELECT 'dimension_customer',   COUNT_BIG(*) FROM dbo.dimension_customer
    UNION ALL SELECT 'dimension_date',       COUNT_BIG(*) FROM dbo.dimension_date
    UNION ALL SELECT 'dimension_employee',   COUNT_BIG(*) FROM dbo.dimension_employee
    UNION ALL SELECT 'dimension_stock_item', COUNT_BIG(*) FROM dbo.dimension_stock_item
    UNION ALL SELECT 'fact_sale',            COUNT_BIG(*) FROM dbo.fact_sale
) AS t
JOIN (VALUES
    ('dimension_city',       116295),
    ('dimension_customer',      403),
    ('dimension_date',         6210),
    ('dimension_employee',      213),
    ('dimension_stock_item',    672),
    ('fact_sale',          50150843)
) AS e(table_name, expected_rows) ON e.table_name = t.table_name
ORDER BY t.table_name;
