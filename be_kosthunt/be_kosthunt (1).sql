-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 27, 2025 at 04:04 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `be_kosthunt`
--

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `ikon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`id`, `nama`, `ikon`) VALUES
(1, 'WiFi', 'fa-wifi'),
(2, 'Kamar Mandi Dalam', 'fa-shower'),
(3, 'Dapur Bersama', 'fa-utensils'),
(4, 'AC', 'fa-snowflake'),
(5, 'Lemari', 'fa-warehouse'),
(7, 'Meja Belajar', 'fa-book'),
(8, 'Parkir Motor', 'fa-motorcycle'),
(9, 'Parkir Mobil', 'fa-car'),
(10, 'CCTV', 'fa-video'),
(11, 'Water Heater', 'fa-temperature-high');

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas_properti`
--

CREATE TABLE `fasilitas_properti` (
  `id` int NOT NULL,
  `properti_id` int NOT NULL,
  `fasilitas_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fasilitas_properti`
--

INSERT INTO `fasilitas_properti` (`id`, `properti_id`, `fasilitas_id`) VALUES
(1, 3, 1),
(2, 3, 3),
(3, 3, 5),
(4, 3, 7),
(5, 3, 8),
(6, 4, 1),
(7, 4, 3),
(8, 4, 5),
(9, 4, 8),
(10, 4, 10),
(11, 6, 1),
(12, 6, 3),
(13, 6, 2),
(14, 6, 4),
(15, 6, 5),
(16, 6, 7),
(17, 6, 8),
(18, 6, 9),
(19, 7, 1),
(20, 7, 3),
(21, 7, 2),
(22, 7, 4),
(23, 7, 5),
(24, 7, 7),
(25, 7, 8),
(26, 7, 9),
(27, 7, 10),
(28, 7, 11),
(29, 8, 1),
(30, 8, 4),
(31, 8, 5),
(32, 8, 7),
(33, 8, 8),
(34, 9, 1),
(35, 9, 3),
(36, 9, 2),
(37, 9, 4),
(38, 9, 5),
(39, 9, 7),
(40, 9, 8),
(41, 9, 9),
(42, 9, 10),
(43, 9, 11);

-- --------------------------------------------------------

--
-- Table structure for table `favorit`
--

CREATE TABLE `favorit` (
  `id` int NOT NULL,
  `pengguna_id` int NOT NULL,
  `properti_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `favorit`
--

INSERT INTO `favorit` (`id`, `pengguna_id`, `properti_id`, `created_at`) VALUES
(6, 1, 6, '2025-06-13 10:19:25'),
(17, 10, 9, '2025-06-13 18:06:39');

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `id` int NOT NULL,
  `properti_id` int NOT NULL,
  `nama_kamar` varchar(100) NOT NULL,
  `harga` decimal(10,2) NOT NULL,
  `tipe_kelamin` enum('putra','putri','campur') NOT NULL,
  `status` enum('tersedia','dipesan','tidak_tersedia') DEFAULT 'tersedia',
  `foto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`id`, `properti_id`, `nama_kamar`, `harga`, `tipe_kelamin`, `status`, `foto`) VALUES
(2, 3, 'Kamar A1', '1200000.00', 'putra', 'tersedia', 'uploads/kamar/kos1.png'),
(3, 3, 'Kamar A2', '1500000.00', 'putra', 'dipesan', 'uploads/kamar/kos1_2.png'),
(4, 3, 'Kamar A3', '1000000.00', 'putra', 'tidak_tersedia', 'uploads/kamar/kos1_2.png'),
(5, 4, 'Compact Single A', '800000.00', 'putri', 'tersedia', 'uploads/kamar/kos2_1.png'),
(6, 4, 'Compact Single B', '720000.00', 'putri', 'dipesan', 'uploads/kamar/kos2_2.png'),
(7, 6, 'Lantai 1', '1500000.00', 'putri', 'tersedia', 'uploads/kamar/kos3_1.png'),
(8, 7, 'Gedung 1', '2500000.00', 'campur', 'tersedia', 'uploads/kamar/kos3_1.png'),
(9, 8, 'Lantai 1', '700000.00', 'putra', 'tersedia', 'uploads/kamar/kos5_1.png'),
(10, 8, 'Lantai 2', '950000.00', 'putra', 'tersedia', 'uploads/kamar/kos5_2.png'),
(11, 9, 'Kamar A', '2000000.00', 'campur', 'tersedia', 'uploads/kamar/kos6_1.png'),
(12, 9, 'Kamar B', '1900000.00', 'campur', 'tidak_tersedia', 'uploads/kamar/kos6_2.png'),
(13, 9, 'Kamar C', '2200000.00', 'campur', 'tersedia', 'uploads/kamar/kos6_3.png');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id` int NOT NULL,
  `pemesanan_id` int NOT NULL,
  `metode` varchar(50) DEFAULT NULL,
  `jumlah` decimal(10,2) NOT NULL,
  `status` enum('menunggu','berhasil','gagal') DEFAULT 'menunggu',
  `tanggal_pembayaran` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id`, `pemesanan_id`, `metode`, `jumlah`, `status`, `tanggal_pembayaran`) VALUES
