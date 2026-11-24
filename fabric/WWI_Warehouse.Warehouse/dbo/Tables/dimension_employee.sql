CREATE TABLE [dbo].[dimension_employee] (
    [EmployeeKey]   INT              NOT NULL,
    [WWIEmployeeID] INT              NOT NULL,
    [Employee]      VARCHAR (50)     NOT NULL,
    [PreferredName] VARCHAR (50)     NOT NULL,
    [IsSalesperson] BIT              NOT NULL,
    [Photo]         VARBINARY (8000) NULL,
    [ValidFrom]     DATETIME2 (6)    NOT NULL,
    [ValidTo]       DATETIME2 (6)    NOT NULL,
    [LineageKey]    INT              NOT NULL
);


GO