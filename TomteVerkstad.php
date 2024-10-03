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

    /*------------------------------------*\
    |   koden för att tabort tomtenissar   | 
    \*------------------------------------*/

    if (!empty($_GET["Name"]) || !empty($_GET["Id"])) {
        $CreateTomtenissar = $pdo->prepare("delete from Tomtenisse where namn = ? and IdNr = ?");
        $CreateTomtenissar->bindParam(1, $_GET["Name"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(2, $_GET["Id"], PDO::PARAM_STR);
        $CreateTomtenissar->execute();

        if (($CreateTomtenissar->rowCount()) > 0){
            echo "<br>";
            echo("Delete successful");
        }
        else{
            echo "<br>";
            echo("Delete failed");
            echo "<br>";
            echo $CreateTomtenissar->errorCode();
            echo "<br>";
            print_r($CreateTomtenissar->errorInfo());
        }
    } 


    /*-----------------------------*\
    |   koden för drop down menyn   | 
    \*-----------------------------*/
    $Dropdownissar = $pdo->prepare("CALL getNissar");
    //$Dropdownissar = $pdo->prepare("select * from Tomtenisse");
    $Dropdownissar->execute();
    $FetchDropdownissar = $Dropdownissar->fetchAll(PDO::FETCH_ASSOC);
    $Dropdownissar->closeCursor();

    echo "<p> Name of all tomtenissar </p>";

    echo "<select name = 'dropdown'>";
    foreach($FetchDropdownissar as $row) {
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
            echo "<a href='https://wwwlab.webug.se/databaskonstruktion/a23erigu/TomteVerkstad.php?Name=" . $row["Namn"] . "&Id=" . $row["IdNr"] . "'> Delete " . $row["Namn"] . " </a>";
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
        <p> Create tomtenisse </p>
        Name of tomtenisse 
        <input type="text" name="name" value=""> <br>
        ID of tomtenisse 
        <input type="text" name="CId" value=""> <br>
        Amount of nuts earned 
        <input type="number" name="Nuts" value=""> <br>
        Amount of raisin earned 
        <input type="number" name="Raisin" value=""> <br>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php

    echo "<br>";

    if (empty($_POST["name"]) || empty($_POST["CId"]) || empty($_POST["Nuts"]) || empty($_POST["Raisin"])) {
        echo("Can't insert when empty");
    } 
    else {
        
        $CreateTomtenissar = $pdo->prepare("insert into Tomtenisse(Namn, IdNr, Nötter, Russin) values(?, ?, ?, ?)");
        $CreateTomtenissar->bindParam(1, $_POST["name"], PDO::PARAM_STR);
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
        <p> Make chefnisse </p>
        Name of tomtenisse 
        <input type="text" name="name" value=""> <br>
        ID of tomtenisse 
        <input type="text" name="ChefId" value=""> <br>
        Shoe size <br>
        <input type="radio" id="none" name="Shoesize" value="none"> 
        <label for="none">None</label> <br>
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

    echo "<br>";
    
    if (empty($_POST["name"]) || empty($_POST["ChefId"]) || empty($_POST["Shoesize"])) {
        echo("Can't update when empty");
    } 
    else {  

        if ($_POST["Shoesize"] == "none"){
            $EditChef = $pdo->prepare("update Tomtenisse set Skostorlek = NULL where Namn = ? and IdNr = ? ");
            $EditChef->bindParam(1, $_POST["name"], PDO::PARAM_STR);
            $EditChef->bindParam(2, $_POST["ChefId"], PDO::PARAM_STR);
        }
        else{
            $EditChef = $pdo->prepare("update Tomtenisse set Skostorlek = ? where Namn = ? and IdNr = ? ");
            $EditChef->bindParam(1, $_POST["Shoesize"], PDO::PARAM_STR);   
            $EditChef->bindParam(2, $_POST["name"], PDO::PARAM_STR);
            $EditChef->bindParam(3, $_POST["ChefId"], PDO::PARAM_STR);
        }
        
        $EditChef->execute();

        if (($EditChef->rowCount()) > 0){
            echo "<br>";
            echo("Update successful");
        }
        else{
            echo "<br>";
            echo("Update failed");
            echo "<br>";
            echo $EditChef->errorCode();
            echo "<br>";
            print_r($EditChef->errorInfo());
        }
    }
    
    ?>
    
</body>
</html>