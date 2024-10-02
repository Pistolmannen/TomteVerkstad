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
    $pdo = new PDO("mysql:dbname=TomteVerkstad;host=localhost", "dbkonstruktion", "Skata#23"); // koden för att ansluta till databasen som root

    /*-----------------------------*\
    |   koden för drop down menyn   | 
    \*-----------------------------*/
    $Dropdownissar = $pdo->prepare("select * from Tomtenisse");
    $Dropdownissar->execute();
    echo "<p> Name of all tomtenissar </p>";

    echo "<select name = 'dropdown'>";
    foreach($Dropdownissar as $row) {
        echo("<option>" . $row["Namn"] . "</option>");
    }
    echo "</select>";

    echo "<br>";

    /*-------------------------------------*\
    |   koden för att söka på tomtenissar   | 
    \*-------------------------------------*/

    if (empty($_POST["name"])) {
        $name = "Name";
    } 
    else {
        $name = $_POST["name"];
    }

    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <p> Search for Tomtenissar </p>
        <input type="text" name="name" value= <?php echo $name ?>>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php
    echo "<br>";

    $Tomtenissar = $pdo->prepare("select * from Tomtenisse where Namn = ?");
    $Tomtenissar->bindParam(1, $name, PDO::PARAM_STR);
    $Tomtenissar->execute();

    if (($Tomtenissar->rowCount()) > 0){
        foreach($Tomtenissar as $row) {
            echo("<pre>");
            print_r($row);
            echo("</pre>");
        }
    }
    else{
        echo "<br>";
        echo("No info found");
    }

    echo "<br>";
    echo "<br>";

    /*-----------------------------------*\
    |   koden för att skapa tomtenissar   | 
    \*-----------------------------------*/
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        Create tomtenisse <br>
        Name of tomtenisse 
        <input type="text" name="Cname" value=""> <br>
        ID of tomtenisse 
        <input type="text" name="CId" value=""> <br>
        amount of nuts earned 
        <input type="number" name="Nuts" value=""> <br>
        amount of raisin earned 
        <input type="number" name="Raisin" value=""> <br>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php

    echo "<br>";

    if (empty($_POST["Cname"]) || empty($_POST["CId"]) || empty($_POST["Nuts"]) || empty($_POST["Raisin"])) {
        echo("can't insert when empty");
    } 
    else {
        
        $CreateTomtenissar = $pdo->prepare("insert into Tomtenisse(Namn, IdNr, Nötter, Russin) values(?, ?, ?, ?)");
        $CreateTomtenissar->bindParam(1, $_POST["Cname"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(2, $_POST["CId"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(3, $_POST["Nuts"], PDO::PARAM_INT);               // John
        $CreateTomtenissar->bindParam(4, $_POST["Raisin"], PDO::PARAM_INT);             //120617-0921-3-666973821
        $CreateTomtenissar->execute();

        if (($CreateTomtenissar->rowCount()) > 0){
            echo "<br>";
            echo("Insert successful");
        }
        else{
            echo "<br>";
            echo("Insert failed");
            echo "<br>";
            echo $CreateTomtenissar->errorCode();
            echo "<br>";
            print_r($CreateTomtenissar->errorInfo());
        }
    }

    echo "<br>";
    echo "<br>";

    /*----------------------------------------------*\
    |   koden för att göra tomtenissar till chefer   | 
    \*----------------------------------------------*/
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        Make chefnisse <br>
        Name of tomtenisse 
        <input type="text" name="Chefname" value=""> <br>
        ID of tomtenisse 
        <input type="text" name="ChefId" value=""> <br>
        Shoe size <br>
        <input type="radio" id="none" name="Shoesize" value=""> 
        <label for="none">No</label> <br>
        <input type="radio" id="mini" name="Shoesize" value="mini">
        <label for="mini">Mini</label> <br>
        <input type="radio" id="medium" name="Shoesize" value="medium"> 
        <label for="medium">Medium</label> <br>
        <input type="radio" id="maxi" name="Shoesize" value="maxi"> 
        <label for="maxi">Maxi</label> <br>
        <input type="radio" id="ultra" name="Shoesize" value="ultra"> 
        <label for="ultra">Ultra</label> <br>
        <input type="radio" id="mega" name="Shoesize" value="mega">
        <label for="mega">Mega</label> <br>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php
    /*
    if (empty($_POST["Chefname"]) || empty($_POST["ChefId"]) || empty($_POST["Shoesize"])) {
        echo("can't update when empty");
    } 
    else {
        
        $CreateTomtenissar = $pdo->prepare("insert into Tomtenisse(Namn, IdNr, Nötter, Russin) values(?, ?, ?, ?)");
        $CreateTomtenissar->bindParam(1, $_POST["Cname"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(2, $_POST["CId"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(3, $_POST["Nuts"], PDO::PARAM_INT);               // John
        $CreateTomtenissar->bindParam(4, $_POST["Raisin"], PDO::PARAM_INT);             //120617-0921-3-666973821
        $CreateTomtenissar->execute();

        if (($CreateTomtenissar->rowCount()) > 0){
            echo "<br>";
            echo("Insert successful");
        }
        else{
            echo "<br>";
            echo("Insert failed");
            echo "<br>";
            echo $CreateTomtenissar->errorCode();
            echo "<br>";
            print_r($CreateTomtenissar->errorInfo());
        }
    }
    */
    ?>
    
</body>
</html>