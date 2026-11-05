# War-Rung — Hasil Proof of Concept (Fase 0)

**Tanggal:** 2026-11-04
**Runtime:** indk v1.4.0 — `.tools/indk/indk-windows/indk.exe`
**SHA-256 unduhan:** `254fd67e7f39f8279c7271b6fc36302790a68b6c0ff30b9432d6e5d5939bde27`
**Status:** 8 kelompok PoC selesai — seluruhnya exit 0; `indk periksa` atas seluruh berkas: 0 temuan.

Dokumen ini adalah catatan temuan runtime Indonesiaku Lang v1.4.0 yang mengikat keputusan desain aplikasi (lihat `PRD.md` §13.1 dan `DESIGN.md` §7).

## 1. Ringkasan Hasil

| No | Berkas                          | Fokus                                | Hasil    |
| -- | ------------------------------- | ------------------------------------ | -------- |
| 1  | `poc_prasyarat.idk`             | cetak/ANSI/f-string/konversi/galat dasar/stdin | LULUS (exit 0) |
| 2  | `poc_galat.idk`                 | OOP galat, subclass, re-raise, `akhirnya` | LULUS (exit 0) |
| 3  | `poc_db.idk`                    | SQLite CRUD, PRAGMA, transaksi, galat konstrain | LULUS (exit 0) |
| 4  | `poc_modul.idk`                 | impor/alias/dari..impor/legacy/siklus/cache | LULUS (exit 0) |
| 5  | `poc_berkas.idk`                | baca/tulis biner, sha256, direktori, I/O | LULUS (exit 0) |
| 6  | `poc_tanggal.idk`               | tanggal()/format_tanggal, algoritma hari, minggu | LULUS (exit 0) |
| 7  | `poc_tampilan.idk`              | panjang vs ANSI, padding, spinner    | LULUS (exit 0) |
| 8  | `poc_uji.idk`                   | `indk uji` / `indk periksa`          | LULUS (4/4 uji; periksa 0 temuan) |

Pendukung: `poc_bantuan.idk`, `poc_siklus_a.idk`, `poc_siklus_b.idk` (impor), `data/uji_biner.bin` (fixture biner 256 byte, SHA-256 `40aff2e9d2d8922e47afd4648e6967497158785fbd1da870e7110266bf944880` — disimpan untuk pengulangan uji).

**Kode keluaran:** 0 = sukses, 65 = kesalahan kompilasi/parse, 70 = galat runtime tak tertangkap, 1 = `indk uji` dengan uji gagal.

## 2. Temuan Runtime

### 2.1 Berkas sumber

- Berkas `.idk` WAJIB UTF-8 **tanpa BOM**. BOM memicu `Kesalahan: Karakter tidak dikenal`. Tooling: `[System.IO.File]::WriteAllText($p, $c, (New-Object System.Text.UTF8Encoding($false)))`.

### 2.2 Sintaks & kata kunci

- Kata kunci teramati: `dalam` (bukan `in` — `untuk x in ...` gagal parse), `kelas` (dilarang sebagai nama properti: `e.kelas` → "Harapkan nama properti setelah '.'"), `kasus` (dilarang sebagai nama variabel).
- **`konstanta` BUKAN kata kunci deklarasi** — `konstanta K = 5` menghasilkan `Variabel tidak terdefinisi 'konstanta'` (exit 70; dari dalam modul: lihat §2.6 = senyap). Kunci deklarasi = **`variabel`**.
- Kata kunci juga tidak sah sebagai segmen nama modul: `impor tidak.ada` → parse error 65 `[baris 1, kolom 7] Kesalahan di 'tidak': Harapkan nama modul.` (bukan masalah titiknya — `tidak` = operator).
- Klausa `kecuali Tipe {...}` tanpa `sebagai x` harus menjadi klausa TERAKHIR; selain itu wajib `kecuali Tipe sebagai x` (compile error bila tidak).
- `lanjut` (continue) dan `hentikan` (break) adalah **kata kunci perulangan** — `lanjut` DILARANG sebagai nama variabel (`variabel lanjut` → parse error 65 "Harapkan nama variabel"). `lanjutkan(it[, bawaan])` = fungsi bawaan iterator next() (dinamai begitu karena `lanjut` sudah keyword — CHANGELOG).
- Rantai cabang: `jika k1 { } jika_lain k2 { } selain { }` — **`jika_lain` WAJIB punya kondisi**; else telanjang = **`selain`**. `} jika_lain {` tanpa kondisi membuat `{` dibaca ekspresi dict → galat menipu: "Harapkan ':' setelah kunci kamus".
- Klausa `kecuali Tipe {...}` tanpa `sebagai x` harus menjadi klausa TERAKHIR; selain itu wajib `kecuali Tipe sebagai x` (compile error bila tidak).
- `untuk x dalam daftar`, `selagi`, `jika/kecuali/penyebab`, f-string `f"{}"` — bekerja sesuai spesifikasi.
- Pesan galat kadang menyertakan saran ejaan: `Variabel tidak terdefinisi 'db_baca'. Mungkin maksudmu 'db_buka'?`