(22, 24, 'BCA', '2050000.00', 'berhasil', '2025-06-15 09:04:29'),
(23, 25, 'Mandiri', '4050000.00', 'berhasil', '2025-06-15 09:20:10'),
(24, 26, 'BNI', '2050000.00', 'berhasil', '2025-06-15 09:28:36'),
(25, 27, 'BNI', '6050000.00', 'berhasil', '2025-06-16 07:31:37');

-- --------------------------------------------------------

--
-- Table structure for table `pemesanan`
--

CREATE TABLE `pemesanan` (
  `id` int NOT NULL,
  `pengguna_id` int NOT NULL,
  `kamar_id` int NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `status` enum('pending','dibayar','batal') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pemesanan`
--

INSERT INTO `pemesanan` (`id`, `pengguna_id`, `kamar_id`, `tanggal_mulai`, `tanggal_selesai`, `status`, `created_at`) VALUES
(23, 10, 11, '2025-06-26', '2026-03-26', 'pending', '2025-06-15 09:01:41'),
(24, 10, 11, '2025-06-27', '2025-07-27', 'pending', '2025-06-15 09:04:23'),
(25, 10, 11, '2025-06-19', '2025-08-19', 'pending', '2025-06-15 09:20:02'),
(26, 10, 11, '2025-06-28', '2025-07-28', 'pending', '2025-06-15 09:28:29'),
(27, 10, 11, '2025-06-27', '2025-09-27', 'pending', '2025-06-16 07:31:10');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `peran` enum('pemilik','pencari') DEFAULT 'pencari',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id`, `nama`, `email`, `password`, `no_hp`, `peran`, `created_at`) VALUES
(1, 'Budi Santoso', 'budi@gmail.com', '$2y$10$pTOYREvG4jrONvgiPvsF1uz8X98X0Q3e5qmuEn30/irIMZkGU0SkG', '08123456789', 'pencari', '2025-06-11 19:19:21'),
(3, 'Pemilik Kost', 'pemilik@example.com', '$2y$10$xuxqnBTqfopylUQKY3oxkOwr./fm72LfOPVIE/fNfbXDN4qozRZxC', '08123456754', 'pemilik', '2025-06-11 19:30:37'),
(4, 'ibu rosmini', 'rosmini@mail.com', '$2y$10$qEms8T99xsJHSUdN5ggAGeU/aW/beBbR4kddeSWvgCTy/yusBayIi', '08678235098', 'pemilik', '2025-06-12 07:19:17'),
(6, 'sintia', 'sintia@gmail.com', '$2y$10$rAauHoZJZlXC5IzBz0crv.OyE3KMNUHHuLOu6x2LiNa/aCEJf9IeO', '089876567462', 'pemilik', '2025-06-12 09:47:12'),
(7, 'Mr.kontrakan', 'kontrakan@gmail.com', '$2y$10$NkQsxAZk4eXw3LWvF8Y1heLJYIhaJ6hU/UO2RgWeZdSLeIns4IR7y', '087649095678', 'pemilik', '2025-06-12 10:10:13'),
(8, 'ibu kost', 'ibuibubiasa@gmail.com', '$2y$10$puMp4yARImfB/1US7S5OdeLVvzX.C2fLyDzBn777UZAFbqt2htJK2', '084234793045', 'pemilik', '2025-06-12 12:33:55'),
(9, 'Juragan Kost', 'juragan@gmail.com', '$2y$10$zStGzSBY7J1mdX/yHOz/CeJk15M3vgf63ucKpm769bmIijJT0uGvW', '083465725985', 'pemilik', '2025-06-12 13:05:48'),
(10, 'm', 'm@gmail.com', '$2y$10$KFRJChhdD0P1y1qbrGgQRu5YjhSSjpYNwV.3lF/rdCHfy7X7Lgg22', '08657654879', 'pencari', '2025-06-12 18:48:12'),
(11, 'kihi', 'kihi @gmail.com', '$2y$10$wUUO/zCS52HsDIv3ePp2TujCti/douenJTF/Rbcldrss91zCjT34C', '0987680987678', 'pencari', '2025-06-15 09:17:05'),
(12, 'kafi', 'kafi@gmail.com', '$2y$10$tr5VXD/dVgLxgNq6FC/oheYUQaF7QoIkO7Xah/HAyD/0qRc7tbbwy', '085678345678', 'pencari', '2025-06-16 05:21:09'),
(14, 'hello', 'helo@gmail.com', '$2y$10$3PzZ8ErNaQy4iHHzi1C5Vu2qa31eS1SwJRhJb0DFtxYLhgdPcS5W.', '08676374856', 'pencari', '2025-06-16 06:30:45');

