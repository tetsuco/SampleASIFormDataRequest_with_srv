<?php
$file_name = $_POST["file_name"];
$extension = $_POST["extension"];

if (is_uploaded_file($_FILES["upfile"]["tmp_name"])) {
  if (move_uploaded_file($_FILES["upfile"]["tmp_name"], "./" . $file_name . "." . $extension)) {
    echo $file_name . "." . $extension . "をアップロードしました。";
  } else {
    echo "ファイルをアップロードできません。";
  }
} else {
  echo "ファイルが選択されていません。";
}
?>