### 2.3 String & format

- Escape yang didukung hanya `\n \t \r \" \\ \0`. **`\x1b` TIDAK didukung** → ANSI escape dibangun dengan `chr(27)` (terbukti: `chr(27) + "[31m"`).
- `f"{}"` bekerja; `format("{} dan {}", a, b)` bekerja, tetapi penambahan gaya `format("{:02d}", 7)` **tidak disubstitusi** (dikembalikan literal `{:02d}` tanpa galat) → format angka dilakukan manual/`ke_teks`.
- `panjang()` menghitung karakter ANSI ikut terhitung (teks berwarna `[31mABC[0m` = 12, bukan 3) → **layout dihitung dari teks polos, warna dipasang setelahnya**.
- `panjang_byte` **TIDAK ADA** di v1.4.0 (panduan lebih baru dari rilis).
- `huruf_besar`, `ganti`, `ke_teks`, `ke_angka`, `ke_bulat`, `ke_logika`, `repr`, `jenis`, `hash`, `turunan_dari`, `adalah_instansi` — berfungsi. `ke_teks(5.0)` = `"5.0"`.
- `potong(t, awal, akhir)` melewati ujung tanpa galat → mengembalikan seluruh teks.

### 2.4 Galat (exception)

- Subclass galat domain wajib punya `init(pesan)` sendiri; kelas bawaan tanpa `init`.
- Bacaan nama tak terdefinisi (mis. `tidak_ada_variabel`) menaikkan galat yang **BUKAN `GalatNama`** (dibuktikan `adalah_instansi(e, GalatNama)` = `salah`; `adalah_instansi(e, Galat)` = `benar`) → tangkap dengan `kecuali e` generik atau `kecuali Galat`. `buang x` pada nama tak terdefinisi tetap `GalatNama`.
- `kamus["kunci_hilang"]` mengembalikan `kosong` **tanpa galat** → selalu periksa dengan `punya()` bila kunci wajib ada.
- Kelas yang terkonfirmasi ADA: `Galat`, `GalatTipe`, `GalatNilai`, `GalatNama`, `GalatAtribut`, `GalatIndeks`, `GalatPencarian`, `GalatOS`, `GalatLuapan`, `GalatIzin`, `GalatKunci`, `GalatAritmetika`, `HentiIterasi`. **`GalatJaringan` TIDAK ada** (padahal disebut panduan) → jangan dirujuk.
- Indeks list di luar jangkauan DAPAT ditangkap (bertentangan dengan satu pernyataan panduan; mengikuti spesifikasi).
- `ke_angka()`/`ke_bulat()` gagal → `GalatNilai` (terbukti tertangkap).

### 2.5 Database SQLite

- API yang ada: `db_buka`, `db_tutup`, `db_eksekusi`, `db_ambil_semua`, `db_ambil_satu`, `db_baris_terpengaruh`, `db_id_terakhir`, `db_mulai`, `db_komit`, `db_batal` (+ `db_batas_tunggu`). **Tidak ada `db_baca`.**
- `PRAGMA foreign_keys = ON` melalui `db_eksekusi` bekerja; pembacaan balik menghasilkan `{"foreign_keys": 1}`.
- Semua pelanggaran berikut menaikkan **`GalatNilai`** dengan pesan prefix `SQLite:` / `db:`:
  - NOT NULL (`SQLite: NOT NULL constraint failed: nn.a`)
  - FOREIGN KEY, UNIQUE, CHECK
  - Kolom tidak dikenal, jumlah parameter tidak cocok
  - Dua pernyataan dalam satu `db_eksekusi`
  - `db_komit`/`db_batal` tanpa transaksi aktif
  - Operasi pada handle tertutup
- `db_tutup` dua kali aman. `db_baris_terpengaruh`/`db_id_terakhir` berfungsi.
- Pesan galat sqlite dipertahankan apa adanya (asli Inggris) → layer layanan menerjemahkan ke pesan ramah ala `DESIGN.md` §6.

### 2.6 Modul & impor (diverifikasi ulang — lengkap)

