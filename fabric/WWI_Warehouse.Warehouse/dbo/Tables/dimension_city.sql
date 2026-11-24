CREATE TABLE [dbo].[dimension_city] (
    [CityKey]                  INT           NOT NULL,
    [WWICityID]                INT           NOT NULL,
    [City]                     VARCHAR (100) NOT NULL,
    [StateProvince]            VARCHAR (100) NOT NULL,
    [Country]                  VARCHAR (60)  NOT NULL,
    [Continent]                VARCHAR (30)  NOT NULL,
    [SalesTerritory]           VARCHAR (50)  NOT NULL,
    [Region]                   VARCHAR (30)  NOT NULL,
    [Subregion]                VARCHAR (30)  NOT NULL,
    [Location]                 VARCHAR (100) NULL,
    [LatestRecordedPopulation] BIGINT        NOT NULL,
    [ValidFrom]                DATETIME2 (6) NOT NULL,
    [ValidTo]                  DATETIME2 (6) NOT NULL,
    [LineageKey]               INT           NOT NULL
);


GO