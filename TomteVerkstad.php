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

    $namn = "David";

    if (empty($_POST["name"])) {
        $name = "David";
    } 
    else {
        $name = test_input($_POST["name"]);
        echo($name);
    }

    ?>

    <input type="text" name="name" value="name">
    <input type="submit" name="submit" value="Submit"> 

    <?php
    echo "<br>";

    $Tomtenissar = $pdo->prepare("select * from Tomtenisse where Namn = David");
    //$Tomtenissar = $pdo->query("select * from Tomtenisse");
    $data = $Tomtenissar->fetchAll();


    if ($data->countRow() > 0){
        foreach($Tomtenissar as $row) {
            echo("<pre>");
            print_r($row);
            echo("<pre>");
        }
    }
    else{
        echo("no info found");
    }
        
    ?>
    
</body>
</html>