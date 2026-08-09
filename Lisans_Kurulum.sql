-- ============================================================================
-- NW NEON / SatisWPF - 15 Gunluk Demo Lisans Sistemi - Tablo Kurulumu
-- ============================================================================
-- Bu script'i WPFDatabase uzerinde CALISTIRMANIZA GEREK YOKTUR:
-- uygulama (LisansServisi.cs) bu tablolari ilk acilista kendisi, yoksa,
-- otomatik olarak olusturur (idempotent CREATE). Bu script sadece:
--   1) NWneonv1.0.bak yedegine bu tablolari GOMMEK isterseniz,
--   2) Ya da tablolari elle inceleyip dogrulamak isterseniz
-- referans olarak tutulur.
--
-- ONEMLI: LisansSifreleri tablosunda sadece SHA-256 HASH degerleri var.
-- Musteriye soylenecek DUZ METIN kodlarin listesi bu repoda DEGILDIR;
-- ayri, gizli tutulan bir dosyada saklanmaktadir (bkz. proje sahibine
-- teslim edilen "LisansKodlari_GIZLI.txt").
-- ============================================================================

IF OBJECT_ID('dbo.SistemLisans', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SistemLisans (
        Id                   INT IDENTITY(1,1) PRIMARY KEY,
        BaslangicTarihi      DATETIME NOT NULL,
        BitisTarihi          DATETIME NOT NULL,
        SonIslemTarihi       DATETIME NOT NULL,
        AktivasyonDurumu     BIT NOT NULL DEFAULT 0,
        AktivasyonReferansId INT NULL,
        AktivasyonTarihi     DATETIME NULL
    );
END
GO

IF OBJECT_ID('dbo.LisansSifreleri', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LisansSifreleri (
        Id        INT NOT NULL PRIMARY KEY CHECK (Id BETWEEN 1 AND 30),
        SifreHash NVARCHAR(200) NOT NULL
    );
END
GO

-- Seed: 1-30 arasi ID'lere karsilik gelen SHA-256 hash'ler.
-- (Duz metin kodlar bu dosyada YOKTUR - sadece hash'ler.)
MERGE dbo.LisansSifreleri AS target
USING (VALUES
    (1, '860a97acba115d5ee8666e681b6f7ef71e05ccbec6d6699f70def42e8613e929'),
    (2, 'f6e574b740545854ddd106b8949c809d28dae2a2eeab477a76d1cba7bcc4a060'),
    (3, '0eed25973bc302df97380eed2b3165566f55c7c564eae00a93842071462a22bf'),
    (4, '17afe44a1a04a41c63be3e9587987eb2c44d3cb41b2101443f8afcc68fc0f12d'),
    (5, '2a922e50bcf41dde88b56fef00af9667cecfc461a64c076c29dfcd87f7addaba'),
    (6, '6db06478056002a12fbe65906329efd9248f98edcfc5a268533e5a3a5768ea0e'),
    (7, 'a3dee401f430dd1b9b8d419f2c9ea91dd45cfea9d407e06b09c81e5cc26ac969'),
    (8, 'e90000c6197774f6dfd78c671601e073c5de022b1d04fdf5e6bdbd99f1164ac6'),
    (9, '2130469d1d2fbdce78488066a5de4664212ede013e6d7466cdc00744514c6bbe'),
    (10, 'd10571dc2de16d5a0d16b18a412aeb2a5632e0eabdec16dcc36de3463caa30a3'),
    (11, '015d61fe8237d82f24b2095ddd2f8a8cdfc4a07c0b7cb9a622822e1e5a64e361'),
    (12, '918f8417710fe22c65e544e5cb749f5f03cf8520bc73993635f34c7ea9c6e237'),
    (13, '8e324c4b1b4df17bd31114a2f95fc92fbcd8e0fffcc16d22a49a2008cfa03d2a'),
    (14, '3f8d012644c04712abe982e3b8771b847c26bc635b7b403ad006619267410709'),
    (15, '260bde223b4554f1ebe93ac0d597e108ff70d5a9ec2e355f4748bc3265b25192'),
    (16, '4db40f3433a8d8cfab78f3e20740872dd0993bdcae441fa2e3a2e766dfeedffa'),
    (17, '3f8cfec2303ce3069977c0bea761dd84e3e6fdecef6495ed2cb0cc9c0348730a'),
    (18, '64e8a3fa60255afcf009c0bfce85af7c7d94c019b2a143d191857348f00cd142'),
    (19, '4357c169bb8e35b1beb583a9dc141e87008626e8890fc41370830ee98d5bb835'),
    (20, '949dceb552bc85b26a0e3414925103e96cf8b5f1cf3a001c0d3b2d0aa34ad1da'),
    (21, '71c77aef25ddf27d397ba803847af30e820294bac22b49a738d932963556c1ab'),
    (22, 'c03946585fc93daa6a9158ee9514657747dd6a3e5d66f287fb83e0f4c3c5ca4b'),
    (23, '7d9c878957245669ee25b182d3643992cf6488c7ea2776227fdc996f75de70ff'),
    (24, '7ecd2d88ce4d67c3363fb5ccc03d3ed1994407a2455f68d7fde08b6a311cf1bc'),
    (25, '41120ad37f84cbe520a6d46cd17982984d9c1c52e5617e75071f41f4c455b570'),
    (26, 'fb751cb6c89492608318a6fa2bacbdca741ec12b00a4979be2898c15dec8f795'),
    (27, '3eee0f5429b359c16a743fd8cf570ead61f27c5b86805dbda6ce3e1e0c0d6229'),
    (28, '750e73097080c262023b4d9e0695ef203633fc3977cebbf8ac03bb41042cb252'),
    (29, '967ea585c9f2181c63806638bd3a76c73f925237399ca5e5bed3c98c4f83bd17'),
    (30, 'ee02d98de36a59641b918620f1029740df17a6680db1cccba5176e006b95bd81')
) AS source (Id, SifreHash)
ON target.Id = source.Id
WHEN NOT MATCHED THEN
    INSERT (Id, SifreHash) VALUES (source.Id, source.SifreHash);
GO
