--Группировки и агрегатные функции
--1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
SELECT 
   YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate) as Period,
   AVG(sol.UnitPrice) AS AvgPrice,
   SUM(sol.UnitPrice) AS TotalSum
FROM Sales.Orders so
  JOIN Sales.OrderLines sol ON so.OrderID=sol.OrderID
GROUP BY YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate)

--2. Отобразить все месяцы, где общая сумма продаж превысила 10 000 
;WITH SalesByMonth AS
(
  SELECT 
    YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate) as Period,
    CONVERT(NUMERIC(15,2),AVG(sol.UnitPrice)) AS AvgPrice,
    SUM(sol.UnitPrice) AS TotalSum
  FROM Sales.Orders so
    JOIN Sales.OrderLines sol ON so.OrderID=sol.OrderID
  GROUP BY YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate)
)
SELECT * 
FROM SalesByMonth
WHERE TotalSum > 10000

/*3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи 
которых менее 50 ед в месяц. Группировка должна быть по году и месяцу.
*/

SELECT 
  wsi.StockItemName,
  YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate) as Period,
  SUM(sol.UnitPrice) AS TotalSum,
  MIN(so.OrderDate) AS FirstSalesOfMonth,
  SUM(sol.Quantity) AS QuantityOfMonth
FROM Sales.Orders so
  JOIN Sales.OrderLines sol ON so.OrderID=sol.OrderID
  JOIN Warehouse.StockItems wsi ON wsi.StockItemID = sol.StockItemID
GROUP BY YEAR(so.OrderDate) * 100 + MONTH(so.OrderDate),wsi.StockItemName
HAVING SUM(sol.Quantity)<50

/*3. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы. 
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


/*
4. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
Дано :
CREATE TABLE dbo.MyEmployees 
( 
EmployeeID smallint NOT NULL, 
FirstName nvarchar(30) NOT NULL, 
LastName nvarchar(40) NOT NULL, 
Title nvarchar(50) NOT NULL, 
DeptID smallint NOT NULL, 
ManagerID int NULL, 
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 
INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

Результат вывода рекурсивного CTE:
EmployeeID Name Title EmployeeLevel
1	Ken Sánchez	Chief Executive Officer	1
273	| Brian Welcker	Vice President of Sales	2
16	| | David Bradley	Marketing Manager	3
23	| | | Mary Gibson	Marketing Specialist	4
274	| | Stephen Jiang	North American Sales Manager	3
276	| | | Linda Mitchell	Sales Representative	4
275	| | | Michael Blythe	Sales Representative	4
285	| | Syed Abbas	Pacific Sales Manager	3
286	| | | Lynn Tsoflias	Sales Representative	4
*/

CREATE TABLE dbo.MyEmployees 
( 
EmployeeID smallint NOT NULL, 
FirstName nvarchar(30) NOT NULL, 
LastName nvarchar(40) NOT NULL, 
Title nvarchar(50) NOT NULL, 
DeptID smallint NOT NULL, 
ManagerID int NULL, 
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 
INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

;WITH CteRecurse AS
(
  SELECT EmployeeID,FirstName,LastName,Title,1 AS level,ManagerID
  FROM dbo.MyEmployees
  WHERE ManagerID is NULL
  UNION ALL
  SELECT t.EmployeeID, t.FirstName, t.LastName, t.Title,level + 1, t.ManagerID
  FROM dbo.MyEmployees t
    JOIN CteRecurse c ON t.ManagerID=c.EmployeeID
  WHERE c.level<5
)
SELECT LEFT(CONVERT(VARCHAR(10),t.EmployeeID) + SPACE(10),10) +
       REPLICATE(' | ',ISNULL(c.level,0)) +
       t.FirstName + ' ' + 
       t.LastName +  ' ' + 
       t.Title + ' ' +
       CONVERT(VARCHAR(10),ISNULL(c.level,0)+1) AS Result,
	   isnull(c.Level,0) AS Level,
	   t.EmployeeID,
       IIF(isnull(c.Level,0)<=1,0,1) AS Sort1,
	   IIF(t.EmployeeID=276,2,0) AS Sort2
INTO #TableCteRecurse 
FROM dbo.MyEmployees t
  LEFT JOIN CteRecurse c ON t.ManagerID=c.EmployeeID
  ORDER BY t.ManagerID


DECLARE @TableCteRecurse TABLE
( 
  Result VARCHAR(300),
  Level  smallint,
  EmployeeID smallint,
  Sort1 int,
  Sort2 int
)

;WITH CteRecurse AS
(
  SELECT EmployeeID,FirstName,LastName,Title,1 AS level,ManagerID
  FROM dbo.MyEmployees
  WHERE ManagerID is NULL
  UNION ALL
  SELECT t.EmployeeID, t.FirstName, t.LastName, t.Title,level + 1, t.ManagerID
  FROM dbo.MyEmployees t
    JOIN CteRecurse c ON c.EmployeeID=t.ManagerID
  WHERE c.level<5
)
INSERT INTO @TableCteRecurse (Result,Level,EmployeeID,Sort1,Sort2)
SELECT LEFT(CONVERT(VARCHAR(10),t.EmployeeID) + SPACE(10),10) +
       REPLICATE(' | ',ISNULL(c.level,0)) +
       t.FirstName + ' ' + 
       t.LastName +  ' ' + 
       t.Title + ' ' +
       CONVERT(VARCHAR(10),ISNULL(c.level,0)+1) AS Result,
	   isnull(c.Level,0) AS Level,
	   t.EmployeeID,
       IIF(isnull(c.Level,0)<=1,0,1) AS Sort1,
	   IIF(t.EmployeeID=276,2,0) AS Sort2
FROM dbo.MyEmployees t
  LEFT JOIN CteRecurse c ON t.ManagerID=c.EmployeeID

SELECT Result FROM #TableCteRecurse ORDER BY Sort1,EmployeeID-Sort2
SELECT Result FROM @TableCteRecurse ORDER BY Sort1,EmployeeID-Sort2

DROP TABLE dbo.MyEmployees
DROP TABLE #TableCteRecurse
