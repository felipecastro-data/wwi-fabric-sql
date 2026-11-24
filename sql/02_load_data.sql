-- WWI_Warehouse: load all tables from Microsoft's public WWI parquet (re-runnable).
-- fact_sale is ~50M rows; expect a few minutes on F64.

TRUNCATE TABLE dbo.dimension_city;
COPY INTO dbo.dimension_city
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/dimension_city.parquet'
WITH (FILE_TYPE = 'PARQUET');

TRUNCATE TABLE dbo.dimension_customer;
COPY INTO dbo.dimension_customer
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/dimension_customer.parquet'
WITH (FILE_TYPE = 'PARQUET');

TRUNCATE TABLE dbo.dimension_date;
COPY INTO dbo.dimension_date
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/dimension_date.parquet'
WITH (FILE_TYPE = 'PARQUET');

TRUNCATE TABLE dbo.dimension_employee;
COPY INTO dbo.dimension_employee
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/dimension_employee.parquet'
WITH (FILE_TYPE = 'PARQUET');

TRUNCATE TABLE dbo.dimension_stock_item;
COPY INTO dbo.dimension_stock_item
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/dimension_stock_item.parquet'
WITH (FILE_TYPE = 'PARQUET');

TRUNCATE TABLE dbo.fact_sale;
COPY INTO dbo.fact_sale
FROM 'https://fabrictutorialdata.blob.core.windows.net/sampledata/WideWorldImportersDW/tables/fact_sale.parquet'
WITH (FILE_TYPE = 'PARQUET');
