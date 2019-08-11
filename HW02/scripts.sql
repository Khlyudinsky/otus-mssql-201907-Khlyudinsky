-- 1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
SELECT StockItemName
FROM Warehouse.StockItems (NOLOCK)
WHERE (StockItemName LIKE '%urgent%' 
  OR StockItemName LIKE 'Animal%')

go

-- 2. Поставщиков, у которых не было сделано ни одного заказа 
SELECT ps.SupplierName, ps.SupplierID 
FROM Purchasing.Suppliers ps (NOLOCK)
  LEFT JOIN Purchasing.SupplierTransactions pst (NOLOCK)
    ON pst.SupplierID = ps.SupplierID
WHERE pst.SupplierID is Null

go

/* 3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится 
продажа, включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора 
заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. */

SELECT sct.CustomerTransactionID,
       DATENAME(mm,sct.TransactionDate) AS MonthName,
       DATEPART(qq,sct.TransactionDate) AS NumberQuarter,
       DATEPART(mm,sct.TransactionDate)/3 + 1 AS OneThirdOfYear,
       sct.TransactionDate,
       sil.Description
FROM Sales.CustomerTransactions  sct (NOLOCK)
  LEFT JOIN Sales.InvoiceLines sil (NOLOCK)
    ON sct.InvoiceID = sil.InvoiceID
WHERE sct.FinalizationDate is not Null
  AND (sil.UnitPrice > 100 OR sil.Quantity>20)
ORDER BY NumberQuarter,OneThirdOfYear,sct.TransactionDate

go

/* вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 
100 записей. Соритровка должна быть по номеру квартала, трети года, дате продажи. */

SELECT DATENAME(mm,sct.TransactionDate) AS MonthName,
       DATEPART(qq,sct.TransactionDate) AS NumberQuarter,
       DATEPART(mm,sct.TransactionDate)/3 + 1 AS OneThirdOfYear,
       sct.TransactionDate,
       sil.Description
FROM Sales.CustomerTransactions sct (NOLOCK)
  LEFT JOIN Sales.InvoiceLines sil (NOLOCK)
    ON sct.InvoiceID = sil.InvoiceID
WHERE sct.FinalizationDate is not Null
  AND (sil.UnitPrice > 100 OR sil.Quantity>20)
ORDER BY NumberQuarter,OneThirdOfYear,sct.TransactionDate
OFFSET 1000 ROWS FETCH FIRST 100 ROWS ONLY;

go

/* 4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, 
добавьте название поставщика, имя контактного лица принимавшего заказ */

SELECT DISTINCT 
       pst.SupplierTransactionID,
       ps.SupplierName,
       ap.FullName
FROM Purchasing.SupplierTransactions pst (NOLOCK)
  INNER JOIN Purchasing.Suppliers ps (NOLOCK)
    ON ps.SupplierID  = pst.SupplierID
  INNER JOIN Application.DeliveryMethods adm (NOLOCK)
    ON adm.DeliveryMethodID = ps.DeliveryMethodID
	AND adm.DeliveryMethodName in ('Road Freight','Post')
  INNER JOIN Purchasing.PurchaseOrders po (NOLOCK)
    on pst.PurchaseOrderID  = po.PurchaseOrderID
  INNER JOIN Application.People ap (NOLOCK)
    on po.ContactPersonID = ap.PersonID
WHERE pst.TransactionDate >= '2014-01-01' 
  AND pst.TransactionDate <= '2014-12-31'

go

-- 5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.
SELECT TOP 10 sct.CustomerTransactionID,
              sc.CustomerName,
              ap.FullName
FROM Sales.CustomerTransactions  sct (NOLOCK)
  INNER JOIN Sales.Invoices si (NOLOCK)
    ON si.InvoiceID = sct.InvoiceID
  INNER JOIN Sales.Orders so (NOLOCK)
    ON si.OrderID = so.OrderID
  INNER JOIN Application.People ap (NOLOCK)
    ON so.SalespersonPersonID = ap.PersonID 
  INNER JOIN Sales.Customers sc (NOLOCK)
    ON sc.CustomerID = sct.CustomerID
ORDER BY sct.TransactionDate DESC

go

-- 6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
SELECT DISTINCT
       sc.CustomerID,
       sc.CustomerName,
	   sc.PhoneNumber	   
FROM Sales.Invoices si (NOLOCK)
  INNER JOIN Sales.InvoiceLines sil (NOLOCK)
    ON si.InvoiceID = sil.InvoiceID
  INNER JOIN Warehouse.StockItems wsi (NOLOCK)
    ON sil.StockItemID = wsi.StockItemID
	AND wsi.StockItemName = 'Chocolate frogs 250g'
  INNER JOIN Sales.Customers sc (NOLOCK)
    ON si.CustomerID = sc.CustomerID

