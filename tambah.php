<?php
include 'koneksi.php';

$table = $_POST['table'];

$stmt = $conn->prepare("DESCRIBE `$table`");
$stmt->execute();
$result = $stmt->get_result();

$columns = [];
$values = [];
$placeholders = [];

while ($row = $result->fetch_assoc()) {
  $field = $row['Field'];
  if (isset($_POST[$field])) {
    $columns[] = $field;
    $values[] = $_POST[$field];
    $placeholders[] = '?';
  }
}

$sql = "INSERT INTO `$table` (" . implode(',', $columns) . ") VALUES (" . implode(',', $placeholders) . ")";
$query = $conn->prepare($sql);
$query->bind_param(str_repeat("s", count($values)), ...$values);
$query->execute();

echo "Data berhasil ditambahkan ke tabel <strong>$table</strong>!";
echo "<br><a href='tambahin.php'>Kembali</a>"; //ganti nama filenya kalo mau
?>