| Bentuk | Resolusi path | Pembindan | Kegagalan |
| ------ | ------------- | --------- | --------- |
| `impor nama` | direktori pengimpor → `INDK_PATH` → `pustaka/` | objek modul bernama `nama` (`mod.fungsi()`, `mod.KONST`) | `Modul 'x' tidak ditemukan.` — Galat tertangkap + berpesan |
| `impor a.b` (paket) | memuat `a/b.idk`, urutan pencarian sama | objek modul bernama **`b`** (tampil `<modul a.b>`) | `Modul 'a.b' tidak ditemukan.` — tertangkap + berpesan |
| `dari nama impor x, y` (± `sebagai`) | sama seperti `impor nama` | selektif, tanpa objek modul | tertangkap + berpesan |
| `impor "a/b.idk"` (legacy) | **CWD** (bukan direktori pengimpor) | namespace modul **bocor** langsung ke pengimpor | `Tidak dapat mengimpor file '...'.` — tertangkap + berpesan |

- `dari "berkas.kutip" impor x` → **parse error 65** ("Harapkan nama modul") — `dari` hanya menerima nama.
- **Pustaka bawaan TIDAK dapat diakses bentuk dotted**: `impor pustaka.teks` / `dari pustaka.teks impor x` → `Modul 'pustaka.teks' tidak ditemukan.` (pencarian selalu membentuk `pustaka/teks.idk` relatif, bukan fallback). Bentuk sah: **`impor teks`** (fallback `pustaka/`, bind objek `teks`) atau **`dari teks impor teks_pisah, teks_pangkas`** (nama telanjang).
- **`INDK_PATH` (env var) terbukti bekerja**: dari subdirektori, `impor paket.m3` dan `impor akar_b` menemukan modul di akar saat `INDK_PATH=<akar>`; tanpa env & di luar direktori pengimpor → tidak ditemukan. **CWD TIDAK ikut pencarian modul.**
- **Galat saat eksekusi sebuah modul saat diimpor = SENYAP** — exit 70 tanpa pesan, tidak tertangkap `coba/kecuali` pengimpor (terbukti: modul dengan `konstanta`/fungsi-tak-terdefinisi di tingkat atas). Kegagalan *path* tetap berpesan. Debug: jalankan modul tersebut langsung.
- `impor` ulang di-cache (sekali eksekusi walau dua jalur); siklus impor aman; `__nama__` entri = `__utama__`; `jenis(modul)` = `"modul"`; akses parsial saat siklus (`a.poc_siklus_b`) tersedia.

### 2.7 Berkas & biner

- `baca_semua`/`tulis_semua` **utuh byte** untuk biner 0x00–0xFF (round-trip terbukti): `sha256(baca_semua(x))` dalam bahasa **sama persis** dengan `Get-FileHash -Algorithm SHA256` shell (hex huruf kecil).
- `panjang()` atas isi biner ≠ jumlah byte (192 vs 256) → jangan pakai `panjang()` untuk ukuran byte; gunakan `sha256`/hash untuk verifikasi integritas backup.
- `isi_direktori` terurut; `baca_baris` membuang terminator baris; EOF → `kosong`.
- Galat I/O tertangkap: `baca_semua()` gagal membuka, `buat_direktori(): ... sudah ada`, `hapus_direktori(): ... direktori tidak kosong`.

### 2.8 Tanggal & waktu

- `tanggal()` mengembalikan kamus dengan nilai **desimal** (`2026.0`, bukan `2026`) → `ke_bulat()` sebelum aritmetika/pemformatan.
- `format_tanggal("%Y-%m-%d")`, `%H:%M:%S`, `%u`, `%w`, `%A` bekerja. `waktu()` = epoch detik (desimal).
- Algoritma hari sipil↔epoch (Hinnant) dirancang ulang di PoC dan lulus round-trip 7 tanggal uji termasuk `0001-01-01` dan `1600-02-29` (implementasi awal salah arah ternary pada perhitungan `doy` — lihat `poc_tanggal.idk` untuk versi benar).
- `t["hari_minggu"]` hari ini (Rabu) = 3 → ambigu antara gaya `%u` (Sen=1) dan `%w` (Min=0); **konfirmasi ulang pada hari Minggu sebelum diandalkan**. Aplikasi menghitung hari sendiri dari epoch (0=Senin) sehingga tidak bergantung pada ambigu ini.

### 2.9 Tampilan & interaksi

- Warna ANSI terkirim (PoC mencetak escape apa adanya; render oleh terminal). Clear-screen `chr(27)+"[2J"+chr(27)+"[H"` baru dibuktikan terkirim, **belum dibuktikan merender** → uji di Fase 1.
- Spinner `chr(13)` (CR) + teks tanpa `akhir=""` berfungsi.
- `input()` membaca dari stdin pipe tanpa Enter (diuji `"2" | indk ...` → jawaban `"2"`).
- **EOF stdin: `input()` mengembalikan `kosong` TANPA galat** (terbukti dengan pipeline kosong) — setiap pemakaian wajib memeriksa `x == kosong` sebelum `teks_pangkas`/`panjang`, kalau tidak `GalatNilai` "panjang() hanya menerima string..." bocor ke tingkat atas (Fase 1: `baca_pilihan` → -2).
- `argumen` (baris perintah) = `[]` saat tanpa argumen. `henti(0.07)` akurat ±10 ms.

