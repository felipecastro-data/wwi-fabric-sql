-- WWI_Warehouse: create star-schema tables (re-runnable).
-- Types match the source parquet (fabrictutorialdata/.../WideWorldImportersDW/tables).
-- varchar sizes = measured max byte length + headroom.

DROP TABLE IF EXISTS dbo.fact_sale;
DROP TABLE IF EXISTS dbo.dimension_city;
DROP TABLE IF EXISTS dbo.dimension_customer;
DROP TABLE IF EXISTS dbo.dimension_date;
DROP TABLE IF EXISTS dbo.dimension_employee;
DROP TABLE IF EXISTS dbo.dimension_stock_item;

CREATE TABLE dbo.dimension_city (
    CityKey                  int           NOT NULL,
    WWICityID                int           NOT NULL,
    City                     varchar(100)  NOT NULL,
    StateProvince            varchar(100)  NOT NULL,
    Country                  varchar(60)   NOT NULL,
    Continent                varchar(30)   NOT NULL,
    SalesTerritory           varchar(50)   NOT NULL,
    Region                   varchar(30)   NOT NULL,
    Subregion                varchar(30)   NOT NULL,
    Location                 varchar(100)  NULL,
    LatestRecordedPopulation bigint        NOT NULL,
    ValidFrom                datetime2(6)  NOT NULL,
    ValidTo                  datetime2(6)  NOT NULL,
    LineageKey               int           NOT NULL
);

CREATE TABLE dbo.dimension_customer (
    CustomerKey    bigint        NOT NULL,
    WWICustomerID  bigint        NOT NULL,
    Customer       varchar(100)  NOT NULL,
    BillToCustomer varchar(100)  NOT NULL,
    Category       varchar(50)   NOT NULL,
    BuyingGroup    varchar(50)   NOT NULL,
    PrimaryContact varchar(50)   NOT NULL,
    PostalCode     varchar(10)   NOT NULL,
    ValidFrom      datetime2(6)  NOT NULL,
    ValidTo        datetime2(6)  NOT NULL,
    LineageKey     bigint        NOT NULL
);

CREATE TABLE dbo.dimension_date (
    [Date]              datetime2(6) NOT NULL,
    DayNumber           int          NOT NULL,
    [Day]               varchar(10)  NOT NULL,
    [Month]             varchar(10)  NOT NULL,
    ShortMonth          varchar(3)   NOT NULL,
    CalendarMonthNumber int          NOT NULL,
    CalendarMonthLabel  varchar(20)  NOT NULL,
    CalendarYear        int          NOT NULL,
    CalendarYearLabel   varchar(10)  NOT NULL,
    FiscalMonthNumber   int          NOT NULL,
    FiscalMonthLabel    varchar(20)  NOT NULL,
    FiscalYear          int          NOT NULL,
    FiscalYearLabel     varchar(10)  NOT NULL,
    ISOWeekNumber       int          NOT NULL
);

CREATE TABLE dbo.dimension_employee (
    EmployeeKey   int             NOT NULL,
    WWIEmployeeID int             NOT NULL,
    Employee      varchar(50)     NOT NULL,
    PreferredName varchar(50)     NOT NULL,
    IsSalesperson bit             NOT NULL,
    Photo         varbinary(8000) NULL,
    ValidFrom     datetime2(6)    NOT NULL,
    ValidTo       datetime2(6)    NOT NULL,
    LineageKey    int             NOT NULL
);

CREATE TABLE dbo.dimension_stock_item (
    StockItemKey           int             NOT NULL,
    WWIStockItemID         int             NOT NULL,
    StockItem              varchar(100)    NOT NULL,
    Color                  varchar(20)     NOT NULL,
    SellingPackage         varchar(50)     NOT NULL,
    BuyingPackage          varchar(50)     NOT NULL,
    Brand                  varchar(50)     NOT NULL,
    Size                   varchar(20)     NOT NULL,
    LeadTimeDays           int             NOT NULL,
    QuantityPerOuter       int             NOT NULL,
    IsChillerStock         bit             NOT NULL,
    Barcode                varchar(50)     NOT NULL,
    TaxRate                decimal(18,3)   NOT NULL,
    UnitPrice              decimal(18,2)   NOT NULL,
    RecommendedRetailPrice decimal(18,2)   NOT NULL,
    TypicalWeightPerUnit   decimal(18,3)   NOT NULL,
    Photo                  varbinary(8000) NULL,
    ValidFrom              datetime2(6)    NOT NULL,
    ValidTo                datetime2(6)    NOT NULL,
    LineageKey             int             NOT NULL
);

CREATE TABLE dbo.fact_sale (
    SaleKey           bigint         NOT NULL,
    CityKey           int            NOT NULL,
    CustomerKey       int            NOT NULL,
    BillToCustomerKey int            NOT NULL,
    StockItemKey      int            NOT NULL,
    InvoiceDateKey    datetime2(6)   NOT NULL,
    DeliveryDateKey   datetime2(6)   NULL,
    SalespersonKey    int            NOT NULL,
    WWIInvoiceID      int            NOT NULL,
    Description       varchar(2000)  NOT NULL,
    Package           varchar(50)    NOT NULL,
    Quantity          int            NOT NULL,
    UnitPrice         decimal(18,2)  NOT NULL,
    TaxRate           decimal(18,3)  NOT NULL,
    TotalExcludingTax decimal(18,2)  NOT NULL,
    TaxAmount         decimal(18,2)  NOT NULL,
    Profit            decimal(18,2)  NOT NULL,
    TotalIncludingTax decimal(18,2)  NOT NULL,
    TotalDryItems     int            NOT NULL,
    TotalChillerItems int            NOT NULL,
    LineageKey        int            NOT NULL
);
