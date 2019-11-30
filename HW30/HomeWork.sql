--1.Создадим новую файловую группу, для архивных данных

ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [ArcDateWWI]
GO

ALTER DATABASE [WideWorldImporters] ADD FILE 
( NAME = N'ArcDateWWI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQL2017\MSSQL\DATA\ArcDateWWI.ndf' , 
SIZE = 2097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [ArcDateWWI]

--2.Часть данных таблицы Sales.OrderLines мы решили разместить в отдельном фйле, секционировать будет по OrderLineID
-- Создадим функцию и схему секционирования
GO
CREATE PARTITION FUNCTION [fnArcDateWWIPartition](INT) AS RANGE LEFT FOR VALUES
(0,100000,200000,300000,400000,500000);																																																									
GO


CREATE PARTITION SCHEME [schmArcDateWWIPartition] AS PARTITION [fnArcDateWWIPartition] 
TO ([ArcDateWWI],[ArcDateWWI],[ArcDateWWI],[UserData],[UserData],[UserData],[UserData])
GO

--3.Создадим копию таблицы Sales.OrderLines с применением секционирования
CREATE TABLE [Sales].[OrderLinesPartic](
	[OrderLineID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[PackageTypeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[PickedQuantity] [int] NOT NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL
) ON [schmArcDateWWIPartition] ([OrderLineID])

ALTER TABLE [Sales].[OrderLinesPartic] ADD CONSTRAINT [PK_Sales_OrderLinesPartic] PRIMARY KEY CLUSTERED ([OrderLineID])
ON [schmArcDateWWIPartition] ([OrderLineID]);

-- 4. Перенесем данные в таблицу Sales.OrderLinesPartic, будем считать, что данных там очень много. Процедуру можно прерывать и запускать 
-- предполагаем, что перенос данных займет не один день

Declare @Step Int = 1000,
        @Cnt  Int = 0,  
        @CntRowCopy  Int

Set RowCount @Step
Select @CntRowCopy = count(*) From Sales.OrderLines
Print N'Перенос ' + Convert(Varchar(15),@CntRowCopy) + N' записей, по ' + Convert(Varchar(10),@Step) + N' шт.' 
While @Cnt < @CntRowCopy
  Begin
    INSERT Into Sales.OrderLinesPartic 
	Select * From Sales.OrderLines ol 
	Where ol.OrderLineID > isnull((Select Top 1 olp.OrderLineID From Sales.OrderLinesPartic olp Order by olp.OrderLineID Desc),0)
	Order by ol.OrderLineID
    Set @Cnt=@Cnt+@@rowcount
	If @cnt%10000 = 0 
      Print @Cnt
  End;
Set RowCount 0

--5. На новую таблицу настраиваем ограничения,устанавливаем последовательность на ключ 
ALTER TABLE [Sales].[OrderLinesPartic] ADD  CONSTRAINT [DF_Sales_OrderLinesPartic_OrderLineID]  DEFAULT (NEXT VALUE FOR [Sequences].[OrderLineID]) FOR [OrderLineID]
ALTER TABLE [Sales].[OrderLinesPartic] ADD  CONSTRAINT [DF_Sales_OrderLinesPartic_LastEditedWhen]  DEFAULT (sysdatetime()) FOR [LastEditedWhen]
ALTER TABLE [Sales].[OrderLinesPartic]  WITH CHECK ADD  CONSTRAINT [FK_Sales_OrderLinesPartic_Application_People] FOREIGN KEY([LastEditedBy])
REFERENCES [Application].[People] ([PersonID])
ALTER TABLE [Sales].[OrderLinesPartic] CHECK CONSTRAINT [FK_Sales_OrderLinesPartic_Application_People]
ALTER TABLE [Sales].[OrderLinesPartic]  WITH CHECK ADD  CONSTRAINT [FK_Sales_OrderLinesPartic_OrderID_Sales_Orders] FOREIGN KEY([OrderID])
REFERENCES [Sales].[Orders] ([OrderID])
ALTER TABLE [Sales].[OrderLinesPartic] CHECK CONSTRAINT [FK_Sales_OrderLinesPartic_OrderID_Sales_Orders]
ALTER TABLE [Sales].[OrderLinesPartic]  WITH CHECK ADD  CONSTRAINT [FK_Sales_OrderLinesPartic_PackageTypeID_Warehouse_PackageTypes] FOREIGN KEY([PackageTypeID])
REFERENCES [Warehouse].[PackageTypes] ([PackageTypeID])
ALTER TABLE [Sales].[OrderLinesPartic] CHECK CONSTRAINT [FK_Sales_OrderLinesPartic_PackageTypeID_Warehouse_PackageTypes]
ALTER TABLE [Sales].[OrderLinesPartic]  WITH CHECK ADD  CONSTRAINT [FK_Sales_OrderLinesPartic_StockItemID_Warehouse_StockItems] FOREIGN KEY([StockItemID])
REFERENCES [Warehouse].[StockItems] ([StockItemID])
ALTER TABLE [Sales].[OrderLinesPartic] CHECK CONSTRAINT [FK_Sales_OrderLinesPartic_StockItemID_Warehouse_StockItems]

--6. Здесь можем заменить одну таблицу другой
drop table Sales.OrderLines
exec sp_rename 'Sales.OrderLinesPartic', 'OrderLines'

--7. Запрос показывающий разделения данных по файловым группам (взял отсюда: https://habr.com/ru/post/464665/)
SELECT
    sc.name + N'.' + so.name as [Schema.Table],
--    si.index_id as [Index ID],
--    si.type_desc as [Structure],
--    si.name as [Index],
    stat.row_count AS [Rows],
    stat.in_row_reserved_page_count * 8./1024./1024. as [In-Row GB],
    stat.lob_reserved_page_count * 8./1024./1024. as [LOB GB],
    p.partition_number AS [Partition #],
--    pf.name as [Partition Function],
    CASE pf.boundary_value_on_right
        WHEN 1 then 'Right / Lower'
        ELSE 'Left / Upper'
    END as [Boundary Type],
    prv.value as [Boundary Point],
    fg.name as [Filegroup]
FROM sys.partition_functions AS pf
JOIN sys.partition_schemes as ps on ps.function_id=pf.function_id
JOIN sys.indexes as si on si.data_space_id=ps.data_space_id
JOIN sys.objects as so on si.object_id = so.object_id
JOIN sys.schemas as sc on so.schema_id = sc.schema_id
JOIN sys.partitions as p on 
    si.object_id=p.object_id 
    and si.index_id=p.index_id
LEFT JOIN sys.partition_range_values as prv on prv.function_id=pf.function_id
    and p.partition_number= 
        CASE pf.boundary_value_on_right WHEN 1
            THEN prv.boundary_id + 1
        ELSE prv.boundary_id
        END
        /* For left-based functions, partition_number = boundary_id, 
           for right-based functions we need to add 1 */
JOIN sys.dm_db_partition_stats as stat on stat.object_id=p.object_id
    and stat.index_id=p.index_id
    and stat.index_id=p.index_id and stat.partition_id=p.partition_id
    and stat.partition_number=p.partition_number
JOIN sys.allocation_units as au on au.container_id = p.hobt_id
    and au.type_desc ='IN_ROW_DATA' 
        /* Avoiding double rows for columnstore indexes. */
        /* We can pick up LOB page count from partition_stats */
JOIN sys.filegroups as fg on fg.data_space_id = au.data_space_id
WHERE pf.name = 'fnArcDateWWIPartition'
ORDER BY [Schema.Table], [Partition #];

--8. При необходимости перенести в архив очередную порцию данных - например с OrderLineID c 200000 до 300000
Alter Partition Function fnArcDateWWIPartition() MERGE RANGE ('300000');
Alter Partition Scheme [schmArcDateWWIPartition] NEXT USED [ArcDateWWI]
Alter Partition Function fnArcDateWWIPartition() SPLIT RANGE ('300000');

--9. Таблица будет расти, при необходимости добавить новый секцию в конец таблицы 
Alter Partition Scheme [schmArcDateWWIPartition] NEXT USED [UserData]
Alter Partition Function fnArcDateWWIPartition() SPLIT RANGE ('600000');