-- =============================================================================
-- PROJE: NovaStore E-Ticaret Veri Yönetim Sistemi
-- GELİŞTİRİCİ: Berke Han Çavdar
-- KAPSAM: DDL, DML, DQL, Views, Backup
-- =============================================================================

-- =============================================================================
-- BÖLÜM 1: VERİ TABANI VE TABLO TASARIMI (DDL)
-- =============================================================================

-- 1. Veri Tabanını Oluşturma
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'NovaStoreDB')
BEGIN
    CREATE DATABASE NovaStoreDB;
END
GO

USE NovaStoreDB;
GO

-- 2. Tablo: Categories (Kategoriler)
-- Bağımsız ana tablo olduğu için ilk sırada oluşturulmaktadır.
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
    DROP TABLE dbo.Categories;
GO

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- 3. Tablo: Customers (Müşteriler)
-- Bağımsız ana tablo. E-posta adresi tekil (UNIQUE) kısıtına sahiptir.
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;
GO

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    City VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);
GO

-- 4. Tablo: Products (Ürünler)
-- Categories tablosuna CategoryID yabancı anahtarı (FK) ile bağlıdır.
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL CONSTRAINT DF_Products_Stock DEFAULT (0),
    CategoryID INT NOT NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) 
        REFERENCES Categories(CategoryID)
);
GO

-- 5. Tablo: Orders (Siparişler)
-- Customers tablosuna CustomerID yabancı anahtarı (FK) ile bağlıdır.
-- Sipariş tarihi sistem varsayılanı olarak GETDATE() alır.
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
    DROP TABLE dbo.Orders;
GO

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL CONSTRAINT DF_Orders_OrderDate DEFAULT (GETDATE()),
    TotalAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) 
        REFERENCES Customers(CustomerID)
);
GO

-- 6. Tablo: OrderDetails (Sipariş Detayları - Çoka Çok İlişki Ara Tablosu)
-- Orders ve Products tablolarına FK kısıtları ile bağlıdır.
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
    DROP TABLE dbo.OrderDetails;
GO

CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID)
);
GO


-- =============================================================================
-- BÖLÜM 2: ÖRNEK VERİ GİRİŞİ (DML - INSERT)
-- =============================================================================

-- Görev 1: 5 Adet Kategori Ekleme
INSERT INTO Categories (CategoryName) 
VALUES 
    ('Elektronik'),
    ('Giyim'),
    ('Kitap'),
    ('Kozmetik'),
    ('Ev ve Yaşam');
GO

-- Görev 2: 12 Adet Ürün Ekleme (Her kategoriye ait, farklı stok ve fiyatlarla)
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES 
    -- Elektronik
    ('Kablosuz Bluetooth Kulaklık', 1450.00, 15, 1),
    ('Mekanik Klavye', 2200.00, 8, 1),
    ('Akıllı Saat', 3500.00, 25, 1),
    -- Giyim
    ('Oversize Pamuklu T-Shirt', 350.00, 50, 2),
    ('Slim Fit Kot Pantolon', 750.00, 18, 2),
    ('Kapüşonlu Sweatshirt', 850.00, 30, 2),
    -- Kitap
    ('Yapay Zeka ve Gelecek', 120.00, 12, 3),
    ('SQL ile Veri Tabanı Mimarisi', 180.00, 40, 3),
    -- Kozmetik
    ('Nemlendirici Yüz Kremi', 290.00, 5, 4),
    ('Güneş Koruyucu Krem SPF 50', 420.00, 22, 4),
    -- Ev ve Yaşam
    ('Filtre Kahve Makinesi', 1850.00, 10, 5),
    ('Dekoratif Çalışma Lambası', 490.00, 35, 5);
GO

-- Görev 3: 6 Adet Müşteri Ekleme (Ahmet Yılmaz dahil)
INSERT INTO Customers (FullName, City, Email)
VALUES 
    ('Ahmet Yılmaz', 'İstanbul', 'ahmet.yilmaz@novastore.com'),
    ('Zeynep Kaya', 'Ankara', 'zeynep.kaya@novastore.com'),
    ('Mehmet Demir', 'İzmir', 'mehmet.demir@novastore.com'),
    ('Ayşe Çelik', 'Bursa', 'ayse.celik@novastore.com'),
    ('Caner Erkin', 'Antalya', 'caner.erkin@novastore.com'),
    ('Elif Şahin', 'İstanbul', 'elif.sahin@novastore.com');
GO

-- Görev 4: Farklı Tarihlerde 10 Adet Sipariş Ekleme
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES 
    (1, DATEADD(DAY, -45, GETDATE()), 3650.00),
    (2, DATEADD(DAY, -30, GETDATE()), 750.00),
    (3, DATEADD(DAY, -25, GETDATE()), 2200.00),
    (1, DATEADD(DAY, -18, GETDATE()), 470.00),
    (4, DATEADD(DAY, -12, GETDATE()), 1200.00),
    (5, DATEADD(DAY, -8, GETDATE()), 1850.00),
    (2, DATEADD(DAY, -5, GETDATE()), 1450.00),
    (6, DATEADD(DAY, -3, GETDATE()), 290.00),
    (1, DATEADD(DAY, -2, GETDATE()), 1850.00),
    (3, DATEADD(DAY, -1, GETDATE()), 700.00);
