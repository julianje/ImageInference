$id = intval($_POST['id']);
mysql_query("UPDATE votes SET num = num + 1 WHERE id = $id");
