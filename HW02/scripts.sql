-- 1. ��� ������, � ������� � �������� ���� ������� urgent ��� �������� ���������� � Animal
SELECT StockItemName
FROM Warehouse.StockItems (NOLOCK)
WHERE (StockItemName LIKE '%urgent%' 
  OR StockItemName LIKE 'Animal%')

go

-- 2. �����������, � ������� �� ���� ������� �� ������ ������ 
SELECT ps.SupplierName, ps.SupplierID 
FROM Purchasing.Suppliers ps (NOLOCK)
  LEFT JOIN Purchasing.SupplierTransactions pst (NOLOCK)
    ON pst.SupplierID = ps.SupplierID
WHERE pst.SupplierID is Null

go

/* 3. ������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� 
�������, �������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, ���� ������ 
������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20. */

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

/* ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 
100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� �������. */

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

/* 4. ������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, 
�������� �������� ����������, ��� ����������� ���� ������������ ����� */

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

-- 5. 10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����.
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

-- 6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g
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

