--1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers
DECLARE @InsCount AS int
SET @InsCount = 5

;WITH CteCustomers AS
(
SELECT TOP(@InsCount)
       CustomerName + CONVERT(VARCHAR(10),CustomerID + @InsCount) AS CustomerName
      ,BillToCustomerID
      ,CustomerCategoryID
      ,BuyingGroupID
      ,PrimaryContactPersonID
      ,AlternateContactPersonID
      ,DeliveryMethodID
      ,DeliveryCityID
      ,PostalCityID
      ,CreditLimit
      ,AccountOpenedDate
      ,StandardDiscountPercentage
      ,IsStatementSent
      ,IsOnCreditHold
      ,PaymentDays
      ,PhoneNumber
      ,FaxNumber
      ,DeliveryRun
      ,RunPosition
      ,WebsiteURL
      ,DeliveryAddressLine1
      ,DeliveryAddressLine2
      ,DeliveryPostalCode
      ,DeliveryLocation
      ,PostalAddressLine1
      ,PostalAddressLine2
      ,PostalPostalCode
      ,LastEditedBy
FROM Sales.Customers
ORDER BY CustomerID DESC
)
INSERT INTO Sales.Customers
(
       CustomerName
      ,BillToCustomerID
      ,CustomerCategoryID
      ,BuyingGroupID
      ,PrimaryContactPersonID
      ,AlternateContactPersonID
      ,DeliveryMethodID
      ,DeliveryCityID
      ,PostalCityID
      ,CreditLimit
      ,AccountOpenedDate
      ,StandardDiscountPercentage
      ,IsStatementSent
      ,IsOnCreditHold
      ,PaymentDays
      ,PhoneNumber
      ,FaxNumber
      ,DeliveryRun
      ,RunPosition
      ,WebsiteURL
      ,DeliveryAddressLine1
      ,DeliveryAddressLine2
      ,DeliveryPostalCode
      ,DeliveryLocation
      ,PostalAddressLine1
      ,PostalAddressLine2
      ,PostalPostalCode
      ,LastEditedBy
     )
OUTPUT inserted.*
SELECT * FROM CteCustomers


--2. удалите 1 запись из Customers, которая была вами добавлена
DELETE
FROM Sales.Customers
WHERE CustomerID=1077

--3. изменить одну запись, из добавленных через UPDATE
UPDATE Sales.Customers
SET CustomerName = 'Test Name'
WHERE CustomerID = 1079

--4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
MERGE Sales.Customers AS Target
USING 
(SELECT TOP 1 
       1077 AS CustomerID
      ,'Test Name 1' AS CustomerName
      ,BillToCustomerID
      ,CustomerCategoryID
      ,BuyingGroupID
      ,PrimaryContactPersonID
      ,AlternateContactPersonID
      ,DeliveryMethodID
      ,DeliveryCityID
      ,PostalCityID
      ,CreditLimit
      ,AccountOpenedDate
      ,StandardDiscountPercentage
      ,IsStatementSent
      ,IsOnCreditHold
      ,PaymentDays
      ,PhoneNumber
      ,FaxNumber
      ,DeliveryRun
      ,RunPosition
      ,WebsiteURL
      ,DeliveryAddressLine1
      ,DeliveryAddressLine2
      ,DeliveryPostalCode
      ,DeliveryLocation
      ,PostalAddressLine1
      ,PostalAddressLine2
      ,PostalPostalCode
      ,LastEditedBy FROM Sales.Customers WHERE CustomerID <= 1077 ORDER BY CustomerID DESC
) AS Source
  ON  (Target.CustomerID = Source.CustomerID)
  	WHEN MATCHED 
	  THEN UPDATE SET CustomerName = Source.CustomerName
	WHEN NOT MATCHED
      THEN INSERT (CustomerID, CustomerName,BillToCustomerID,CustomerCategoryID,PrimaryContactPersonID,DeliveryMethodID,DeliveryCityID,PostalCityID,AccountOpenedDate,StandardDiscountPercentage,IsStatementSent,IsOnCreditHold,PaymentDays,PhoneNumber,FaxNumber,WebsiteURL,DeliveryAddressLine1,DeliveryPostalCode,PostalAddressLine1,PostalPostalCode,LastEditedBy)
            VALUES (1077,'TestName 1',1061,5,3261,3,19881,19881,getdate(),0,0,0,7,'','','','','','','',1)
  OUTPUT deleted.*, $action, inserted.*;

-- 5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

-- Выгрузка
EXEC master..xp_cmdshell 'bcp "[WideWorldImporters].Application.Cities" out  "C:\temp\AppCities.txt" -T -w -t"MySplit!!!" -S WKS01\SQL2017'

-- Загрузка
CREATE TABLE #AppCities(
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] [geography] NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) NOT NULL,
	[ValidTo] [datetime2](7) NOT NULL
)

BULK INSERT #AppCities
  FROM "C:\temp\AppCities.txt"
WITH 
(
	BATCHSIZE = 1000, 
	DATAFILETYPE = 'widechar',
	FIELDTERMINATOR = 'MySplit!!!',
	ROWTERMINATOR ='\n',
 	KEEPNULLS,
	TABLOCK        
 )

 SELECT * FROM #AppCities
 DROP TABLE #AppCities