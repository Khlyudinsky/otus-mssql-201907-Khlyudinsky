/*
 Уберем функцию из WHERE
*/

/*
Итог: - немного уменьшилась статистика по цпу и затраченному времени,
дальше работаем с запросом который у нас получился на этом шаге.
*/

WITH CteQuery AS
(
SELECT SUM(Total.UnitPrice*Total.Quantity) OVER(PARTITION BY ordTotal.CustomerID) AS TotalSum,
       ordTotal.CustomerID 
       FROM Sales.OrderLines AS Total 
         JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID 
)
Select ord.CustomerID
      ,det.StockItemID
      ,SUM(det.UnitPrice)
      ,SUM(det.Quantity)
      ,COUNT(ord.OrderID)	
FROM Sales.Orders AS ord 
  JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID 
  JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID 
  JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID 
  JOIN Warehouse.StockItems AS It ON It.StockItemID = det.StockItemID
    AND It.SupplierId = 12
  JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
  JOIN CteQuery AS cq ON cq.CustomerID= Inv.CustomerID
    AND cq.TotalSum > 250000    
WHERE Inv.BillToCustomerID != ord.CustomerID 
  AND Inv.InvoiceDate = Ord.OrderDate
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID
 
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 109 ms, elapsed time = 112 ms.

(3619 rows affected)
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 66, lob physical reads 1, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 11400, physical reads 3, read-ahead reads 11388, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'CustomerTransactions'. Scan count 5, logical reads 261, physical reads 4, read-ahead reads 253, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 688 ms,  elapsed time = 998 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-18T12:54:46.8599440+03:00
*/