### 2.10 Pengujian bawaan

- `indk uji <file>`: menjalankan HANYA fungsi `uji_*`; ringkasan `LULUS/GAGAL` + `N/M uji lulus`; exit 0 bila semua lulus, **exit 1 bila ada gagal**.
- Menjalankan file secara langsung: kode tingkat atas berjalan, `uji_*` TIDAK dieksekusi.
- `indk periksa <file...>`: statis, 0 temuan pada seluruh berkas PoC (exit 0). **Cek sintaks saja — TIDAK menangkap variabel tak terdefinisi** (terbukti Fase 2: nama parameter `baruang` vs pemakaian `barangg` → periksa 0 temuan, runtime exit 70 "Variabel tidak terdefinisi 'barangg'") → selalu jalankan `indk uji`/aplikasi setelah periksa.

## 3. Keputusan Teknis yang Mengikat

1. **Menu bernomor `[1-N]` + `input()`** — tanpa modul `Konsol`/raw-key/panah (tidak ada di v1.4.0). Footer: `[1-N] Pilih | [Enter] Konfirmasi | [0] Keluar`.
2. **Layout dari teks polos, warna setelahnya** — `panjang()` menghitung escape.
3. **ANSI dibangun dengan `chr(27)`** — literal `\x1b` tidak didukung.
4. **Semua galat database ditangkap sebagai `GalatNilai`** dan diterjemahkan ke pesan ramah di layer layanan; pesan asli SQLite disimpan untuk log bila perlu.
5. **`PRAGMA foreign_keys=ON` wajib dijalankan per koneksi** setelah `db_buka`.
6. **Snapshot `harga_beli` di `detail_transaksi`** dan status `transaksi` ∈ `lunas|bon|batal` (PRD §6.3–6.4).
7. **Verifikasi backup** dengan `sha256(baca_semua(...))` (terbukti sama dengan hash shell).
8. **Tanggal DB selalu `format_tanggal("%Y-%m-%d %H:%M:%S")`** (teks), nilai `tanggal()` dikeluarkan dengan `ke_bulat()`.
9. **Uang `bulat` + `//`**; format tampilan manual (tanpa gaya format `{:02d}`).
10. **Baca kunci kamus selalu diawali `punya()`** (hilang = `kosong`, bukan galat).
11. **Jangan rujuk `panjang_byte` dan `GalatJaringan`** (tidak ada di v1.4.0).
12. **Impor hanya bentuk modern** `impor nama` / `impor paket.modul` / `dari x impor y`. Aplikasi selalu dijalankan dari **akar proyek** dengan **`INDK_PATH=<akar proyek>`** (diatur launcher `warung.cmd`) sehingga modul subdirektori (mis. `impor inti.koneksi`) terjangkau dari modul mana pun, termasuk dari modul bersarang. Bentuk legacy `impor "path"` hanya cadangan pengujian (CWD + bocor namespace). **Jangan mengandalkan kegagalan load modul — senyap (exit 70).**
13. **`indk uji` dipakai untuk seluruh `uji_*` aplikasi** (exit 1 saat gagal → andalkan untuk gerbang kualitas).

## 4. Celah Terbuka (lanjut ke Fase 1+)

- Ambigu `tanggal()["hari_minggu"]` — konfirmasi pada hari Min (nilai ekspektasi: 0 bila `%w`, 7 bila `%u`).
- Render clear-screen/redraw ANSI pada Windows Terminal — buktikan saat membangun `tampilan` Fase 1.
- Semantik rollback saat galat di tengah transaksi (apakah `db_batal` otomatis dijalankan pustaka) — uji di Fase 3.
- `format()` tanpa gaya — buat pembungkus angka/ruang di `inti/`.
- Pesan galat SQLite berbahasa Inggris — kebutuhan terjemahan pesan (DESIGN §6) ditangani layer layanan.

## 5. Perintah Reproduksi

```powershell
$indk = "$PWD\.tools\indk\indk-windows\indk.exe"
"2" | & $indk pengujian\poc\poc_prasyarat.idk        # exit 0, SELESAI-POC-1
& $indk pengujian\poc\poc_galat.idk
& $indk pengujian\poc\poc_db.idk
& $indk pengujian\poc\poc_modul.idk
& $indk pengujian\poc\poc_berkas.idk
& $indk pengujian\poc\poc_tanggal.idk
& $indk pengujian\poc\poc_tampilan.idk
& $indk uji pengujian\poc\poc_uji.idk                # 4/4 lulus, exit 0
& $indk periksa (Get-ChildItem pengujian\poc\*.idk).FullName   # 0 temuan
```
