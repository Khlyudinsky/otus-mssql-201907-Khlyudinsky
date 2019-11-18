/*
 Анализируем план запроса, теперь 63% от времени выполнения занимает скан индекса PK_Sales_Invoices.
 По итогам: 
 1. Создал индекс CREATE INDEX IX_Sales_Invpices_OrderID_BillToCustomerID ON Sales.Invoices (OrderID,CustomerID,InvoiceDate)
*/

/*
Итог: - уменьшилась статистика по цпу и затраченному времени. Также сильно уменьшилось количество логических чтений.
Есть сомнения стоит ли в данном случае создавать индекс, предлагаю на этом остановится.
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
  JOIN Sales.Invoices  AS Inv ON Inv.OrderID = ord.OrderID 
    AND Inv.BillToCustomerID != ord.CustomerID 
    AND Inv.InvoiceDate = Ord.OrderDate
  JOIN Warehouse.StockItems AS It ON It.StockItemID = det.StockItemID
    AND It.SupplierId = 12
  JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID 
  JOIN CteQuery AS cq ON cq.CustomerID = ord.CustomerID
    AND cq.TotalSum > 250000    
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID
 
/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 47 ms, elapsed time = 69 ms.

(3619 rows affected)
Table 'StockItemTransactions'. Scan count 1, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 66, lob physical reads 1, lob read-ahead reads 130.
Table 'StockItemTransactions'. Segment reads 1, segment skipped 0.
Table 'OrderLines'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 518, lob physical reads 5, lob read-ahead reads 795.
Table 'OrderLines'. Segment reads 2, segment skipped 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Orders'. Scan count 2, logical reads 883, physical reads 4, read-ahead reads 849, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Invoices'. Scan count 1, logical reads 189, physical reads 0, read-ahead reads 180, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'StockItems'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 390 ms,  elapsed time = 483 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

Completion time: 2019-11-18T14:30:52.5540783+03:00
*/