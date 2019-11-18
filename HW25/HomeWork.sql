Set statistics io, time on

DBCC FREEPROCCACHE
GO
DBCC DROPCLEANBUFFERS
GO
DBCC FREESYSTEMCACHE('All')
GO
DBCC FREESESSIONCACHE
GO


Select ord.CustomerID
      ,det.StockItemID
      ,SUM(det.UnitPrice)
      ,SUM(det.Quantity)
      ,COUNT(ord.OrderID)	
FROM Sales.Orders AS ord 
  JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
  JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
  JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
  JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
WHERE Inv.BillToCustomerID != ord.CustomerID 
  AND (Select SupplierId 
       FROM Warehouse.StockItems AS It 
	   Where It.StockItemID = det.StockItemID
      ) = 12 
  AND (SELECT SUM(Total.UnitPrice*Total.Quantity) 
       FROM Sales.OrderLines AS Total 
	     Join Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
	   WHERE ordTotal.CustomerID = Inv.CustomerID
      ) > 250000 
  AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID
/*
SQL Server parse and compile time: 
   CPU time = 79 ms, elapsed time = 95 ms.

(3619 rows affected)
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 66, lob physical reads 1, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 77069, physical reads 2, read-ahead reads 11630, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 515 ms,  elapsed time = 724 ms.

Completion time: 2019-11-18T12:25:40.5861383+03:00
*/
