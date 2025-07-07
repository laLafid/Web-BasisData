<!DOCTYPE html>
<html>
<head>
    <title>Tambahin Data</title>
    <style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f4f4f4;
        padding: 20px;
    }
    h2, h3 {
        color: #333;
        text-align: center;
        margin-top: 40px;
    }
    form {
        width: 90%;
        max-width: 600px;
        margin: 30px auto;
        background-color: #fff;
        padding: 25px 30px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    label {
        display: block;
        margin-bottom: 6px;
        font-weight: bold;
        color: #444;
    }
    input[type="text"],
    input[type="number"],
    input[type="date"],
    input[type="time"],
    select {
        width: 100%;
        padding: 10px 12px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 15px;
        transition: border-color 0.3s;
    }
    input:focus, select:focus {
        border-color: #2980b9;
        outline: none;
    }
    button {
        background-color: #2980b9;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    button:hover {
        background-color: #1c5980;
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
<?php
include 'koneksi.php';

$entities = [
  'dosen', 'jadwalmengajar', 'krsmahasiswa', 'mahasiswa', 'matakuliah'
];

$table = $_GET['table'] ?? null;

if (!$table) {
  echo "<form method='get'>";
  echo "<label>Pilih Tabel:</label> ";
  echo "<select name='table'>";
  foreach ($entities as $ent) {
    echo "<option value='$ent'>$ent</option>";
  }
  echo "</select>";
  echo "<button type='submit'>Lanjut</button>";
  echo "</form>";
} else {
  $stmt = $conn->prepare("DESCRIBE `$table`");
  $stmt->execute();
  $result = $stmt->get_result();
  $fields = [];

  while ($row = $result->fetch_assoc()) {
    if (stripos($row['Extra'], 'auto_increment') === false) {
      $fields[] = $row;
    }
  }

  echo "<h3>Tambah Data ke <i>$table</i></h3>";
  echo "<form method='post' action='tambah.php'>"; //ganti nama filenya kalo mau
  echo "<input type='hidden' name='table' value='$table'>";

  foreach ($fields as $field) {
    $name = $field['Field'];
    $type = strtolower($field['Type']);

    if (strpos($type, 'int') !== false) {
      $inputType = 'number';
    } elseif (strpos($type, 'date') !== false) {
      $inputType = 'date';
    } elseif (strpos($type, 'time') !== false) {
      $inputType = 'time';
    } elseif (strpos($type, 'char(1)') !== false) {
      $inputType = 'text';
      echo "<label>$name:</label> 
      <select name='$name'>
        <option value='L'>L</option>
        <option value='P'>P</option>
      </select><br>";
      continue;
    } else {
      $inputType = 'text';
    }

    echo "<label>$name:</label> <input type='$inputType' name='$name'><br>";
  }

  echo "<button type='submit'>Simpan 💾</button>";
  echo "</form>";
}
?>
</body>
</html>