-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 09, 2019 at 03:53 PM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_gmc`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `detailpenjualan`
-- (See below for the actual view)
--
CREATE TABLE `detailpenjualan` (
`no_penjualan` varchar(11)
,`id_obat` varchar(10)
,`jumlah` int(11)
,`proses` int(1)
,`id_karyawan` varchar(10)
,`tgl_penjualan` date
,`nama_pasien` varchar(25)
,`alamat_pasien` text
,`nama_obat` varchar(30)
,`jenis` varchar(100)
,`stok` int(11)
,`letak` varchar(5)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `detail_karyawan`
-- (See below for the actual view)
--
CREATE TABLE `detail_karyawan` (
`id_karyawan` varchar(10)
,`nama_karyawan` varchar(30)
,`no_hp` varchar(13)
,`jabatan` varchar(15)
,`alamat` text
,`id_user` int(11)
,`username` varchar(16)
,`password` varchar(50)
,`level` int(1)
,`keterangan` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `detail_pembelian`
--

CREATE TABLE `detail_pembelian` (
  `no_pembelian` varchar(11) NOT NULL,
  `id_obat` varchar(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `proses` int(1) NOT NULL COMMENT '1=sudah, 0=belum'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_pembelian`
--

INSERT INTO `detail_pembelian` (`no_pembelian`, `id_obat`, `jumlah`, `proses`) VALUES
('B1901020001', 'AM022', 90, 1),
('B1901090001', 'AM022', 100, 1),
('B1901090002', 'AM022', 10, 1),
('B1901090002', 'BE001', 10, 1),
('B1901090002', 'GE123', 5, 1),
('B1901090003', 'AM022', 20, 1);

--
-- Triggers `detail_pembelian`
--
DELIMITER $$
CREATE TRIGGER `beli` AFTER INSERT ON `detail_pembelian` FOR EACH ROW BEGIN
UPDATE obat set stok = stok + NEW.jumlah WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `gajadi_beli` AFTER DELETE ON `detail_pembelian` FOR EACH ROW BEGIN
UPDATE obat set stok = stok - OLD.jumlah WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_pembelian` AFTER UPDATE ON `detail_pembelian` FOR EACH ROW BEGIN
if NEW.jumlah > OLD.jumlah
THEN
UPDATE obat set stok = NEW.jumlah - OLD.jumlah + stok WHERE id_obat = NEW.id_obat;
ELSE
UPDATE obat set stok = stok - OLD.jumlah - NEW.jumlah WHERE id_obat = NEW.id_obat;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_penjualan`
--

