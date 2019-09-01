/*Pivot и Cross Apply
1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
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
 

SELECT InvoiceMonth,[Tailspin Toys (Sylvanite, MT)],[Tailspin Toys (Peeples Valley, AZ)],[Tailspin Toys (Medicine Lodge, KS)],[Tailspin Toys (Gasport, NY)],[Tailspin Toys (Jessie, ND)] FROM
(
  SELECT
  sc.CustomerID,
  sc.CustomerName,
  Convert(Varchar,dateadd(dd,1-datepart(dd,so.OrderDate),so.OrderDate),104) AS InvoiceMonth,
  Convert(Date,dateadd(dd,1-datepart(dd,so.OrderDate),so.OrderDate),104) AS InvoiceMonthSort
  FROM Sales.Orders so
    JOIN Sales.Customers sc ON so.CustomerID = sc.CustomerID
  WHERE sc.CustomerID BETWEEN 2 AND 6
) AS Table1
PIVOT (
        COUNT(CustomerID)
        FOR CustomerName IN ([Tailspin Toys (Sylvanite, MT)],[Tailspin Toys (Peeples Valley, AZ)],[Tailspin Toys (Medicine Lodge, KS)],[Tailspin Toys (Gasport, NY)],[Tailspin Toys (Jessie, ND)])
      )
AS PVT
ORDER BY InvoiceMonthSort;

/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName AddressLine
Tailspin Toys (Head Office) Shop 38
Tailspin Toys (Head Office) 1877 Mittal Road
Tailspin Toys (Head Office) PO Box 8975
Tailspin Toys (Head Office) Ribeiroville
.....
*/
WITH CteCustomers AS
(
  SELECT *
  FROM Sales.Customers
  WHERE CHARINDEX('Tailspin Toys',CustomerName) > 0   
)
SELECT CustomerName,AddressLine 
FROM CteCustomers
UNPIVOT (AddressLine FOR AddressName IN ([DeliveryAddressLine1],[DeliveryAddressLine2],[PostalAddressLine1],[PostalAddressLine2])) AS Unpt;

/*
3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId CountryName Code
1 Afghanistan AFG
1 Afghanistan 4
3 Albania ALB
3 Albania 8
*/
WITH CteCountries AS
(
  SELECT CountryID,CountryName,IsoAlpha3Code,CONVERT(nvarchar(3),IsoNumericCode) AS IsoNumericCode
  FROM Application.Countries
)
SELECT  CountryID,CountryName,Code
FROM CteCountries
UNPIVOT (Code FOR CodeName IN ([IsoAlpha3Code],[IsoNumericCode])) AS Unpvt

/*
4. Перепишите ДЗ из оконных функций через CROSS APPLY
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки
*/
;WITH CteQuery AS
(
SELECT 
       sc.CustomerID,
       sc.CustomerName,
       sol.StockItemID,
       sol.UnitPrice,
	   so.OrderDate
FROM Sales.Orders so
  JOIN Sales.OrderLines sol ON sol.OrderID=so.OrderID
  JOIN Sales.Customers sc ON sc.CustomerID = so.CustomerID
)
SELECT DISTINCT c2.* 
FROM CteQuery c1
  CROSS APPLY (SELECT TOP 2 * FROM CteQuery WHERE c1.CustomerID=CustomerID ORDER BY UnitPrice DESC) c2
ORDER BY CustomerID
