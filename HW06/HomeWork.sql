--Оконные функции
/*1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы. 
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос. 
Или запрос из ДЗ по Оконным функциям 
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Нарастающий итог должен быть без оконной функции.
*/
-- пример с временной таблицей
SELECT 
  so.OrderID,
  sc.CustomerName,
  so.OrderDate,
  sil.ExtendedPrice,
  YEAR(OrderDate) * 100 + MONTH(OrderDate) AS YearMonth
INTO #SalesByMonth
FROM Sales.Orders so
  JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
  JOIN Sales.Invoices si ON so.OrderID = si.OrderID
  JOIN Sales.InvoiceLines sil ON si.InvoiceID = sil.InvoiceID
WHERE YEAR(so.OrderDate)>=2015

SELECT s1.*,
       (
	     SELECT SUM(s2.ExtendedPrice) 
		 FROM #SalesByMonth s2 
		 WHERE s2.YearMonth<=s1.YearMonth
	   ) AS TotalOfMonth
FROM #SalesByMonth s1
ORDER BY s1.YearMonth

-- пример с табличной переменной
DECLARE @SalesByMonth Table
(
  OrderID int,
  CustomerName nvarchar(100),
  OrderDate date,
  ExtendedPrice decimal(18, 2),
  YearMonth int
) 

INSERT INTO @SalesByMonth 
SELECT 
  so.OrderID,
  sc.CustomerName,
  so.OrderDate,
  sil.ExtendedPrice,
  YEAR(OrderDate) * 100 + MONTH(OrderDate) AS YearMonth
FROM Sales.Orders so
  JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
  JOIN Sales.Invoices si ON so.OrderID = si.OrderID
  JOIN Sales.InvoiceLines sil ON si.InvoiceID = sil.InvoiceID
WHERE YEAR(so.OrderDate)>=2015

SELECT s1.*,
       (
	     SELECT SUM(s2.ExtendedPrice) 
		 FROM @SalesByMonth s2 
		 WHERE s2.YearMonth<=s1.YearMonth
	   ) AS TotalOfMonth
FROM @SalesByMonth s1
ORDER BY s1.YearMonth

/* В случае с временной таблицей запрос отрабатывает гораздо быстрее (несколько секунд), в случае с табличной переменной порядка 15 минут 
на 100тыс.записей. Планы запросов приложил.Однако если в запросе вывода из табличной переменной прописать option(recompile), то запрос 
выполняется мгновенно, план запроса идентичен запросу из временной таблицы
*/


/*2. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Продажи можно взять из таблицы Invoices.
Сравните 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on;
*/

SELECT 
  so.OrderID,
  sc.CustomerName,
  so.OrderDate,
  sum(sil.ExtendedPrice) OVER (ORDER BY YEAR(OrderDate),MONTH(OrderDate)) AS TotalOfMonth
FROM Sales.Orders so
  JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
  JOIN Sales.Invoices si ON so.OrderID = si.OrderID
  JOIN Sales.InvoiceLines sil ON si.InvoiceID = sil.InvoiceID
WHERE YEAR(so.OrderDate)>=2015
ORDER BY so.OrderDate

/*
Выборка из временной таблицы, без оконной функции:
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 5 ms.

(101001 rows affected)

 SQL Server Execution Times:
   CPU time = 436 ms,  elapsed time = 11847 ms.

Completion time: 2019-08-28T20:37:48.1641134+03:00

Выборка с оконной функцией:
SQL Server parse and compile time: 
   CPU time = 31 ms, elapsed time = 43 ms.

(101001 rows affected)

 SQL Server Execution Times:
   CPU time = 140 ms,  elapsed time = 1067 ms.

Completion time: 2019-08-28T20:39:09.5511907+03:00
*/

--Заметно быстрее выполнился запрос с оконной функцией


--2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)

SELECT * FROM 
(
  SELECT StockItemName,
         Quantity,
	     DateMonth,
	     ROW_NUMBER() OVER (PARTITION BY DateMonth ORDER BY Quantity DESC) AS Ranks
  FROM (
         SELECT DISTINCT
                wsi.StockItemName,
                SUM(sol.Quantity) OVER (PARTITION BY MONTH(so.OrderDate) ORDER BY sol.StockItemID) AS Quantity,
                MONTH(so.OrderDate) AS DateMonth
         FROM Sales.Orders so
           JOIN Sales.OrderLines sol ON so.OrderID = sol.OrderID
           JOIN Warehouse.StockItems wsi ON sol.StockItemID = wsi.StockItemID
         WHERE YEAR(so.OrderDate) = 2016
       ) AS Table1 
) AS Table2
WHERE Ranks<=2
ORDER BY DateMonth,Quantity DESC

/*3. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций
*/
SELECT
  StockItemID,
  StockItemName,
  Brand,
  UnitPrice,
  Count(*) OVER () AS CountStockItems,
  Count(*) OVER (PARTITION BY LEFT(StockItemName,1)) AS CountStockItemsAlpha,
  LEAD(StockItemID) OVER (ORDER BY StockItemName) AS NextID,
  LAG(StockItemID) OVER (ORDER BY StockItemName) AS PrevID,
  ISNULL(LAG(StockItemName,2) OVER (ORDER BY StockItemName),'No items') AS Prev2StockItemName,
  NTILE(30) OVER (ORDER BY TypicalWeightPerUnit) AS GroupWeightPerUnit
FROM Warehouse.StockItems wsi

--4. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
--В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки
WITH CteQuery AS
(
  SELECT 
	ap.PersonID,
	ap.PreferredName,
	sc.CustomerID,
	sc.CustomerName,
	so.OrderDate,
	sil.ExtendedPrice,
	ROW_NUMBER() OVER (PARTITION BY ap.PersonID ORDER BY so.OrderDate DESC) RowNum
  FROM Sales.Orders so
	JOIN Sales.Invoices si ON si.OrderID=so.OrderID
	JOIN Sales.InvoiceLines sil ON sil.InvoiceID = si.InvoiceID
	JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
	JOIN Application.People ap ON ap.PersonID = so.SalespersonPersonID
)
SELECT * FROM CteQuery WHERE ROWNUM = 1

--5. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
--В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

WITH CteQuery AS
(
SELECT 
       sc.CustomerID,
       sc.CustomerName,
       sol.StockItemID,
       sol.UnitPrice,
	   so.OrderDate,
       ROW_NUMBER() OVER (PARTITION BY sc.CustomerID ORDER BY sol.UnitPrice DESC) AS RowNum
FROM Sales.Orders so
  JOIN Sales.OrderLines sol ON sol.OrderID=so.OrderID
  JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
)
SELECT CustomerID, CustomerName,StockItemID,UnitPrice,OrderDate 
FROM CteQuery
WHERE RowNum<=2
ORDER BY CustomerID

 