<?php 
include 'koneksi.php';
?>

<!DOCTYPE html>
<html>
<head>
    <title>Data Jadwal, KRS, Matakuliah, Mahasiswa, Dosen</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }
        h2 {
            color: #333;
            margin-top: 40px;
        }
        table {
            width: 90%;
            margin: 10px auto 40px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #2c3e50;
            color: white;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .no-data {
            text-align: center;
            color: #888;
            font-style: italic;
        }
    </style>
</head>
<body>

<!-- Mangasiswa -->
<h2>Daftar Mahasiswa</h2>

<?php 
$query = "SELECT * FROM Mahasiswa";
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
    echo "<table>";
    echo "<tr><th>NIM</th><th>Nama</th><th>Jenis Kelamin</th><th>Kota</th></tr>";
    
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($row["nim"]) . "</td>";
        echo "<td>" . htmlspecialchars($row["nama"]) . "</td>";
        echo "<td>" . ($row["jenis_kelamin"] == 'P' ? 'Pria' : 'Wanita') . "</td>";
        echo "<td>" . htmlspecialchars($row["kota"]) . "</td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    echo "<p>Tidak ada data mahasiswa.</p>";
}
?>

<!-- Dosen -->
<h2>Daftar Dosen</h2>

<?php 
$query = "SELECT * FROM Dosen";
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
    echo "<table>";
    echo "<tr><th>Kode Dosen</th><th>Nama Dosen</th></tr>";
    
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($row["kd_ds"]) . "</td>";
        echo "<td>" . htmlspecialchars($row["nama"]) . "</td>";
        echo "</tr>";
    }

    echo "</table>";
} else {
    echo "<p class='no-data'>Tidak ada data dosen.</p>";
}
?>

<!-- JADWALMENGAJAR -->
<h2>Data Jadwal Mengajar</h2>
<?php
$query = "SELECT * FROM JadwalMengajar";
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
    echo "<table><tr><th>Kode MK</th><th>Kode Dosen</th><th>Hari</th><th>Jam</th><th>Ruang</th></tr>";
    while ($row = mysqli_fetch_assoc($result)) {
        echo "<tr>
                <td>{$row['kd_mk']}</td>
                <td>{$row['kd_ds']}</td>
                <td>{$row['hari']}</td>
                <td>{$row['jam']}</td>
                <td>{$row['ruang']}</td>
              </tr>";
    }
    echo "</table>";
} else {
    echo "<p class='no-data'>Tidak ada data Jadwal Mengajar.</p>";
}
?>

<!-- KRSMAHASISWA -->
<h2>Data KRS Mahasiswa</h2>
<?php
$query = "SELECT * FROM KRSMahasiswa";
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
    echo "<table><tr><th>NIM</th><th>Kode MK</th><th>Kode Dosen</th><th>Semester</th><th>Nilai</th></tr>";
    while ($row = mysqli_fetch_assoc($result)) {
        echo "<tr>
                <td>{$row['nim']}</td>
                <td>{$row['kd_mk']}</td>
                <td>{$row['kd_ds']}</td>
                <td>{$row['semester']}</td>
                <td>{$row['nilai']}</td>
              </tr>";
    }
    echo "</table>";
} else {
    echo "<p class='no-data'>Tidak ada data KRS Mahasiswa.</p>";
}
?>

<!-- MATAKULIAH -->
<h2>Data Matakuliah</h2>
<?php
$query = "SELECT * FROM Matakuliah";
$result = mysqli_query($conn, $query);
if (mysqli_num_rows($result) > 0) {
    echo "<table><tr><th>Kode MK</th><th>Nama Matakuliah</th><th>SKS</th></tr>";
    while ($row = mysqli_fetch_assoc($result)) {
        echo "<tr>
                <td>{$row['kd_mk']}</td>
                <td>{$row['nama']}</td>
                <td>{$row['sks']}</td>
              </tr>";
    }
    echo "</table>";
} else {
    echo "<p class='no-data'>Tidak ada data Matakuliah.</p>";
}
mysqli_close($conn);
?>

</body>
</html>
