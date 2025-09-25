-- 1. Create the Data Warehouse Database





CREATE DATABASE BikeStoresDW;

GO



USE BikeStoresDW;

GO



-- 2. Create the Dimension Tables

-- DimDate: A standard time dimension table

CREATE TABLE [dbo].[DimDate] (

    [DateKey] INT NOT NULL PRIMARY KEY,

    [Date] DATE,

    [FullDate] VARCHAR(10),

    [DayOfMonth] INT,

    [DayName] VARCHAR(10),

    [DayOfWeek] INT,

    [DayOfYear] INT,

    [WeekOfYear] INT,

    [Month] INT,

    [MonthName] VARCHAR(10),

    [Quarter] INT,

    [QuarterName] VARCHAR(10),

    [Year] INT,

    [IsWeekend] BIT

);



-- DimStore 

CREATE TABLE [dbo].[DimStore] (

    [StoreKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, --> Clusterd index
 
    [StoreID] INT, --> Non Clustered

    [StoreName] NVARCHAR(255),

    [StoreCity] NVARCHAR(255),

    [StoreState] NVARCHAR(255),

    [StoreZipCode] NVARCHAR(10)

);

CREATE UNIQUE NONCLUSTERED INDEX IX_DimStore_StoreID ON [dbo].[DimStore] ([StoreID]);



-- DimStaff:

CREATE TABLE [dbo].[DimStaff] (

    [StaffKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    [StaffID] INT,

    [StaffFullName] NVARCHAR(255),

    [StoreID] INT

);

CREATE UNIQUE NONCLUSTERED INDEX IX_DimStaff_StaffID ON [dbo].[DimStaff] ([StaffID]);



-- DimProduct :

CREATE TABLE [dbo].[DimProduct] (

    [ProductKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    [ProductID] INT,

    [ProductName] NVARCHAR(255),

    [ModelYear] INT,

    [CategoryName] NVARCHAR(255),

    [BrandName] NVARCHAR(255),

    [StartDate] DATE,

    [EndDate] DATE,

    [IsCurrent] BIT

);

CREATE NONCLUSTERED INDEX IX_DimProduct_ProductID ON [dbo].[DimProduct] ([ProductID]);



-- DimCustomer

CREATE TABLE [dbo].[DimCustomer] (

    [CustomerKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    [CustomerID] INT,

    [FullName] NVARCHAR(255),

    [Email] NVARCHAR(255),

    [City] NVARCHAR(255),

    [State] NVARCHAR(255),

    [StartDate] DATE,

    [EndDate] DATE,

    [IsCurrent] BIT

);

CREATE NONCLUSTERED INDEX IX_DimCustomer_CustomerID ON [dbo].[DimCustomer] ([CustomerID]);



CREATE TABLE DimOrderStatus (
    OrderStatusKey INT PRIMARY KEY,
    OrderStatusDescription VARCHAR(50)
);


INSERT INTO DimOrderStatus (OrderStatusKey, OrderStatusDescription)
VALUES 
    (1, 'Pending'),
    (2, 'Processing'),
    (3, 'Shipped'),
    (4, 'Delivered');










-- 3. Create the Fact Table

CREATE TABLE [dbo].[FactSales] (

    [OrderDateKey] INT,

    [RequiredDateKey] INT,

    [CustomerKey] INT,

    [ProductKey] INT,

    [StoreKey] INT,

    [StaffKey] INT,

    [OrderID] INT,

    [OrderStatusKey] INT , 

    [Quantity] INT,

    [ListPrice] DECIMAL(10, 2),

    [Discount] DECIMAL(4, 2)

   ,[NetSalesAmount] DECIMAL(10, 2) 

    -- The primary key for a fact table is a composite key of all its foreign keys

    PRIMARY KEY ([OrderDateKey], [RequiredDateKey], [CustomerKey], 
    [ProductKey], [StoreKey], [StaffKey], [OrderID] , [OrderStatusKey])

);






-- Add Foreign Key constraints to the FactSales table

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimDate_OrderDate] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimDate_RequiredDate] FOREIGN KEY([RequiredDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimCustomer] FOREIGN KEY([CustomerKey]) REFERENCES [dbo].[DimCustomer] ([CustomerKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimProduct] FOREIGN KEY([ProductKey]) REFERENCES [dbo].[DimProduct] ([ProductKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimStore] FOREIGN KEY([StoreKey]) REFERENCES [dbo].[DimStore] ([StoreKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimStaff] FOREIGN KEY([StaffKey]) REFERENCES [dbo].[DimStaff] ([StaffKey]);

ALTER TABLE [dbo].[FactSales] WITH CHECK ADD CONSTRAINT [FK_FactSales_DimOrderStatus] FOREIGN KEY([OrderStatusKey]) REFERENCES [dbo].[DimOrderStatus] ([OrderStatusKey]);


