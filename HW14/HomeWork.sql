exec sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
exec sp_configure 'clr enabled', 1 
GO 
RECONFIGURE; 
GO
exec sp_configure 'clr strict security', 0
GO 
RECONFIGURE;

Create Assembly TestClr from N'C:\Обучение\otus-mssql-201907-Khlyudinsky\HW14\TestClr.dll'
GO

CREATE PROCEDURE GetUserName AS EXTERNAL NAME TestClr.CalcExpression.GetUserName;
GO

CREATE FUNCTION Calculate (@expression NVARCHAR(4000))
RETURNS NVARCHAR(4000)
AS
EXTERNAL NAME TestClr.CalcExpression.Calculate;
Go

EXEC GetUserName  
SELECT dbo.Calculate('5+2*2*2')
