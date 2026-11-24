CREATE TABLE [dbo].[fact_sale] (
    [SaleKey]           BIGINT          NOT NULL,
    [CityKey]           INT             NOT NULL,
    [CustomerKey]       INT             NOT NULL,
    [BillToCustomerKey] INT             NOT NULL,
    [StockItemKey]      INT             NOT NULL,
    [InvoiceDateKey]    DATETIME2 (6)   NOT NULL,
    [DeliveryDateKey]   DATETIME2 (6)   NULL,
    [SalespersonKey]    INT             NOT NULL,
    [WWIInvoiceID]      INT             NOT NULL,
    [Description]       VARCHAR (2000)  NOT NULL,
    [Package]           VARCHAR (50)    NOT NULL,
    [Quantity]          INT             NOT NULL,
    [UnitPrice]         DECIMAL (18, 2) NOT NULL,
    [TaxRate]           DECIMAL (18, 3) NOT NULL,
    [TotalExcludingTax] DECIMAL (18, 2) NOT NULL,
    [TaxAmount]         DECIMAL (18, 2) NOT NULL,
    [Profit]            DECIMAL (18, 2) NOT NULL,
    [TotalIncludingTax] DECIMAL (18, 2) NOT NULL,
    [TotalDryItems]     INT             NOT NULL,
    [TotalChillerItems] INT             NOT NULL,
    [LineageKey]        INT             NOT NULL
);


GO