GO

-- Sipariş Detayları (OrderDetails) Ekleme
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
    (1, 3, 1),
    (1, 8, 1),
    (2, 5, 1),
    (3, 2, 1),
    (4, 4, 1),
    (4, 7, 1),
    (5, 6, 1),
    (5, 9, 1),
    (6, 11, 1),
    (7, 1, 1),
    (8, 9, 1),
    (9, 11, 1),
    (10, 4, 2);
GO


-- =============================================================================
-- BÖLÜM 3: SORGULAMA VE İŞ ANALİTİĞİ RAPORLARI (DQL)
-- =============================================================================

-- SORGU 1: Temel Listeleme (Kritik Stok Raporu)
-- Soru: Stok miktarı 20'den az olan ürünlerin adını ve stok miktarını,
--       stok miktarına göre AZALAN (DESC) sırada listeleyin.
SELECT 
    ProductName,
    Stock
FROM 
    Products
WHERE 
    Stock < 20
ORDER BY 
    Stock DESC;
GO

-- SORGU 2: Veri Birleştirme (Sipariş & Müşteri Listesi)
-- Soru: Hangi müşteri, hangi tarihte sipariş vermiş? 
--       Sonuçta Müşteri Adı, Şehir, Sipariş Tarihi ve Toplam Tutar gözüksün.
SELECT 
    c.FullName AS MusteriAdi,
    c.City AS Sehir,
    o.OrderDate AS SiparisTarihi,
    o.TotalAmount AS ToplamTutar
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.CustomerID = o.CustomerID
ORDER BY 
    o.OrderDate DESC;
GO

-- SORGU 3: Çoklu Birleştirme ve Detay Raporu (Ahmet Yılmaz'ın Sepet Geçmişi)
-- Soru: "Ahmet Yılmaz" isimli müşterinin aldığı ürünlerin isimlerini, 
--       fiyatlarını ve kategorilerini listeleyin.
SELECT 
    c.FullName AS MusteriAdi,
    p.ProductName AS UrunAdi,
    p.Price AS BirimFiyat,
    cat.CategoryName AS KategoriAdi
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.CustomerID = o.CustomerID
INNER JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN 
    Products p ON od.ProductID = p.ProductID
INNER JOIN 
    Categories cat ON p.CategoryID = cat.CategoryID
WHERE 
    c.FullName = 'Ahmet Yılmaz';
GO

-- SORGU 4: Gruplama ve Kategori Envanter Raporu
-- Soru: Hangi kategoride toplam kaç adet ürünümüz var?
SELECT 
    cat.CategoryName AS KategoriAdi,
    COUNT(p.ProductID) AS ToplamUrunCesidi
FROM 
    Categories cat
LEFT JOIN 
    Products p ON cat.CategoryID = p.CategoryID
GROUP BY 
    cat.CategoryID, cat.CategoryName
ORDER BY 
    ToplamUrunCesidi DESC;
GO

-- SORGU 5: Ciro Analizi (Müşteri Başına Kazanç Raporu)
-- Soru: Her müşterinin şirkete kazandırdığı toplam ciro nedir? 
--       En çok harcama yapan müşteriden en aza doğru sıralayın.
SELECT 
    c.CustomerID,
    c.FullName AS MusteriAdi,
    c.City AS Sehir,
    SUM(o.TotalAmount) AS ToplamKazandirilanCiro
FROM 
    Customers c
INNER JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.FullName, c.City
ORDER BY 
    ToplamKazandirilanCiro DESC;
GO

-- SORGU 6: Zaman Analizi (Sipariş Yaşlandırma Raporu)
-- Soru: Bugünün tarihine göre, siparişlerin üzerinden kaç gün geçtiğini hesaplayın.
SELECT 
    o.OrderID AS SiparisNo,
    c.FullName AS MusteriAdi,
    o.OrderDate AS SiparisTarihi,
    CAST(GETDATE() AS DATE) AS BugununTarihi,
    DATEDIFF(DAY, o.OrderDate, GETDATE()) AS GecenGunSayisi
FROM 
    Orders o
INNER JOIN 
    Customers c ON o.CustomerID = c.CustomerID
ORDER BY 
    GecenGunSayisi ASC;
GO


-- =============================================================================
-- BÖLÜM 4: İLERİ SEVİYE VERİ TABANI NESNELERİ (VIEW & BACKUP)
-- =============================================================================

-- 1. View Oluşturma: vw_SiparisOzet
-- Müşteri Adı, Sipariş Tarihi, Ürün Adı ve Adet bilgilerini birleştirir.
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

-- 2. Yedekleme Komutu: BACKUP DATABASE
-- NovaStoreDB veri tabanını C:\Yedek klasörüne tam (FULL) yedekler.
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH 
    FORMAT,
    MEDIANAME = 'NovaStoreDB_FullBackup',
    NAME = 'Full Backup of NovaStoreDB';
GO