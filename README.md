# NovaStore E-Ticaret Veri Yonetim Sistemi

Bu proje; iliskisel veri tabani mimarisi (RDBMS), veri tanimlama dili (DDL), veri isleme dili (DML), ileri seviye analitik sorgulama (DQL), sanal tablo gorunumu (View) ve tam yedekleme (Backup) stratejilerini uctan uca ele alan bir Microsoft SQL Server veri mimarisi projesidir.

Gelistirici: Berke Han Cavdar

---

## Mimari Yapi ve Iliskisel Tasarim (ERD)

Sistem mimarisi 3. Normal Form (3NF) prensiplerine ve Foreign Key referans butunlugune uygun olarak 5 temel tablo uzerine insa edilmistir:

1. Categories (Kategoriler): Urun kategorilerini ve siniflandirmalarini barindirir (Identity PK).
2. Customers (Musteriler): Musteri iletisim ve sehir bilgilerini tekil e-posta (UNIQUE) kisitiyla saklar (Identity PK).
3. Products (Urunler): Fiyat, varsayilan stok degeri (DEFAULT 0) ve kategori baglantisini Categories tablosuna bagli Foreign Key ile yonetir.
4. Orders (Siparisler): Musteri siparis tarihlerini (DEFAULT GETDATE()) ve toplam sepet tutarlarini saklar, Customers tablosuna baglidir.
5. OrderDetails (Siparis Detaylari): Siparisler ve urunler arasindaki coka-cok (N:M) iliskiyi cozen, siparis edilen urun adedini (Quantity) tutan kopru tablodur.

---

## Dizin Yapisi

NovaStore-SQL-Veri-Yonetimi/
├── diagrams/
│   └── BerkeHanCavdar_NovaStore_Proje.png   # Veri tabani iliski semasi (Database Diagram / ERD)
├── docs/
│   └── BerkeHanCavdar_NovaStore_Proje.docx  # Ekran goruntulu resmi proje teslim raporu
├── scripts/
│   ├── 01_create_database_and_tables.sql   # DDL semasi, tablolar ve butunluk kisitlari
│   ├── 02_insert_dummy_data.sql            # DML test veri seti (Kategori, Urun, Musteri, Siparis)
│   ├── 03_analytical_queries.sql           # DQL is analitigi ve yonetim kurulu raporlama sorgulari
│   └── 04_views_and_backup.sql             # vw_SiparisOzet View nesnesi ve Full Backup scripti
├── BerkeHanCavdar_NovaStore_Proje.sql       # Teslim gereksinimi icin tum sureci iceren tek parca master script
└── README.md

---

## Kurulum ve Calistirma

### Gereksinimler
- Microsoft SQL Server 2017 veya uzeri
- Azure Data Studio, VS Code (mssql eklentisi) veya SQL Server Management Studio (SSMS)

### Calistirma Yontemleri

#### Yontem 1: Moduler Scriptler ile Calistirma (Tavsiye Edilen)
1. scripts/01_create_database_and_tables.sql dosyasini calistirarak NovaStoreDB veri tabanini ve tablolarini olusturun.
2. scripts/02_insert_dummy_data.sql dosyasini yuruterek 5 kategori, 12 urun, 6 musteri ve 10 siparis detayini yukleyin.
3. scripts/03_analytical_queries.sql dosyasindaki 6 farkli analitik sorguyu calistirarak sonuclari listeleyin.
4. scripts/04_views_and_backup.sql dosyasini calistirarak View yapisini derleyin ve tam veri tabani yedegini alin.

#### Yontem 2: Tek Parca Master Script ile Calistirma
Kok dizindeki BerkeHanCavdar_NovaStore_Proje.sql dosyasini tek bir query penceresinde acip Execute komutuyla yurutmeniz tum semayi, verileri, raporlari ve ileri seviye nesneleri sirali sekilde ayaga kaldirir.

---

## Is Analitigi ve Raporlama Kapsami (DQL)

Yonetim kurulunun stratejik karar alma sureclerini desteklemek amaciyla asagidaki 6 temel analitik rapor hazirlanmistir:

1. Kritik Stok Raporu: Tedarik surecini planlamak adina stok miktari 20 adedin altinda kalan urunlerin adlari ve mevcut stoklari azalan sirada listelenmistir (WHERE, ORDER BY DESC).
2. Musteri Siparis Gecmisi: Hangi musterinin hangi tarihte siparis verdigi ve siparis tutarlari birlestirilmistir (INNER JOIN - Customers & Orders).
3. Musteri Sepet Detay Raporu: "Ahmet Yilmaz" isimli musterinin siparis ettigi tum urunlerin adlari, birim fiyatlari ve ait olduklari kategoriler iliskisel zincir uzerinden cekilmistir (5 Tablolu Zincirleme JOIN).
4. Kategori Envanter Dagilimi: Kategori bazinda toplam kac adet urun cesidi bulundugu raporlanmistir (GROUP BY, COUNT(), LEFT JOIN).
5. Ciro ve Musteri Degeri Analizi: Sirkete en cok ciro kazandiran musteriler toplam harcama tutarlarina gore en yuksekten en aza dogru siralanmistir (SUM(), GROUP BY, ORDER BY DESC).
6. Siparis Yaslandirma (Aging) Analizi: Siparislerin verilme tarihinden bugune kadar kac gun gectigi dinamik olarak hesaplanmistir (DATEDIFF(), GETDATE()).

---

## Ileri Seviye Veri Tabani Nesneleri (Bolum 4)

### 1. Siparis Ozet Gorunumu (View: vw_SiparisOzet)
Operasyonel birimlerin ve raporlama katmaninin her seferinde dort farkli tabloyu manuel olarak birlestirmesini engellemek, sorgu optimizasyonu saglamak ve soyutlama olusturmak amaciyla vw_SiparisOzet gorunumu gelistirilmistir.

- Kapsadigi Alanlar: Musteri Adi (FullName), Siparis Tarihi (OrderDate), Urun Adi (ProductName), Adet (Quantity).
- Kullanim:
  SELECT * FROM vw_SiparisOzet;

### 2. Felaket Kurtarma ve Yedekleme (Full Backup)
Veri guvenligi, butunlugu ve is surekliligi stratejisi kapsaminda NovaStoreDB veri tabaninin disk uzerine tam (FULL) yedegi alinmistir.

- Hedef Dizin: C:\Yedek\NovaStoreDB.bak
- Yedekleme Parametreleri: WITH FORMAT parametresi ile yeni bir yedek kumesi baslatilmakta ve MEDIANAME ile etiketlenmektedir.
- Kullanim Komutu:
  BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak' WITH FORMAT, MEDIANAME = 'NovaStoreDB_FullBackup', NAME = 'Full Backup of NovaStoreDB';

---

## Teslimat Belgeleri ve Standartlar

- SQL Scripti: Tum asamalar tek parca halinde BerkeHanCavdar_NovaStore_Proje.sql icerisinde -- aciklama satirlariyla belgelenmistir.
- Diyagram (ERD): Tablolar arasi Primary Key - Foreign Key iliski baglantilari diagrams/BerkeHanCavdar_NovaStore_Proje.png olarak semalanmistir.
- Resmi Rapor: Kod bloklari, sorgu sonuclari ekran goruntuleri ve tablolara ait detayli aciklamalar docs/BerkeHanCavdar_NovaStore_Proje.docx dosyasinda teslimat standardina getirilmistir.