CREATE TABLE `detail_penjualan` (
  `no_penjualan` varchar(11) NOT NULL,
  `id_obat` varchar(10) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `proses` int(1) NOT NULL COMMENT '1=sudah 0=belum'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `detail_penjualan`
--

INSERT INTO `detail_penjualan` (`no_penjualan`, `id_obat`, `jumlah`, `proses`) VALUES
('B1901090001', 'AM022', 10, 1);

--
-- Triggers `detail_penjualan`
--
DELIMITER $$
CREATE TRIGGER `gajadi_jual` AFTER DELETE ON `detail_penjualan` FOR EACH ROW BEGIN
UPDATE obat set stok = stok + OLD.jumlah WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `jual` AFTER INSERT ON `detail_penjualan` FOR EACH ROW BEGIN
UPDATE obat set stok = stok - NEW.jumlah WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `karyawan_ifrs`
--

CREATE TABLE `karyawan_ifrs` (
  `id_karyawan` varchar(10) NOT NULL,
  `nama_karyawan` varchar(30) NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `jabatan` varchar(15) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `karyawan_ifrs`
--

INSERT INTO `karyawan_ifrs` (`id_karyawan`, `nama_karyawan`, `no_hp`, `jabatan`, `alamat`) VALUES
('ADM1', 'Adminnyaa', '08127222161', 'Kepala IFRS', ' Jalan Bunga Sepatu 2 Blok 4J no2'),
('KRS', 'Kepala RS', '081272221890', 'Kepala RS', 'Jalan BUnga Sedap Malam Raya no 34'),
('USR1', 'Usernyaa', '081277100256', 'Karyawan IFRS', '  Jalan Bunga Sedap malam Raya No 23'),
('USR2', 'User2', '08127222161', 'Karyawan IFRS', 'Jalan Bunga Sepatu');

-- --------------------------------------------------------

--
-- Stand-in structure for view `lap_pembelian`
-- (See below for the actual view)
--
CREATE TABLE `lap_pembelian` (
`no_pembelian` varchar(11)
,`id_obat` varchar(10)
,`jumlah` int(11)
,`proses` int(1)
,`nama_pbo` varchar(30)
,`id_karyawan` varchar(10)
,`tgl_pengiriman` date
,`nama_obat` varchar(30)
,`jenis` varchar(100)
,`stok` int(11)
,`letak` varchar(5)
);

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` varchar(10) NOT NULL,
  `nama_obat` varchar(30) NOT NULL,
  `jenis` varchar(100) NOT NULL,
  `stok` int(11) NOT NULL,
  `letak` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama_obat`, `jenis`, `stok`, `letak`) VALUES
('AC011', 'Acyclovir tab 400mg', 'Tablet', 290, 'A1A'),
('AL031', 'Alprazolam 0,5mg tab E Kat', 'Kapsul', 500, 'A1A'),
('AM001', 'Ambroxol 15mg/ml syrup E Kat', 'Sirup', 500, 'A1B'),
('AM002', 'Aminophylline inj 24mg/ml E Ka', 'Injeksi', 500, 'A1B'),
('AM003', 'Ambroxol tab 30mg', 'Tablet', 500, 'A1A'),
('AM021', 'Aminophylline inj 24mg/ml E Ka', 'Injeksi', 500, 'A1B'),
('AM022', 'Amoxilin ', 'Cair', -220, 'P2B'),
('AM421', 'Aminophylline 200mg tab', 'Tablet', 500, 'A1A'),
('BE001', 'Betadine ', 'Tablet', 90, 'P2A'),
('DE322', 'Dextrose 5%inf E Kat', 'Tablet', 200, 'D1B'),
('DE432', 'Dexametason inj', 'injeksi', 200, 'D1B'),
('ER001', 'Erythromicin kap 500mg E Kat', 'Kapsul', 500, 'E1A'),
('ET023', 'Etambutol tab 500mg', 'Tablet', 500, 'E1A'),
('FE213', 'Fenitoin Natrium inj 50mg/mlE ', 'Tablet', 200, 'F1B'),
('FE342', 'Fenobarbital inj 50mg/ml E Kat', 'Tablet', 200, 'F1B'),
('FE861', 'Fenitoin kap 100mg E Kat', 'Kapsul', 500, 'F1A'),
('FE901', 'Fenobarbital tab 30mg', 'Tablet', 500, 'F1A'),
('FL123', 'Fitomenadion tab 10mg E Kat', 'Tablet', 500, 'F1A'),
('FU213', 'Furosemid tab 40mg', 'Tablet', 500, 'F1A'),
('FU332', 'Furosemid  inj E Kat', 'Tablet', 200, 'F1B'),
('GE123', 'Gentamicin salp kulit', 'Salep', 295, 'G1B'),
('GE453', 'Gemfibrozil tab 300mg E  Kat', 'Tablet', 500, 'G1A'),
('GE521', 'Gentamicin inj 80mg', 'Tablet', 200, 'G1B'),
('GE564', 'Gentamicin TM', 'Tablet', 500, 'G1A'),
('GE644', 'Gentamicin inj 80mg E Kat', 'Tablet', 200, 'G1B'),
('GK001', 'Glukosa 40% E Kat', 'Kapsul', 500, 'G1A'),
('GL001', 'Glibenclamid tab 5mg', 'Tablet', 500, 'G1A'),
('GL002', 'Gliceril Guayacolat', 'Kapsul', 500, 'G1A'),
('GL003', 'Glimeprid tab 2mg', 'Tablet', 500, 'G1A'),
('GL004', 'Gliquidon tab 30mg', 'Tablet', 500, 'G1A'),
('HA001', 'Haloperidol tab 1,5mg', 'Tablet', 500, 'H1A'),
('HA002', 'Haloperidol tab 5mg', 'Tablet', 500, 'H1A'),
('HA003', 'Haloperidol tab 0.5mg E Kat', 'Tablet', 500, 'H1A'),
('HA004', 'Haloperidol tab 1.5mg E Kat', 'Tablet', 500, 'H1A'),
('HA005', 'Haloperidol tab 5mg E Kat', 'Tablet', 500, 'H1A'),
('HY001', 'Hydrocortison cream 2.5%', 'Salep', 500, 'H1B'),
('HY002', 'Hydrocortison cream 2.5% E Kat', 'Salep', 500, 'H1B'),
('IB001', 'Ibuprofen tab 400mg E Kat', 'Tablet', 510, 'I1A'),
('IB002', 'Ibuprofen tab 200mg E Kat', 'Tablet', 510, 'I1A'),
('IS001', 'Isoniazid 300mg tab', 'Tablet', 500, 'I1A'),
('IS002', 'Isosorbid Dinitrat 5mg E Kat', 'Kapsul', 500, 'I1A'),
('IS003', 'Isosorbid Dinitrat 5mg ', 'Kapsul', 500, 'I1A'),
('KA001', 'Kalium Diclofenac tab 50mg E K', 'Tablet', 500, 'K1A'),
('KE001', 'Ketoconazol cream 2%', 'Salep', 500, 'K1A'),
('KE002', 'Ketoconazol tab 200mg', 'Tablet', 500, 'K1A'),
('KE003', 'Ketoprofen tab 100mg', 'Tablet', 500, 'K1A'),
('KE007', 'Ketoprofen tab 100mg E Kat', 'Tablet', 500, 'K1A'),
('KE008', 'Ketorolac inj 30mg E Kat', 'Tablet', 200, 'K1B'),
('KL003', 'Klindamisin kap 300mg', 'Kapsul', 500, 'K1A'),
('KL004', 'Klindamisin kap 150mg E Kat', 'Kapsul', 500, 'K1A'),
('KL005', 'Kloramfenicol SM 1%', 'Tablet', 500, 'K1A'),
('KL006', 'Kloramfenicol TT ', 'Tablet', 500, 'K1A'),
('KL007', 'Klorpromazin inj 25mg/ml', 'Tablet', 200, 'K1B');

-- --------------------------------------------------------

--
-- Table structure for table `pembelian`
--

CREATE TABLE `pembelian` (
  `no_pembelian` varchar(12) NOT NULL,
  `nama_pbo` varchar(30) NOT NULL,
  `id_karyawan` varchar(10) NOT NULL,
  `tgl_pengiriman` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pembelian`
--

INSERT INTO `pembelian` (`no_pembelian`, `nama_pbo`, `id_karyawan`, `tgl_pengiriman`) VALUES
('B1901020001', 'KF Lampung', 'ADM1', '2019-01-02'),
('B1901090001', 'BIO FARMA', 'ADM1', '2019-01-09'),
('B1901090002', 'KF Lampung', 'ADM1', '2019-01-09'),
('B1901090003', 'KF Lampung', 'ADM1', '2019-01-09');

-- --------------------------------------------------------

--
-- Table structure for table `penjualan`
--

CREATE TABLE `penjualan` (
  `no_penjualan` varchar(11) NOT NULL,
  `id_karyawan` varchar(10) NOT NULL,
  `tgl_penjualan` date NOT NULL,
  `nama_pasien` varchar(25) NOT NULL,
  `alamat_pasien` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penjualan`
--

INSERT INTO `penjualan` (`no_penjualan`, `id_karyawan`, `tgl_penjualan`, `nama_pasien`, `alamat_pasien`) VALUES
('1901090002', 'ADM1', '2019-01-09', 'Jio', 'Jalan-Jalan'),
('B1901090001', 'ADM1', '2019-01-09', 'Mul', 'Jl. Kenanga');

--
-- Triggers `penjualan`
--
DELIMITER $$
CREATE TRIGGER `delete` AFTER DELETE ON `penjualan` FOR EACH ROW BEGIN
  DELETE FROM detail_penjualan
  WHERE no_penjualan=old.no_penjualan;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `tigatabel`
-- (See below for the actual view)
--
CREATE TABLE `tigatabel` (
`no_penjualan` varchar(11)
,`id_obat` varchar(10)
,`jumlah` int(11)
,`proses` int(1)
,`id_karyawan` varchar(10)
,`tgl_penjualan` date
,`nama_pasien` varchar(25)
,`alamat_pasien` text
,`nama_obat` varchar(30)
,`jenis` varchar(100)
,`stok` int(11)
,`letak` varchar(5)
);

-- --------------------------------------------------------

--
-- Table structure for table `user_login`
--

CREATE TABLE `user_login` (
  `id_user` int(11) NOT NULL,
  `id_karyawan` varchar(10) NOT NULL,
  `username` varchar(16) NOT NULL,
  `password` varchar(50) NOT NULL,
  `level` int(1) NOT NULL,
  `keterangan` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_login`
--

INSERT INTO `user_login` (`id_user`, `id_karyawan`, `username`, `password`, `level`, `keterangan`) VALUES
(1, 'ADM1', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1, 'Administrator'),
(2, 'USR1', 'user', 'ee11cbb19052e40b07aac0ca060c23ee', 2, 'Pegawai'),
(20, 'KRS', 'krs', 'a669a411d6370f43d8282525974a896f', 3, 'Kepala RS');

-- --------------------------------------------------------

--
-- Structure for view `detailpenjualan`
--
DROP TABLE IF EXISTS `detailpenjualan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detailpenjualan`  AS  select `detail_penjualan`.`no_penjualan` AS `no_penjualan`,`detail_penjualan`.`id_obat` AS `id_obat`,`detail_penjualan`.`jumlah` AS `jumlah`,`detail_penjualan`.`proses` AS `proses`,`penjualan`.`id_karyawan` AS `id_karyawan`,`penjualan`.`tgl_penjualan` AS `tgl_penjualan`,`penjualan`.`nama_pasien` AS `nama_pasien`,`penjualan`.`alamat_pasien` AS `alamat_pasien`,`obat`.`nama_obat` AS `nama_obat`,`obat`.`jenis` AS `jenis`,`obat`.`stok` AS `stok`,`obat`.`letak` AS `letak` from ((`detail_penjualan` join `penjualan`) join `obat`) where ((`detail_penjualan`.`no_penjualan` = `penjualan`.`no_penjualan`) and (`obat`.`id_obat` = `detail_penjualan`.`id_obat`)) ;

-- --------------------------------------------------------

--
-- Structure for view `detail_karyawan`
--
DROP TABLE IF EXISTS `detail_karyawan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detail_karyawan`  AS  select `karyawan_ifrs`.`id_karyawan` AS `id_karyawan`,`karyawan_ifrs`.`nama_karyawan` AS `nama_karyawan`,`karyawan_ifrs`.`no_hp` AS `no_hp`,`karyawan_ifrs`.`jabatan` AS `jabatan`,`karyawan_ifrs`.`alamat` AS `alamat`,`user_login`.`id_user` AS `id_user`,`user_login`.`username` AS `username`,`user_login`.`password` AS `password`,`user_login`.`level` AS `level`,`user_login`.`keterangan` AS `keterangan` from (`karyawan_ifrs` join `user_login`) where (`karyawan_ifrs`.`id_karyawan` = `user_login`.`id_karyawan`) ;

-- --------------------------------------------------------

--
-- Structure for view `lap_pembelian`
--
DROP TABLE IF EXISTS `lap_pembelian`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lap_pembelian`  AS  select `detail_pembelian`.`no_pembelian` AS `no_pembelian`,`detail_pembelian`.`id_obat` AS `id_obat`,`detail_pembelian`.`jumlah` AS `jumlah`,`detail_pembelian`.`proses` AS `proses`,`pembelian`.`nama_pbo` AS `nama_pbo`,`pembelian`.`id_karyawan` AS `id_karyawan`,`pembelian`.`tgl_pengiriman` AS `tgl_pengiriman`,`obat`.`nama_obat` AS `nama_obat`,`obat`.`jenis` AS `jenis`,`obat`.`stok` AS `stok`,`obat`.`letak` AS `letak` from ((`pembelian` join `detail_pembelian`) join `obat`) where ((`detail_pembelian`.`no_pembelian` = `pembelian`.`no_pembelian`) and (`detail_pembelian`.`id_obat` = `obat`.`id_obat`)) ;

-- --------------------------------------------------------

--
-- Structure for view `tigatabel`
--
DROP TABLE IF EXISTS `tigatabel`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tigatabel`  AS  select `detail_penjualan`.`no_penjualan` AS `no_penjualan`,`detail_penjualan`.`id_obat` AS `id_obat`,`detail_penjualan`.`jumlah` AS `jumlah`,`detail_penjualan`.`proses` AS `proses`,`penjualan`.`id_karyawan` AS `id_karyawan`,`penjualan`.`tgl_penjualan` AS `tgl_penjualan`,`penjualan`.`nama_pasien` AS `nama_pasien`,`penjualan`.`alamat_pasien` AS `alamat_pasien`,`obat`.`nama_obat` AS `nama_obat`,`obat`.`jenis` AS `jenis`,`obat`.`stok` AS `stok`,`obat`.`letak` AS `letak` from ((`detail_penjualan` join `penjualan`) join `obat`) where ((`detail_penjualan`.`no_penjualan` = `penjualan`.`no_penjualan`) and (`detail_penjualan`.`id_obat` = `obat`.`id_obat`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pembelian`
--
ALTER TABLE `detail_pembelian`
  ADD KEY `no_pembelian` (`no_pembelian`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD KEY `detail_penjualan_ibfk_2` (`no_penjualan`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `karyawan_ifrs`
--
ALTER TABLE `karyawan_ifrs`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`);

--
-- Indexes for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD PRIMARY KEY (`no_pembelian`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`no_penjualan`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `user_login`
--
ALTER TABLE `user_login`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user_login`
--
ALTER TABLE `user_login`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pembelian`
--
ALTER TABLE `detail_pembelian`
  ADD CONSTRAINT `detail_pembelian_ibfk_2` FOREIGN KEY (`no_pembelian`) REFERENCES `pembelian` (`no_pembelian`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_pembelian_ibfk_3` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `detail_penjualan`
--
ALTER TABLE `detail_penjualan`
  ADD CONSTRAINT `detail_penjualan_ibfk_1` FOREIGN KEY (`no_penjualan`) REFERENCES `penjualan` (`no_penjualan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_penjualan_ibfk_2` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`) ON DELETE NO ACTION;

--
-- Constraints for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD CONSTRAINT `pembelian_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan_ifrs` (`id_karyawan`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan_ifrs` (`id_karyawan`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `user_login`
--
ALTER TABLE `user_login`
  ADD CONSTRAINT `user_login_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan_ifrs` (`id_karyawan`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
