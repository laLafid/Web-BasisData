-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 07 Jul 2025 pada 13.56
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `praktikum 5`
--

DELIMITER $$
--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `format_jadwal` (`hari` VARCHAR(10), `jam` TIME) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN CONCAT(hari, ', jam ', TIME_FORMAT(jam, '%H:%i'))$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_umur` (`tgl` DATE) RETURNS INT(11) DETERMINISTIC RETURN TIMESTAMPDIFF(YEAR, tgl, CURDATE())$$

CREATE DEFINER=`root`@`localhost` FUNCTION `inisial_dosen` (`nama` VARCHAR(100)) RETURNS VARCHAR(5) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN UPPER(LEFT(nama, 3))$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jenis_kelamin_lengkap` (`jk` CHAR(1)) RETURNS VARCHAR(10) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN IF(jk = 'L', 'Laki-laki', 'Perempuan')$$

CREATE DEFINER=`root`@`localhost` FUNCTION `label_mahasiswa` (`nama` VARCHAR(100), `nim` VARCHAR(10)) RETURNS VARCHAR(150) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN CONCAT(nama, ' [NIM: ', nim, ']')$$

CREATE DEFINER=`root`@`localhost` FUNCTION `lama_studi` (`semester` INT) RETURNS VARCHAR(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN CONCAT(semester * 6, ' bulan')$$

CREATE DEFINER=`root`@`localhost` FUNCTION `nama_kota` (`nama` VARCHAR(100), `kota` VARCHAR(50)) RETURNS VARCHAR(150) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN CONCAT(nama, ' dari ', kota)$$

CREATE DEFINER=`root`@`localhost` FUNCTION `nilai_angka` (`nilai` CHAR(2)) RETURNS INT(11) DETERMINISTIC RETURN CASE
WHEN nilai = 'A' THEN 4
WHEN nilai = 'B' THEN 3
WHEN nilai = 'C' THEN 2
WHEN nilai = 'D' THEN 1
ELSE 0
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `status_lulus` (`nilai` CHAR(2)) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC RETURN IF(nilai IN ('A', 'B', 'C'), 'Lulus', 'Tidak Lulus')$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_sks` (`nim_input` VARCHAR(10)) RETURNS INT(11) DETERMINISTIC RETURN (
SELECT SUM(mk.sks)
FROM KRSMahasiswa k
JOIN Matakuliah mk ON k.kd_mk = mk.kd_mk
WHERE k.nim = nim_input
)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `dosen`
--

CREATE TABLE `dosen` (
  `kd_ds` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dosen`
--

INSERT INTO `dosen` (`kd_ds`, `nama`) VALUES
('D001', 'Ananto'),
('D002', 'Supriapto');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jadwalmengajar`
--

CREATE TABLE `jadwalmengajar` (
  `kd_ds` varchar(10) NOT NULL,
  `kd_mk` varchar(10) NOT NULL,
  `hari` varchar(10) DEFAULT NULL,
  `jam` time DEFAULT NULL,
  `ruang` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jadwalmengajar`
--

INSERT INTO `jadwalmengajar` (`kd_ds`, `kd_mk`, `hari`, `jam`, `ruang`) VALUES
('D001', 'MK001', 'Senin', '08:00:00', 'LAB1'),
('D002', 'MK002', 'Selasa', '07:30:00', 'LAB1');

-- --------------------------------------------------------

--
-- Struktur dari tabel `krsmahasiswa`
--

CREATE TABLE `krsmahasiswa` (
  `nim` varchar(15) NOT NULL,
  `kd_mk` varchar(10) NOT NULL,
  `kd_ds` varchar(10) DEFAULT NULL,
  `semester` int(11) DEFAULT NULL,
  `nilai` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `krsmahasiswa`
--

INSERT INTO `krsmahasiswa` (`nim`, `kd_mk`, `kd_ds`, `semester`, `nilai`) VALUES
('M001', 'MK001', 'D001', 4, 'A'),
('M001', 'MK002', 'D002', 4, 'C'),
('M002', 'MK001', 'D001', 4, 'A'),
('M002', 'MK002', 'D002', 4, 'B'),
('M003', 'MK001', 'D001', 4, 'A'),
('M003', 'MK002', 'D002', 4, 'B'),
('M004', 'MK001', 'D001', 2, 'B'),
('M004', 'MK002', 'D002', 2, NULL),
('M005', 'MK001', 'D001', 2, NULL),
('M005', 'MK002', 'D002', 2, NULL),
('M006', 'MK001', 'D001', 5, 'A'),
('M006', 'MK002', 'D002', 5, 'B');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `nim` varchar(15) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `jenis_kelamin` char(1) DEFAULT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `kodepos` varchar(10) DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL,
  `jalan` varchar(100) DEFAULT NULL,
  `kd_ds` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`nim`, `nama`, `jenis_kelamin`, `tgl_lahir`, `no_hp`, `alamat`, `kodepos`, `kota`, `jalan`, `kd_ds`) VALUES
('M001', 'Agus', 'P', '2000-06-21', '08123456789', 'Jl. Pengapul No.69', '17411', 'Bekasi', 'Jalan Kapoor', 'D001'),
('M002', 'Pashad', 'P', '2000-06-21', '08123456789', 'Jl. Pohon No.69', '17400', 'Bekasi', 'Pp Pisan', 'D001'),
('M003', 'Kepin', 'P', '2005-06-21', '08123456789', 'Jl. Parti No.69', '17350', 'Bekasi', 'Pp Pisan', 'D001'),
('M004', 'Paldi', 'W', '2000-07-21', '08123456789', 'Jl. Pengapul No.69', '17411', 'curug', 'Jalan Panjang', 'D001'),
('M005', 'Rudi', 'W', '2000-07-21', '08123456789', 'Jl. Kelinci No.69', '17411', 'curug', 'Jalan Panjang', 'D001'),
('M006', 'Agus2', 'P', '2000-08-21', '08123456789', 'Jl. Parti No.69', '17411', 'curug', 'Jalan Panjang', 'D001');

-- --------------------------------------------------------

--
-- Struktur dari tabel `matakuliah`
--

CREATE TABLE `matakuliah` (
  `kd_mk` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `sks` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `matakuliah`
--

INSERT INTO `matakuliah` (`kd_mk`, `nama`, `sks`) VALUES
('MK001', 'Struktur Data', 3),
('MK002', 'Pemrograman', 2),
('MK003', 'Bahasa Inggris', 1);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`kd_ds`);

--
-- Indeks untuk tabel `jadwalmengajar`
--
ALTER TABLE `jadwalmengajar`
  ADD PRIMARY KEY (`kd_ds`,`kd_mk`),
  ADD KEY `jadwalmengajar_matkul` (`kd_mk`);

--
-- Indeks untuk tabel `krsmahasiswa`
--
ALTER TABLE `krsmahasiswa`
  ADD PRIMARY KEY (`nim`,`kd_mk`),
  ADD KEY `dosen` (`kd_ds`),
  ADD KEY `krsmamatkul` (`kd_mk`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`nim`),
  ADD KEY `mdosen` (`kd_ds`);

--
-- Indeks untuk tabel `matakuliah`
--
ALTER TABLE `matakuliah`
  ADD PRIMARY KEY (`kd_mk`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `jadwalmengajar`
--
ALTER TABLE `jadwalmengajar`
  ADD CONSTRAINT `jadwalmengajar_dosen` FOREIGN KEY (`kd_ds`) REFERENCES `dosen` (`kd_ds`),
  ADD CONSTRAINT `jadwalmengajar_matkul` FOREIGN KEY (`kd_mk`) REFERENCES `matakuliah` (`kd_mk`);

--
-- Ketidakleluasaan untuk tabel `krsmahasiswa`
--
ALTER TABLE `krsmahasiswa`
  ADD CONSTRAINT `dosen` FOREIGN KEY (`kd_ds`) REFERENCES `dosen` (`kd_ds`),
  ADD CONSTRAINT `krsmamatkul` FOREIGN KEY (`kd_mk`) REFERENCES `matakuliah` (`kd_mk`),
  ADD CONSTRAINT `krsnim` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`);

--
-- Ketidakleluasaan untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `mdosen` FOREIGN KEY (`kd_ds`) REFERENCES `dosen` (`kd_ds`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
