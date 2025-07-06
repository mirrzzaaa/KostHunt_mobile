# KostHunt Mobile

**KostHunt** adalah aplikasi mobile pencari dan pemesan kos-kosan yang dikembangkan sebagai proyek tugas akhir semester pada mata kuliah *Integrasi Aplikasi*. Aplikasi ini dibangun menggunakan **Flutter** untuk frontend, **PHP Native** untuk backend, dan **MySQL** sebagai basis data.

---

## 🛠️ Teknologi yang Digunakan

- **Flutter** – Untuk membangun aplikasi mobile cross-platform.
- **PHP Native** – Untuk mengembangkan REST API backend.
- **MySQL** – Sebagai database sistem.
- **HTTP (REST API)** – Untuk komunikasi antara aplikasi dan server backend.

---

## 📱 Tampilan Aplikasi

### Login & Register
- **Splash Screen** merupakan tampilan pertama saat membuka aplikasi, menampilkan logo aplikasi.
- **Halaman Login** pada halaman login pengguna menginput email dan password untuk dapat masuk 
- **Halaman Register** calon pengguna mengisi form registrasi secara lengkap untuk dapat membuat akun baru
<p float="left">
  <img src="https://github.com/user-attachments/assets/69fac2d1-9fb3-42b5-8bde-1b14c9415b6b" width ="170"/>
  <img src="https://github.com/user-attachments/assets/b3aa2bfc-f493-42c9-98a0-9b82ac01138a" width="170"/>
  <img src="https://github.com/user-attachments/assets/9c412e47-de88-4cce-9086-be4f1034c3ed" width="170"/>
</p>

### Beranda, Favorit, Chat, dan Profil
- **Halaman Beranda** menampilkan daftar semua properti kos yang tersedia. Pengguna dapat melihat informasi seperti nama kos, lokasi, dan harga, serta menambahkan properti ke favorit dengan menekan ikon hati.
- **Halaman Favorit** menampilkan daftar properti yang telah ditambahkan ke favorit oleh pengguna. Pengguna dapat menghapus properti dari daftar favorit dengan menekan kembali ikon hati.
- **Halaman Chat** menampilkan riwayat percakapan antara pengguna dan pemilik properti, memungkinkan komunikasi langsung terkait informasi kos.
- **Halaman Profil** menampilkan informasi pengguna dan menu navigasi tambahan seperti riwayat transaksi, voucher, pengaturan, kebijakan privasi, keamanan, serta tombol untuk keluar dari aplikasi.
<p float="left">
  <img src="https://github.com/user-attachments/assets/d43c67eb-24bd-40b4-af5a-47990519eebf" width="170"/>
  <img src="https://github.com/user-attachments/assets/8077cc0c-bab1-40fc-b5f3-16d6f7ad9c7f" width="170"/>
  <img src="https://github.com/user-attachments/assets/7e7c9873-d858-4e0b-b1f6-4d6270b61f6a" width="170"/>
  <img src="https://github.com/user-attachments/assets/5cf58995-4a38-427b-90f4-ee285ca5f77b" width="170"/>
</p>

### Filter & Search
- **Pencarian (Search)**  
  Pengguna dapat mengetik nama kos, lokasi, atau kata kunci lain pada kolom pencarian di halaman Beranda. Fitur ini memungkinkan pencarian cepat dan spesifik terhadap kos yang diinginkan.
- **Filter**  Pengguna dapat menyaring daftar kos berdasarkan berbagai kriteria seperti tipe properti, jenis kelamin, atau harga. Dengan fitur filter ini, hasil pencarian menjadi lebih relevan dan sesuai preferensi pengguna.
<p float="left">
   <img src="https://github.com/user-attachments/assets/e2b1ea4a-5f40-4112-85e0-02a6915fba40" width="170"/>
</p>

### Detail 
Halaman detail pada aplikasi **KostHunt** menampilkan informasi lengkap dari setiap properti kos yang dipilih oleh pengguna. Fitur ini dirancang untuk membantu pengguna mengambil keputusan sebelum melakukan pemesanan. Informasi yang ditampilkan meliputi:
- **Nama Kos** Nama properti kos yang dipilih.
- **Tipe Properti** Menunjukkan apakah kos tersebut adalah kos putra, putri, campur, atau jenis lainnya.
- **Alamat** Lokasi lengkap dari kos. Pengguna dapat melihat lokasi langsung di peta dan membuka navigasi ke lokasi kos.
- **Fasilitas Kos** Menampilkan fasilitas umum yang tersedia seperti kamar mandi dalam, dapur, Wi-Fi, parkir, dll.
- **Tipe Kamar & Harga** Menampilkan berbagai tipe kamar beserta harga masing-masing
- **Jenis Kelamin** Menunjukkan apakah kos hanya untuk laki-laki, perempuan, atau campuran.
<p float="left">
   <img src="https://github.com/user-attachments/assets/bc8077ea-5974-4d3a-b09e-dc04086d06b9" width="170"/>
   <img src="https://github.com/user-attachments/assets/7e8372c3-9988-4b2d-9f66-57f3d13ce083" width="170"/>
</p>

### Pemesanan & Pembayaran
Proses pemesanan kos pada aplikasi KostHunt, dimulai dari pemilihan kamar hingga metode pembayaran.
1. **Pemilihan Tipe Kamar**  
   Di halaman detail kos, pengguna diwajibkan memilih tipe kamar yang diinginkan terlebih dahulu sebelum mengajukan sewa. 
   Setelah memilih tipe kamar, pengguna menekan tombol **Ajukan Sewa**, dan akan diarahkan ke halaman formulir pengajuan.
3. **Formulir Pengajuan Sewa**  
   Di halaman ini, pengguna diminta untuk mengisi:
   - **Tanggal mulai sewa**
   - **Durasi sewa** (dalam angka)
   Setelah mengisi, pengguna kembali menekan tombol **Ajukan Sewa**.
4. **Halaman Pembayaran**  
   Pengguna akan diarahkan ke halaman pembayaran untuk:
   - Memilih **metode pembayaran** 
   - Melihat **total tagihan** yang harus dibayarkan sesuai dengan tipe kamar dan durasi sewa yang dipilih.
   Setelah mengisi, pengguna kembali menekan tombol **Ajukan Sewa** maka sewa dan pembayaran berhasil dibuat

<p float="left">
   <img src="https://github.com/user-attachments/assets/8b41c50a-6d6f-4878-9a8e-80872e08b45f" width="170"/>
   <img src="https://github.com/user-attachments/assets/4361e082-b150-4a01-9d25-a35a71443604" width="170"/>
   <img src="https://github.com/user-attachments/assets/8b41c50a-6d6f-4878-9a8e-80872e08b45f" width="170"/>
   <img src="https://github.com/user-attachments/assets/842e3ee5-82db-44fa-94e6-4fc87325e37b" width="170"/>
</p>

