USE NovaStoreDB;
GO

-- 1. Görev 1: 5 Adet Kategori Ekleme
INSERT INTO Categories (CategoryName) 
VALUES 
    ('Elektronik'),
    ('Giyim'),
    ('Kitap'),
    ('Kozmetik'),
    ('Ev ve Yaşam');
GO

-- 2. Görev 2: 12 Adet Ürün Ekleme (Her kategoriye ait, farklı stok ve fiyatlarla)
INSERT INTO Products (ProductName, Price, Stock, CategoryID)
VALUES 
    -- Elektronik
    ('Kablosuz Bluetooth Kulaklık', 1450.00, 15, 1),  -- Stok < 20
    ('Mekanik Klavye', 2200.00, 8, 1),                -- Stok < 20
    ('Akıllı Saat', 3500.00, 25, 1),
    -- Giyim
    ('Oversize Pamuklu T-Shirt', 350.00, 50, 2),
    ('Slim Fit Kot Pantolon', 750.00, 18, 2),          -- Stok < 20
    ('Kapüşonlu Sweatshirt', 850.00, 30, 2),
    -- Kitap
    ('Yapay Zeka ve Gelecek', 120.00, 12, 3),          -- Stok < 20
    ('SQL ile Veri Tabanı Mimarisi', 180.00, 40, 3),
    -- Kozmetik
    ('Nemlendirici Yüz Kremi', 290.00, 5, 4),          -- Stok < 20
    ('Güneş Koruyucu Krem SPF 50', 420.00, 22, 4),
    -- Ev ve Yaşam
    ('Filtre Kahve Makinesi', 1850.00, 10, 5),         -- Stok < 20
    ('Dekoratif Çalışma Lambası', 490.00, 35, 5);
GO

-- 3. Görev 3: 6 Adet Müşteri Ekleme (Ahmet Yılmaz dahil, tekil e-postalar)
INSERT INTO Customers (FullName, City, Email)
VALUES 
    ('Ahmet Yılmaz', 'İstanbul', 'ahmet.yilmaz@novastore.com'),
    ('Zeynep Kaya', 'Ankara', 'zeynep.kaya@novastore.com'),
    ('Mehmet Demir', 'İzmir', 'mehmet.demir@novastore.com'),
    ('Ayşe Çelik', 'Bursa', 'ayse.celik@novastore.com'),
    ('Caner Erkin', 'Antalya', 'caner.erkin@novastore.com'),
    ('Elif Şahin', 'İstanbul', 'elif.sahin@novastore.com');
GO

-- 4. Görev 4: Farklı Tarihlerde 10 Adet Sipariş Ekleme
-- DATEDIFF zaman analizinde gerçekçi sonuçlar görmek için DATEADD ile geçmiş günler simüle edilmiştir.
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES 
    (1, DATEADD(DAY, -45, GETDATE()), 3650.00), -- Ahmet Yılmaz
    (2, DATEADD(DAY, -30, GETDATE()), 750.00),  -- Zeynep Kaya
    (3, DATEADD(DAY, -25, GETDATE()), 2200.00), -- Mehmet Demir
    (1, DATEADD(DAY, -18, GETDATE()), 470.00),  -- Ahmet Yılmaz (2. siparişi)
    (4, DATEADD(DAY, -12, GETDATE()), 1200.00), -- Ayşe Çelik
    (5, DATEADD(DAY, -8, GETDATE()), 1850.00),  -- Caner Erkin
    (2, DATEADD(DAY, -5, GETDATE()), 1450.00),  -- Zeynep Kaya (2. siparişi)
    (6, DATEADD(DAY, -3, GETDATE()), 290.00),   -- Elif Şahin
    (1, DATEADD(DAY, -2, GETDATE()), 1850.00),  -- Ahmet Yılmaz (3. siparişi)
    (3, DATEADD(DAY, -1, GETDATE()), 700.00);   -- Mehmet Demir (2. siparişi)
GO

-- 5. Sipariş Detayları (OrderDetails) Ekleme
-- Hangi siparişte hangi ürünün kaç adet alındığı eşleştirmesi
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
    -- 1. Sipariş (Ahmet Yılmaz: Akıllı Saat + SQL Kitabı)
    (1, 3, 1),
    (1, 8, 1),
    -- 2. Sipariş (Zeynep Kaya: Kot Pantolon)
    (2, 5, 1),
    -- 3. Sipariş (Mehmet Demir: Mekanik Klavye)
    (3, 2, 1),
    -- 4. Sipariş (Ahmet Yılmaz: Pamuklu T-Shirt + Yapay Zeka Kitabı)
    (4, 4, 1),
    (4, 7, 1),
    -- 5. Sipariş (Ayşe Çelik: Sweatshirt + Yüz Kremi)
    (5, 6, 1),
    (5, 9, 1),
    -- 6. Sipariş (Caner Erkin: Filtre Kahve Makinesi)
    (6, 11, 1),
    -- 7. Sipariş (Zeynep Kaya: Bluetooth Kulaklık)
    (7, 1, 1),
    -- 8. Sipariş (Elif Şahin: Yüz Kremi)
    (8, 9, 1),
    -- 9. Sipariş (Ahmet Yılmaz: Filtre Kahve Makinesi)
    (9, 11, 1),
    -- 10. Sipariş (Mehmet Demir: 2 Adet Pamuklu T-Shirt)
    (10, 4, 2);
GO