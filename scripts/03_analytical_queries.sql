USE NovaStoreDB;
GO

-- -----------------------------------------------------------------------------
-- SORGU 1: Temel Listeleme (Kritik Stok Raporu)
-- Soru: Stok miktarı 20'den az olan ürünlerin adını ve stok miktarını,
--       stok miktarına göre AZALAN (DESC) sırada listeleyin.
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- SORGU 2: Veri Birleştirme (Sipariş & Müşteri Listesi)
-- Soru: Hangi müşteri, hangi tarihte sipariş vermiş? 
--       Sonuçta Müşteri Adı, Şehir, Sipariş Tarihi ve Toplam Tutar gözüksün.
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- SORGU 3: Çoklu Birleştirme ve Detay Raporu (Müşteri Sepet Geçmişi)
-- Soru: "Ahmet Yılmaz" isimli müşterinin aldığı ürünlerin isimlerini, 
--       fiyatlarını ve kategorilerini listeleyin.
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- SORGU 4: Gruplama ve Kategori Envanter Raporu
-- Soru: Hangi kategoride toplam kaç adet ürünümüz var?
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- SORGU 5: Ciro Analizi (Müşteri Başına Kazanç Raporu)
-- Soru: Her müşterinin şirkete kazandırdığı toplam ciro nedir? 
--       En çok harcama yapan müşteriden en aza doğru sıralayın.
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- SORGU 6: Zaman Analizi (Sipariş Yaşlandırma Raporu)
-- Soru: Bugünün tarihine göre, siparişlerin üzerinden kaç gün geçtiğini hesaplayın.
-- -----------------------------------------------------------------------------
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