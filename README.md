# NW NEON Oto Bakım — Satış Otomasyonu

Modern, dark-theme WPF tabanlı Stok Yönetimi Ve Rapor uygulaması. NW NEON Oto Bakım dükkanı için geliştirilmiştir.

## Özellikler

- 🛒 Sepet yönetimi — ürün ekle, adet artır/azalt, indirim uygula
- 🔍 Barkod okuyucu desteği — otomatik sepete ekleme
- 🏷️ Kategori bazlı ürün listeleme ve arama
- 💵 Nakit / Kredi kartı ödeme (F1 / F4 kısayolu)
- 🚿 Yıkama geliri takibi
- ⚠️ Kritik stok uyarısı (kırmızı glow efekti)
- 📊 Satış raporu — tarih filtreli, ciro/kar/indirim dahil
- 📉 Grafik analizi — en çok satan, en çok kar getiren
- 🚿 Yıkama raporu — tarih filtreli özet ve detay liste
- 📥 CSV export + otomatik silme (arşivleme)
- ➕ Ürün ve marka yönetimi
- ↩️ Son satış iptal
- 🔒 15 günlük demo modu + telefonla aktivasyon (bkz. [Lisans / Demo Modu](#lisans--demo-modu))

## Teknoloji

| Katman | Teknoloji |
|--------|-----------|
| Arayüz | WPF / XAML |
| Backend | C# (.NET Framework 4.8) |
| Veritabanı | SQL Server Express |
| Bağlantı | Microsoft.Data.SqlClient 3.1.5 |

## Kurulum

### Gereksinimler
- Windows 10/11
- .NET Framework 4.8
- SQL Server Express

### Adımlar

1. Repoyu klonla:
   ```bash
   git clone https://github.com/zeynpberdem/Kocael-iOtamasyon.git
   cd Kocael-iOtamasyon
   ```

2. Veritabanını kur:

   `NWneonv1.0.bak` yedeğini `WPFDatabase` adıyla SQL Server Express'e geri yükleyin. Adım adım komutlar için `Veritabani_Kurulum_Talimatlari.txt` dosyasına bakın. Özetle:
   ```bash
   sqlcmd -S .\SQLEXPRESS -E -Q "RESTORE DATABASE WPFDatabase FROM DISK='C:\yedek\NWneonv1.0.bak' WITH REPLACE"
   ```

3. Bağlantı dizesini kontrol et:

   `SatisWPF/App.config` içindeki `WPFDB` bağlantı dizesinin sunucu adınızla eşleştiğinden emin olun:
   ```xml
   <add name="WPFDB"
        connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=WPFDatabase;Integrated Security=True;Encrypt=True;TrustServerCertificate=True"/>
   ```
   Farklı bir sunucu/instance kullanıyorsanız yalnızca `Data Source` kısmını değiştirmeniz yeterli.

4. Projeyi aç ve çalıştır:
   - Visual Studio ile `SatisWPF.sln` dosyasını açıp F5 ile çalıştırabilirsiniz,
   - ya da komut satırından:
     ```bash
     dotnet build SatisWPF.sln
     dotnet SatisWPF/bin/Debug/net48-windows/SatisWPF.exe
     ```

5. Giriş yap:

   Varsayılan giriş bilgileri `admin` / `admin123`'tür (`Properties/Settings.settings` içinden değiştirilebilir, Ayarlar ekranından güncellenir). Ayrıca kaynak kodda sabit bir yedek giriş de tanımlıdır (`admin` / `wpfkurtar23`) — asıl şifre unutulsa/bozulsa bile devre dışı kalmaz.

## Lisans / Demo Modu

Uygulama ilk çalıştırıldığında otomatik olarak 15 günlük deneme süresini başlatır. Gerekli tablolar (`SistemLisans`, `LisansSifreleri`) `WPFDatabase` içinde uygulama tarafından kendiliğinden oluşturulur — elle bir kurulum gerekmez.

Süre dolduğunda:

1. Uygulama 1-30 arasında rastgele bir referans numarası üretip ekranda gösterir.
2. Müşteri bu numarayı satıcıya (size) bildirir.
3. Siz, ayrı ve gizli tutulan kod listenizden o numaraya karşılık gelen kodu müşteriye iletirsiniz. (`LisansSifreleri` tablosunda yalnızca SHA-256 hash'leri bulunur; düz metin kodlar bu depoda **yoktur**.)
4. Doğru kod girildiğinde sistem kalıcı olarak aktive olur ve bir daha tarih/saat kontrolü yapmaz.

Sistem ayrıca bilgisayar saatinin geriye alınmasını da tespit eder; böyle bir durum tespit edilirse saat düzeltilene kadar uygulama kilitlenir. Uygulama çalışırken de birkaç dakikada bir bu kontrol tekrarlanır.

Teknik detaylar için `SatisWPF/LisansServisi.cs`, `SatisWPF/LisansWindow.xaml(.cs)` ve `Lisans_Kurulum.sql` dosyalarına bakın.

### Yeni müşteri kurulumu (geliştirici notu)

Her müşteri için `WPFDatabase`'in ayrı bir kopyasını oluşturup `.bak` alıyorsanız, yedeği almadan **önce** kendi test/geliştirme sürecinizde oluşmuş lisans kaydını temizleyin ki müşterinin 15 günlük süresi kendi kurulumunda, sıfırdan başlasın:

```sql
TRUNCATE TABLE dbo.SistemLisans;
```

`LisansSifreleri` tablosuna dokunmayın — bu tablo (ve ona karşılık gelen gizli kod listeniz) tüm kurulumlarda aynı kalmalı.
