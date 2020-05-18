<?php
session_start();

if (isset($_SESSION['Id'])){
	$Id = $_SESSION['Id'];
}
else{
	$Id = substr(str_shuffle(str_repeat('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',5)),0,5);
	$_SESSION['Id'] = $Id;
}

#Save new data point
$Result=$_POST['ExperimentResult'];

$my_date = date("Y-m-d H:i:s");

$con = mysqli_connect("localhost","lopez-brau","Abcdeft2!","michael");
if (!$con){
    die("Connection failed: " . mysqli_connect_error() . " Please email colin.jacobs@yale.edu with this message.");
}

$query = "INSERT INTO ImageInference_Exp1 (unique_id, results, completion_date) VALUES ('$Id', '$Result', '$my_date')";
if (!mysqli_query($con, $query)){
	echo "Could not update database. Please email colin.jacobs@yale.edu with the following message:<br>" . mysqli_error($con);
}

mysqli_close($con);
?>

<body><br><br><br><br>
	<h2>
	<center> Insert the following code on the previous page to continue to the final part of the experiment:
</h2>
<center>
<h1><br><br> <?php echo "M7p1m" . $Id;?></h1></center>
</center>
</body>
</html>
