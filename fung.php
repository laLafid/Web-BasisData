<?php
include 'koneksi.php';

$fungsi = $_GET['fungsi'] ?? '';
?>
<!DOCTYPE html>
<html>
<head>
    <title>Fungsi $fungsi</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; padding: 20px; }
        h2 { text-align: center; } 
        table { width: 90%; margin: 20px auto; border-collapse: collapse; background: #fff; }
        th, td { padding: 12px; border: 1px solid #ccc; }
        th { background-color: #2c3e50; color: white; }
        tr:hover { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h2>Hasil dari Fungsi: <code><?= htmlspecialchars($fungsi) ?>()</code></h2>
    <?php
        switch ($fungsi) {
            case 'concat':
                $query = "SELECT nama, kota, CONCAT(nama, ' dari ', kota) AS identitas FROM mahasiswa";
                break;
            case 'upper':
                $query = "SELECT nama, UPPER(nama) AS nama_besar FROM mahasiswa";
                break;
            case 'datediff':
                $query = "SELECT nama, tgl_lahir, DATEDIFF(CURDATE(), tgl_lahir) AS umur_hari FROM mahasiswa";
                break;
            case 'ifnull':
                $query = " SELECT  m.nim, m.nama, mk.nama AS matakuliah, IFNULL(k.nilai, NULL) AS nilai FROM krsmahasiswa k JOIN mahasiswa m ON k.nim = m.nim JOIN matakuliah mk ON k.kd_mk = mk.kd_mk";
                break;
            case 'now':
                $query = "SELECT NOW() AS waktu_sistem";
                break;
            case 'format_jadwal':
                $query = "SELECT hari, jam, format_jadwal(hari, jam) AS jadwal FROM jadwalmengajar";
                break;
            case 'status_lulus':
                $query = " SELECT k.nim, mh.nama AS nama_mahasiswa, mk.nama AS nama_matkul, k.nilai, status_lulus(k.nilai) AS status FROM krsmahasiswa k JOIN mahasiswa mh ON k.nim = mh.nim JOIN matakuliah mk ON k.kd_mk = mk.kd_mk";
                break;
            default:
                echo "<p style='text-align:center;'>Fungsi tidak dikenali</p>";
                exit;
        }

        $result = $conn->query($query);

        if ($result && $result->num_rows > 0) {
            echo "<table><tr>";
            foreach ($result->fetch_fields() as $field) {
                echo "<th>{$field->name}</th>";
            }
            echo "</tr>";
            while ($row = $result->fetch_assoc()) {
                echo "<tr>";
                foreach ($row as $val) {
                    echo "<td>$val</td>";
                }
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p style='text-align:center;'>Tidak ada data</p>";
        }
?>
</body>
</html>