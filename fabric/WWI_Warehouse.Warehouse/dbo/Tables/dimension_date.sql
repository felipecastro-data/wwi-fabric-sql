CREATE TABLE [dbo].[dimension_date] (
    [Date]                DATETIME2 (6) NOT NULL,
    [DayNumber]           INT           NOT NULL,
    [Day]                 VARCHAR (10)  NOT NULL,
    [Month]               VARCHAR (10)  NOT NULL,
    [ShortMonth]          VARCHAR (3)   NOT NULL,
    [CalendarMonthNumber] INT           NOT NULL,
    [CalendarMonthLabel]  VARCHAR (20)  NOT NULL,
    [CalendarYear]        INT           NOT NULL,
    [CalendarYearLabel]   VARCHAR (10)  NOT NULL,
    [FiscalMonthNumber]   INT           NOT NULL,
    [FiscalMonthLabel]    VARCHAR (20)  NOT NULL,
    [FiscalYear]          INT           NOT NULL,
    [FiscalYearLabel]     VARCHAR (10)  NOT NULL,
    [ISOWeekNumber]       INT           NOT NULL
);


GO