-- --------------------------------------------------------

--
-- Table structure for table `pengumuman`
--

CREATE TABLE `pengumuman` (
  `id` int NOT NULL,
  `judul` varchar(150) NOT NULL,
  `isi` text NOT NULL,
  `tanggal` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `properti`
--

CREATE TABLE `properti` (
  `id` int NOT NULL,
  `nama_properti` varchar(255) DEFAULT NULL,
  `alamat` text NOT NULL,
  `deskripsi` text,
  `tipe` enum('kos','kontrakan') NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `pemilik_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `properti`
--

INSERT INTO `properti` (`id`, `nama_properti`, `alamat`, `deskripsi`, `tipe`, `foto`, `latitude`, `longitude`, `pemilik_id`, `created_at`) VALUES
(3, 'Kos Melati', 'Jl. Raya Tlogomas No. 80, Tlogomas, Kec. Lowokwaru, Kota Malang', 'Tempat tinggal dengan suasana sederhana dan tenang, cocok untuk kamu yang ingin hidup praktis tanpa perlu keluar biaya besar. Lokasi strategis dan mudah diakses, membuat aktivitas harian jadi lebih efisien.', 'kos', 'kos1.jpg', '-7.92399523', '112.59879615', 3, '2025-06-11 19:46:59'),
(4, 'Kos Lobi-lobi', 'Jl. Lobi‑lobi No. 6, Pisang Candi, Kec. Sukun, Kota Malang\"', 'Kos ekonomis dengan suasana yang mendukung kenyamanan dan ketenangan. Pilihan tepat bagi kamu yang mencari tempat tinggal sederhana dengan harga ramah di kantong.', 'kos', 'kos2.png', '-7.98151960', '112.61282130', 4, '2025-06-12 07:41:20'),
(6, 'Sinta House', 'Jl. Joyo Utomo V Blk. F No.13, Merjosari, Kec. Lowokwaru, Kota Malang, Jawa Timur 65144', 'Hunian ini merupakan pilihan ideal bagi keluarga kecil atau pasangan baru menikah yang mencari kenyamanan dan privasi. Rumah kontrakan terdiri dari dua kamar tidur, ruang tamu yang cukup luas, dapur tertutup, serta kamar mandi dengan shower. Halaman depan cukup untuk parkir motor atau taman kecil. Terletak di lingkungan yang tenang, tidak jauh dari sekolah, pasar, dan tempat ibadah. Akses jalan mudah dan aman, cocok untuk tempat tinggal jangka panjang.', 'kontrakan', 'kos3.png', '-7.94457000', '112.60080100', 6, '2025-06-12 09:48:29'),
(7, 'Griya Kontrakan', 'Jl. Koral, Tlogomas, Kec. Lowokwaru, Kota Malang, Jawa Timur 65144', 'Rumah kontrakan ini baru saja direnovasi, menawarkan kenyamanan seperti rumah sendiri. Terdiri dari 3 kamar tidur, dapur modern, dan ruang keluarga yang lapang. Lantai keramik baru, langit-langit tinggi, dan pencahayaan alami membuat rumah terasa sejuk dan terang. Lokasi sangat strategis, dekat jalan raya utama, namun tetap tenang dari kebisingan. Halaman depan luas dan tempat parkir mobil.', 'kontrakan', 'kos4.png', '-7.93431180', '112.60302640', 7, '2025-06-12 12:16:15'),
(8, 'Kos Jaya Sutoyo', 'Malang, Rampal Celaket, Kec. Klojen, Kota Malang, Jawa Timur 65111', 'Kos ini cocok untuk kamu yang mencari tempat tinggal dengan harga bersahabat dan suasana tenang. Terletak di lingkungan yang nyaman dan mudah dijangkau dari berbagai arah, kos ini menjadi pilihan tepat bagi mahasiswa maupun pekerja. Lokasinya dekat dengan pusat aktivitas, namun tetap memberikan kenyamanan untuk beristirahat setelah seharian beraktivitas. Pilihan ideal untuk kamu yang ingin tinggal hemat tanpa ribet.', 'kos', 'kos5.png', '-7.96426170', '112.63258760', 8, '2025-06-12 12:48:13'),
(9, 'Williams House', 'Jl. Bunga Merak II No.38, Jatimulyo, Kec. Lowokwaru, Kota Malang, Jawa Timur 65141', 'Kos nyaman, Berlokasi di jantung kota, dekat dengan area perkantoran, kampus, dan pusat perbelanjaaan. Lingkungan kos bersih dan dijaga setiap hari. Biaya terjangkau tanpa mengorbankan kenyamanan', 'kos', 'kos6.png', '-7.95062850', '112.62181490', 9, '2025-06-12 13:18:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fasilitas_properti`
--
ALTER TABLE `fasilitas_properti`
  ADD PRIMARY KEY (`id`),
  ADD KEY `properti_id` (`properti_id`),
  ADD KEY `fasilitas_id` (`fasilitas_id`);

--
-- Indexes for table `favorit`
--
ALTER TABLE `favorit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pengguna_id` (`pengguna_id`),
  ADD KEY `properti_id` (`properti_id`);

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `properti_id` (`properti_id`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pemesanan_id` (`pemesanan_id`);

--
-- Indexes for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pengguna_id` (`pengguna_id`),
  ADD KEY `kamar_id` (`kamar_id`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `pengumuman`
--
ALTER TABLE `pengumuman`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `properti`
--
ALTER TABLE `properti`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pemilik` (`pemilik_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `fasilitas_properti`
--
ALTER TABLE `fasilitas_properti`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `favorit`
--
ALTER TABLE `favorit`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `kamar`
--
ALTER TABLE `kamar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `pemesanan`
--
ALTER TABLE `pemesanan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `pengumuman`
--
ALTER TABLE `pengumuman`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `properti`
--
ALTER TABLE `properti`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fasilitas_properti`
--
ALTER TABLE `fasilitas_properti`
  ADD CONSTRAINT `fasilitas_properti_ibfk_1` FOREIGN KEY (`properti_id`) REFERENCES `properti` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fasilitas_properti_ibfk_2` FOREIGN KEY (`fasilitas_id`) REFERENCES `fasilitas` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `favorit`
--
ALTER TABLE `favorit`
  ADD CONSTRAINT `favorit_ibfk_1` FOREIGN KEY (`pengguna_id`) REFERENCES `pengguna` (`id`),
  ADD CONSTRAINT `favorit_ibfk_2` FOREIGN KEY (`properti_id`) REFERENCES `properti` (`id`);

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `kamar_ibfk_1` FOREIGN KEY (`properti_id`) REFERENCES `properti` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`pemesanan_id`) REFERENCES `pemesanan` (`id`);

--
-- Constraints for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD CONSTRAINT `pemesanan_ibfk_1` FOREIGN KEY (`pengguna_id`) REFERENCES `pengguna` (`id`),
  ADD CONSTRAINT `pemesanan_ibfk_2` FOREIGN KEY (`kamar_id`) REFERENCES `kamar` (`id`);

--
-- Constraints for table `properti`
--
ALTER TABLE `properti`
  ADD CONSTRAINT `fk_pemilik` FOREIGN KEY (`pemilik_id`) REFERENCES `pengguna` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `properti_ibfk_1` FOREIGN KEY (`pemilik_id`) REFERENCES `pengguna` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
