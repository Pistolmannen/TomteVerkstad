<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>This is Tomtens Verkstad</title>
</head>
<body>
    <?php
    $pdo = new PDO("mysql:dbname=TomteVerkstad;host=localhost", "dbkonstruktion", "Skata#23");

    if (empty($_POST["name"])) {
        $name = "Name";
    } 
    else {
        $name = $_POST["name"];
    }

    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        Search for Tomtenissar <br>
        <input type="text" name="name" value= <?php echo $name ?>>
        <input type="submit" name="submit" value="Submit"> 
    <form>

    <?php
    echo "<br>";

    $Tomtenissar = $pdo->prepare("select * from Tomtenisse where Namn = ?");
    $Tomtenissar->bindParam(1, $name, PDO::PARAM_STR);
    $Tomtenissar->execute();

    if (($Tomtenissar->rowCount()) > 0){
        foreach($Tomtenissar as $row) {
            echo("<pre>");
            print_r($row);
            echo("<pre>");
        }
    }
    else{
        echo "<br>";
        echo("No info found");
    }
        
    ?>
    
</body>
</html>