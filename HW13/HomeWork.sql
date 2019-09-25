/*Домашнее задание
SP и function
1) Написать функцию возвращающую Клиента с набольшей
суммой покупки.
*/

CREATE FUNCTION dbo.CustomerBigestSales()
RETURNS NVARCHAR(100)
AS
BEGIN
RETURN
(
  SELECT TOP 1 MAX(sc.CustomerName) FROM Sales.InvoiceLines sil
    JOIN Sales.Invoices si ON si.InvoiceID=sil.InvoiceID
	JOIN Sales.Customers sc ON sc.CustomerID=si.CustomerID
  GROUP BY si.InvoiceID
  ORDER BY SUM(sil.ExtendedPrice) DESC
);
END

SELECT dbo.CustomerBigestSales()

/*
2) Написать хранимую процедуру с входящим параметром
СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

CREATE PROCEDURE GetQtySalesByCustomer
  @CustomerID int,
  @Qty DECIMAL(18,2) OUTPUT
AS
BEGIN
 SELECT TOP 1 @Qty = SUM(sil.ExtendedPrice) FROM Sales.InvoiceLines sil
    JOIN Sales.Invoices si ON si.InvoiceID=sil.InvoiceID
	JOIN Sales.Customers sc ON sc.CustomerID=si.CustomerID
  WHERE sc.CustomerID = @CustomerID
  GROUP BY si.InvoiceID
  ORDER BY SUM(sil.ExtendedPrice) DESC
END

DECLARE @Qty DECIMAL(18,2)
EXEC GetQtySalesByCustomer 834, @Qty OUTPUT
SELECT @Qty

--3) Cоздать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему

CREATE FUNCTION dbo.SampleFunction(@CustomerID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
RETURN
(
  SELECT CustomerName FROM Sales.Customers WHERE CustomerID=@CustomerID
)
END

CREATE PROCEDURE dbo.SampleProcedure
  @CustomerID INT,
  @CustomerName NVARCHAR(100) OUTPUT
AS
BEGIN
  SELECT @CustomerName = CustomerName FROM Sales.Customers WHERE CustomerID=@CustomerID
END

GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
--DBCC FREEPROCCACHE WITH NO_INFOMSGS

DECLARE @CustomerID INT,
        @CustomerNameP NVARCHAR(100)

SET @CustomerID = 834
EXEC dbo.SampleProcedure 
                         @CustomerID=@CustomerID, 
                         @CustomerName = @CustomerNameP OUTPUT
SELECT @CustomerNameP

GO

DECLARE @CustomerID INT,
	@CustomerNameF NVARCHAR(100)   

SET @CustomerID = 834
SET @CustomerNameF = dbo.SampleFunction(@CustomerID)
SELECT @CustomerNameF

/* При выполнении функции план вообще не создался, статистика времени и ввода вывода - примерно одинаковая для функции и процедуры. Однако 
при повторных запусках на ОДИНАКОВЫХ значениях входного параметра, функция выдает нулевые значения статистик, предполагаю информация кэшируется. 
Для процедуры такого не происходит. 
*/


--4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
CREATE FUNCTION dbo.MyTableFunction (@MaskCustomerName NVARCHAR(100))  
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT CustomerName,CustomerID FROM Sales.Customers WHERE CustomerName LIKE @MaskCustomerName
);  

DECLARE @Mask NVARCHAR(100),
        @ReplaceMask NVARCHAR(100)
SET @MASK = '%Toys%'
SET @ReplaceMask = REPLACE(REPLACE(@MASK,'%',''),'_','')
SELECT CustomerName, 
       CustomerID,
	   REPLACE(CustomerName,@ReplaceMask,UPPER(@ReplaceMask)) AS CustomerNameNew 
FROM dbo.MyTableFunction(@MASK)

/* 5-е задание не понял, похоже ошибочно дано? До уровней изоляции мы еще не дошли */
--Во всех процедурах, в описании укажите для преподавателям
--5) какой уровень изоляции нужен и почему. 


