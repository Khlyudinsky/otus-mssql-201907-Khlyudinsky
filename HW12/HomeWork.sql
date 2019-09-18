/*1. Загрузить данные из файла StockItems.xml в таблицу StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (искать по StockItemName).
Файл StockItems.xml в личном кабинете.
*/

DECLARE @VarXml xml,
        @DocHandle int
SET @VarXml = (SELECT * FROM OPENROWSET (BULK 'C:\Обучение\otus-mssql-201907-Khlyudinsky\HW12\StockItems.xml',SINGLE_BLOB) as d)

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @VarXml

MERGE [Warehouse].[StockItems] AS Target
USING
(
SELECT * FROM OPENXML(@DocHandle, '/StockItems/Item', 2)
WITH (
       [StockItemName] NVARCHAR (100)  '@Name',
       [SupplierID] int 'SupplierID',
       [UnitPackageID] int 'Package/UnitPackageID',
       [OuterPackageID] int 'Package/OuterPackageID',
       [QuantityPerOuter] int 'Package/QuantityPerOuter',
       [TypicalWeightPerUnit] DECIMAL (18, 3) 'Package/TypicalWeightPerUnit',
       [LeadTimeDays] int 'LeadTimeDays',
       [IsChillerStock] bit 'IsChillerStock',
       [TaxRate] DECIMAL (18, 3) 'TaxRate',
       [UnitPrice] DECIMAL (18, 2) 'UnitPrice'
     )
) AS Source
ON  (Target.StockItemName = Source.StockItemName)
       WHEN MATCHED
         THEN UPDATE SET SupplierID = Source.SupplierID,
                         UnitPackageID = Source.UnitPackageID,
                         OuterPackageID = Source.OuterPackageID,
                         QuantityPerOuter = Source.QuantityPerOuter,
                         TypicalWeightPerUnit = Source.TypicalWeightPerUnit,
                         LeadTimeDays = Source.LeadTimeDays,
                         IsChillerStock = Source.IsChillerStock,
                         TaxRate = Source.TaxRate,
                         UnitPrice = Source.UnitPrice
       WHEN NOT MATCHED
         THEN INSERT (StockItemName,SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice,LastEditedBy)    
	          VALUES (Source.StockItemName,Source.SupplierID,Source.UnitPackageID,Source.OuterPackageID,Source.QuantityPerOuter,Source.TypicalWeightPerUnit,Source.LeadTimeDays,Source.IsChillerStock,Source.TaxRate,Source.UnitPrice,1)
       OUTPUT deleted.*, $action, inserted.*;

EXEC sp_xml_removedocument @docHandle

--2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml

SELECT  
    [StockItemName] as [@Name], 
    [SupplierID] as [SupplierID],
    [UnitPackageID] as [Package/UnitPackageID],
    [OuterPackageID] as [Package/OuterPackageID],
    [QuantityPerOuter] as [Package/QuantityPerOuter],
    [TypicalWeightPerUnit] as [Package/TypicalWeightPerUnit],
    [LeadTimeDays] as [LeadTimeDays],
    [IsChillerStock] as [IsChillerStock],
    [TaxRate] as [TaxRate],
    [UnitPrice] as [UnitPrice]
FROM [Warehouse].[StockItems]
FOR XML PATH('Item'), ROOT('StockItems')

/*
3. В таблице StockItems в колонке CustomFields есть данные в json.
Написать select для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- Range (из CustomFields)
*/

SELECT
  StockItemID,
  StockItemName,
  CustomFields,
  JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
  JSON_VALUE(CustomFields, '$.Range') AS Range
FROM Warehouse.StockItems

/*
4. Найти в StockItems строки, где есть тэг "Vintage"
Запрос написать через функции работы с JSON.
Тэги искать в поле CustomFields, а не в Tags.
*/

SELECT
  wsi.StockItemID,
  wsi.StockItemName,
  wsi.CustomFields
FROM Warehouse.StockItems wsi
CROSS APPLY OPENJSON(wsi.CustomFields,'$.tags') as tags
WHERE tags.value = 'Vintage'

/*
5. Пишем динамический PIVOT.
По заданию из 8го занятия про CROSS APPLY и PIVOT
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок
-------------------
Текст из ДЗ №8 
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
01.01.2013 3 1 4 2 2
01.02.2013 7 3 4 2 1
*/

DECLARE @HWQuery VARCHAR(max),
        @PVFields VARCHAR(max)

SELECT @PVFields = (
                     SELECT 
                       LTRIM(REPLACE(REPLACE(REPLACE(sc.CustomerName,'Tailspin Toys',''),')',''),'(','')) + '],['
                     FROM Sales.Orders so
                       JOIN Sales.Customers sc ON so.CustomerID = sc.CustomerID
                     WHERE sc.CustomerID BETWEEN 2 AND 6
                     GROUP BY CustomerName
                     FOR XML PATH('')
                    )

SELECT @PVFields = '[' + SUBSTRING(@PVFields,1,LEN(@PVFields)-2)

SET @HWQuery = 
'SELECT InvoiceMonth,' + @PVFields + ' FROM
(
  SELECT
  sc.CustomerID,
  LTRIM(REPLACE(REPLACE(REPLACE(sc.CustomerName,''Tailspin Toys'',''''),'')'',''''),''('','''')) AS CustomerName,
  Convert(Varchar,dateadd(dd,1-datepart(dd,so.OrderDate),so.OrderDate),104) AS InvoiceMonth,
  Convert(Date,dateadd(dd,1-datepart(dd,so.OrderDate),so.OrderDate),104) AS InvoiceMonthSort
  FROM Sales.Orders so
    JOIN Sales.Customers sc ON so.CustomerID = sc.CustomerID
  WHERE sc.CustomerID BETWEEN 2 AND 6
) AS Table1
PIVOT (
        COUNT(CustomerID)
        FOR CustomerName IN ('  + @PVFields + ')
      )
AS PVT
ORDER BY InvoiceMonthSort
'

EXEC (@HWQuery);
