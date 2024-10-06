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

    <?php
    /*--------------------------*\
    |   Koden för inloggningen   | 
    \*--------------------------*/
    ?>
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
        try {
            $pdo = new PDO("mysql:dbname=TomteVerkstad;host=localhost", $_POST["Username"], $_POST["Password"]); // koden för att ansluta till databasen
            $_SESSION["Username"] = $_POST["Username"];         
            $_SESSION["Password"] = $_POST["Password"];     
            echo "Login successfull";
            echo "<br>";
        }
        catch (PDOException $e) {
            exit("Login failed: " . $e->getMessage());
        }
    }

    echo "<br>";
    /*--------------------------*\
    |   Koden för utloggningen   | 
    \*--------------------------*/
    ?>

    <form action = "Inlogg.php" method = "POST">
        <input type="hidden" name="Logout" value="True">
        <input type="submit" name="submit" value="Logout"> 
    </form>

    <?php
    
    if(!empty($_POST["Logout"])){
        $_SESSION["Username"] = ""; 
        $_SESSION["Password"] = "";
        echo "Logout successfull";
        echo "<br>";
    }

    echo "<br>";
    /*----------------------------*\
    |   Koden för att flyta sida   | 
    \*----------------------------*/
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <input type="submit" name="submit" value="Move"> 
    </form>
    
</body>
</html>