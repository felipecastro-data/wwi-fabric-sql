CREATE TABLE [dbo].[dimension_stock_item] (
    [StockItemKey]           INT              NOT NULL,
    [WWIStockItemID]         INT              NOT NULL,
    [StockItem]              VARCHAR (100)    NOT NULL,
    [Color]                  VARCHAR (20)     NOT NULL,
    [SellingPackage]         VARCHAR (50)     NOT NULL,
    [BuyingPackage]          VARCHAR (50)     NOT NULL,
    [Brand]                  VARCHAR (50)     NOT NULL,
    [Size]                   VARCHAR (20)     NOT NULL,
    [LeadTimeDays]           INT              NOT NULL,
    [QuantityPerOuter]       INT              NOT NULL,
    [IsChillerStock]         BIT              NOT NULL,
    [Barcode]                VARCHAR (50)     NOT NULL,
    [TaxRate]                DECIMAL (18, 3)  NOT NULL,
    [UnitPrice]              DECIMAL (18, 2)  NOT NULL,
    [RecommendedRetailPrice] DECIMAL (18, 2)  NOT NULL,
    [TypicalWeightPerUnit]   DECIMAL (18, 3)  NOT NULL,
    [Photo]                  VARBINARY (8000) NULL,
    [ValidFrom]              DATETIME2 (6)    NOT NULL,
    [ValidTo]                DATETIME2 (6)    NOT NULL,
    [LineageKey]             INT              NOT NULL
);


GO