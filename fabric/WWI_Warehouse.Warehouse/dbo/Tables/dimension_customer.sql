CREATE TABLE [dbo].[dimension_customer] (
    [CustomerKey]    BIGINT        NOT NULL,
    [WWICustomerID]  BIGINT        NOT NULL,
    [Customer]       VARCHAR (100) NOT NULL,
    [BillToCustomer] VARCHAR (100) NOT NULL,
    [Category]       VARCHAR (50)  NOT NULL,
    [BuyingGroup]    VARCHAR (50)  NOT NULL,
    [PrimaryContact] VARCHAR (50)  NOT NULL,
    [PostalCode]     VARCHAR (10)  NOT NULL,
    [ValidFrom]      DATETIME2 (6) NOT NULL,
    [ValidTo]        DATETIME2 (6) NOT NULL,
    [LineageKey]     BIGINT        NOT NULL
);


GO