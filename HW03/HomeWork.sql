/*Для всех заданий где возможно, сделайте 2 варианта запросов:
1) через вложенный запрос
2) через WITH (для производных таблиц)
Напишите запросы:
*/
--1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.

SELECT * 
FROM Application.People ap
WHERE ap.IsSalesperson = 1
  AND NOT EXISTS (SELECT 1 FROM Sales.Orders so WHERE so.SalespersonPersonID = ap.PersonID)

SELECT * 
FROM Application.People 
WHERE IsSalesperson = 1
  AND PersonID NOT IN (SELECT SalespersonPersonID FROM Sales.Orders )

WITH SalesPerson AS
(
  SELECT PersonID,FullName  
  FROM Application.People
  WHERE IsSalesperson = 1
)
SELECT * FROM SalesPerson 
WHERE PersonID NOT IN (SELECT SalespersonPersonID FROM Sales.Orders) 



--2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 

SELECT * 
FROM Warehouse.StockItems
WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM Warehouse.StockItems)

SELECT * 
FROM Warehouse.StockItems 
WHERE UnitPrice <= ALL(SELECT UnitPrice FROM Warehouse.StockItems)

WITH MinUnitPrice AS
(
  SELECT MIN(UnitPrice) AS Price FROM Warehouse.StockItems
)
SELECT wsi.* 
FROM Warehouse.StockItems wsi
  JOIN MinUnitPrice ON MinUnitPrice.Price = wsi.UnitPrice


-- 3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей 
--    из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)

SELECT DISTINCT sc.CustomerName
FROM Sales.Customers sc
  JOIN (SELECT TOP 5 CustomerID
        FROM Sales.CustomerTransactions 
	    ORDER BY TransactionAmount DESC
        ) tab1 ON sc.CustomerID=tab1.CustomerID

  			  
WITH CTEtab AS
(
  SELECT TOP 5 CustomerID
  FROM Sales.CustomerTransactions 
  ORDER BY TransactionAmount DESC
)
SELECT DISTINCT sc.CustomerName
FROM Sales.Customers sc
  JOIN CTEtab ct ON ct.CustomerID=sc.CustomerID


SELECT sc.CustomerName
FROM Sales.Customers sc
WHERE sc.CustomerID in (
                         SELECT TOP 5 CustomerID 
                         FROM Sales.CustomerTransactions sct 
	                 ORDER BY sct.TransactionAmount DESC
	                ) 

--4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку 
--   самых дорогих товаров, а также Имя сотрудника, который осуществлял упаковку заказов

SELECT ac.CityID,
       ac.CityName,
       isnull(ap.FullName,'') AS PickedByPerson
FROM Sales.Orders so
  INNER JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
  INNER JOIN Warehouse.StockItems wsi ON sol.StockItemID = wsi.StockItemID
  INNER JOIN Sales.Invoices si ON si.OrderID = so.OrderID
  INNER JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
  INNER JOIN Application.Cities ac ON ac.CityID = sc.DeliveryCityID
  LEFT JOIN Application.People ap ON ap.PersonID = so.PickedByPersonID
WHERE 
  wsi.StockItemID in (
                       SELECT top 3 StockItemID
                       FROM Warehouse.StockItems
                       ORDER BY UnitPrice DESC
                     )  
  AND si.ConfirmedDeliveryTime is not null


WITH CTETab AS
(
  SELECT TOP 3 StockItemID
  FROM Warehouse.StockItems
  ORDER BY UnitPrice DESC
)
SELECT ac.CityID,
       ac.CityName,
       isnull(ap.FullName,'') AS PickedByPerson
FROM Sales.Orders so
  INNER JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
  INNER JOIN CTETab ct ON ct.StockItemID = sol.StockItemID
  INNER JOIN Warehouse.StockItems wsi ON sol.StockItemID = wsi.StockItemID
  INNER JOIN Sales.Invoices si ON si.OrderID = so.OrderID
  INNER JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
  INNER JOIN Application.Cities ac ON ac.CityID = sc.DeliveryCityID
  LEFT JOIN Application.People ap ON ap.PersonID = so.PickedByPersonID
WHERE si.ConfirmedDeliveryTime is not null

-- 5. Объясните, что делает и оптимизируйте запрос:
SELECT 
Invoices.InvoiceID, 
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice, 
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
   FROM Sales.OrderLines
 WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
                             FROM Sales.Orders
                             WHERE Orders.PickingCompletedWhen IS NOT NULL	
                             AND Orders.OrderId = Invoices.OrderId)	
                             ) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

/*
Запрос выводит информацию о: 
1.счет-фактуре, 
2.сотруднике осуществившем продажу, 
3.сумме товаров из счет-фактуры общая стоимость которых по сделке больше 27000,
4.стоимость доставленных товаров в упаковке
Отсортированных по 3 условию, по убыванию.
*/


/* Несколько подзапросов используются в комманде SELECT, их нужно убрать, так как вероятно 
sql-оптимизатор выполняет их для каждой строки выборки. Дополнительно, для повышения 
читаемости кода 2 подзапроса оформлю как CTE таблицы.
*/

WITH SalesTotals AS
(
  SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
  FROM Sales.InvoiceLines
  GROUP BY InvoiceId
  HAVING SUM(Quantity*UnitPrice) > 27000
),
TotalSummForPickedItems AS 
(
  SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) AS TotalSummForPickedItems,OrderID
  FROM Sales.OrderLines
  GROUP BY OrderID
) 
SELECT 
    Invoices.InvoiceID, 
    Invoices.InvoiceDate,
    People.FullName AS SalesPersonName,
    SalesTotals.TotalSumm AS TotalSummByInvoice, 
    TotalSummForPickedItems
FROM Sales.Invoices 
  JOIN SalesTotals ON Invoices.InvoiceID = SalesTotals.InvoiceID
  JOIN Sales.Orders ON Orders.OrderId = Invoices.OrderId
  JOIN TotalSummForPickedItems ON TotalSummForPickedItems.OrderID = Orders.OrderID
  JOIN Application.People ON People.PersonID = Invoices.SalespersonPersonID
WHERE Orders.PickingCompletedWhen IS NOT NULL
ORDER BY TotalSumm DESC

-- Планы запросов Plan0.sqlplan - первоначальный запрос,Plan1.sqlplan - исправленный запрос.