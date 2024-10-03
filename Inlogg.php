<?php
    session_start()
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <form action = "Inlogg.php" method = "POST">
        <p> Login </p>
        Name 
        <input type="text" name="Username" value=""> <br>
        Password
        <input type="password" name="Password" value=""> <br>
        <br>
        <input type="submit" name="submit" value="Login"> 
    </form>

    <?php
    
    if(!empty($_POST["Username"]) && !empty($_POST["Password"])){
        $_SESSION["Username"] = $_POST["Username"];         // dbkonstruktion
        $_SESSION["Password"] = $_POST["Password"];         // Skata#23
        try {
            $pdo = new PDO("mysql:dbname=TomteVerkstad;host=localhost", $_POST["Username"], $_POST["Password"]); // koden för att ansluta till databasen
            echo "Login successfull";
        }
        catch (PDOException $e) {
            exit("Login failed: " . $e->getMessage());
        }
    }

    echo "<br>";
    ?>

    <form action = "TomteVerkstad.php">
        <input type="submit" name="submit" value="Move"> 
    </form>
    
</body>
</html>