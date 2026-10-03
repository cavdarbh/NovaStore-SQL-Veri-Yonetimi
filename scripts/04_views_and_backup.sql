USE NovaStoreDB;
GO

-- -----------------------------------------------------------------------------
-- 1. GÖREV: View (Görünüm) Oluşturma
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.vw_SiparisOzet', 'V') IS NOT NULL
    DROP VIEW dbo.vw_SiparisOzet;
GO

CREATE VIEW vw_SiparisOzet
AS
SELECT 
    c.FullName AS MusteriAdi,
    o.OrderDate AS SiparisTarihi,
    p.ProductName AS UrunAdi,
    od.Quantity AS Adet
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.CustomerID = o.CustomerID
INNER JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN 
    Products p ON od.ProductID = p.ProductID;
GO

-- Test Etme / Görüntüleme (CREATE VIEW VE SELECT * FROM ÇAKIŞMASINI ÖNLEMEK İÇİN YORUM SATIRI ŞEKLİNDE BIRAKILMIŞTIR):
 SELECT * FROM vw_SiparisOzet;
 GO

-- -----------------------------------------------------------------------------
-- 2. GÖREV: Veri Tabanı Yedekleme (Backup)
-- -----------------------------------------------------------------------------
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH 
    FORMAT,
    MEDIANAME = 'NovaStoreDB_FullBackup',
    NAME = 'Full Backup of NovaStoreDB';
GO