<?php
    session_start()
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>This is Tomtens Verkstad</title>
</head>
<body>
    <form action = "Inlogg.php" method = "POST">
        <input type="submit" name="submit" value="Login"> 
    </form>

    <?php
    /*----------------------------------------*\
    |   koden för att ansluta till databasen   | 
    \*----------------------------------------*/
    if (empty($_SESSION["Username"])) {
        $Username = "";
    } 
    else {
        $Username = $_SESSION["Username"];
    }
    if (empty($_SESSION["Password"])) {
        $Password = "";
    } 
    else {
        $Password = $_SESSION["Password"];
    }
    try{
        $pdo = new PDO("mysql:dbname=TomteVerkstad;host=localhost", $Username, $Password); 
        echo "<p>Loged in as " . $_SESSION['Username'] .  "</p>";
    }
    catch (PDOException $e) {
        exit("Login failed: " . $e->getMessage());
    }

    /*------------------------------------*\
    |   Koden för att tabort tomtenissar   | 
    \*------------------------------------*/

    if (!empty($_GET["Name"]) || !empty($_GET["Id"])) {
        $DeleteTomtenissar = $pdo->prepare("delete from Tomtenisse where namn = ? and IdNr = ?");
        $DeleteTomtenissar->bindParam(1, $_GET["Name"], PDO::PARAM_STR);
        $DeleteTomtenissar->bindParam(2, $_GET["Id"], PDO::PARAM_STR);
        $DeleteTomtenissar->execute();

        if (($DeleteTomtenissar->rowCount()) > 0){
            echo "<br>";
            echo("Delete successful");
        }
        else{
            echo "<br>";
            echo("Delete failed");
            echo "<br>";
            echo $DeleteTomtenissar->errorCode();
            echo "<br>";
            print_r($DeleteTomtenissar->errorInfo());
        }
    } 


    /*-----------------------------*\
    |   Koden för drop down menyn   | 
    \*-----------------------------*/
    $Dropdownissar = $pdo->prepare("CALL getNissar");
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
    |   Koden för att söka på tomtenissar   | 
    \*-------------------------------------*/
    if (empty($_POST["Name"])) {
        $name = "Name";
    } 
    else {
        $name = $_POST["Name"];
    }

    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <p> Search for Tomtenissar </p>
        <input type="text" name="Name" value= <?php echo $name ?>>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php
    echo "<br>";

    if(isset($_POST["Name"])){
        $Tomtenissar = $pdo->prepare("select * from Tomtenisse where Namn = ?");
        $Tomtenissar->bindParam(1, $name, PDO::PARAM_STR);
        $Tomtenissar->execute();
    
        if (($Tomtenissar->rowCount()) > 0){
            echo("<table>");
                echo("<tr>");
                    echo("<th> Name </th>");
                    echo("<th> ID </th>");
                    echo("<th> Nuts </th>");
                    echo("<th> Raisin </th>");
                    echo("<th> Shoe size </th>");
                    echo("<th> Delete </th>");
                echo("</tr>");

            foreach($Tomtenissar as $row) {
                echo("<tr>");
                    echo("<td>");
                        print_r($row[0]);
                    echo("</td>");
                    echo("<td>");
                        print_r($row[1]);
                    echo("</td>");
                    echo("<td>");
                        print_r($row[2]);
                    echo("</td>");
                    echo("<td>");
                        print_r($row[3]);
                    echo("</td>");
                    echo("<td>");
                        print_r($row[4]);
                    echo("</td>");
                    echo("<td>");
                        echo "<a href='https://wwwlab.webug.se/databaskonstruktion/a23erigu/TomteVerkstad.php?Name=" . $row["Namn"] . "&Id=" . $row["IdNr"] . "'> Delete " . $row["Namn"] . " </a>";
                    echo("</td>");
                echo("</tr>");
                
            }
            echo("</table>");
        }
        else{
            echo "<br>";
            echo("No info found");
        }
    }



    echo "<br>";
    echo "<br>";

    /*-----------------------------------*\
    |   Koden för att skapa tomtenissar   | 
    \*-----------------------------------*/
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <p> Create tomtenisse </p>
        Name of tomtenisse 
        <input type="text" name="Name" value=""> <br>
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

    if (isset($_POST["Name"]) && isset($_POST["CId"]) && isset($_POST["Nuts"]) && isset($_POST["Raisin"])) {
        $CreateTomtenissar = $pdo->prepare("insert into Tomtenisse(Namn, IdNr, Nötter, Russin) values(?, ?, ?, ?)");
        $CreateTomtenissar->bindParam(1, $_POST["Name"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(2, $_POST["CId"], PDO::PARAM_STR);
        $CreateTomtenissar->bindParam(3, $_POST["Nuts"], PDO::PARAM_INT);               
        $CreateTomtenissar->bindParam(4, $_POST["Raisin"], PDO::PARAM_INT);             
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
    |   Koden för att göra tomtenissar till chefer   | 
    \*----------------------------------------------*/
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <p> Make chefnisse </p>
        Name of tomtenisse 
        <input type="text" name="Name" value=""> <br>
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
    
    if (isset($_POST["Name"]) && isset($_POST["ChefId"]) && isset($_POST["Shoesize"])) {
        if ($_POST["Shoesize"] == "none"){
            $EditChef = $pdo->prepare("update Tomtenisse set Skostorlek = NULL where Namn = ? and IdNr = ? ");
            $EditChef->bindParam(1, $_POST["Name"], PDO::PARAM_STR);
            $EditChef->bindParam(2, $_POST["ChefId"], PDO::PARAM_STR);
        }
        else{
            $EditChef = $pdo->prepare("update Tomtenisse set Skostorlek = ? where Namn = ? and IdNr = ? ");
            $EditChef->bindParam(1, $_POST["Shoesize"], PDO::PARAM_STR);   
            $EditChef->bindParam(2, $_POST["Name"], PDO::PARAM_STR);
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

    echo "<br>";
    echo "<br>";

    /*-----------------------------------------------*\
    |   Koden för att hita lesaker beroende på pris   | 
    \*-----------------------------------------------*/
    
    ?>

    <form action = "TomteVerkstad.php" method = "POST">
        <p> Get toys by prise </p>
        Price of toy
        <input type="number" name="Prise" value=""> <br>
        <input type="submit" name="submit" value="Submit"> 
    </form>

    <?php

    echo "<br>";
    
    if (isset($_POST["Prise"]) ) {
        $ToyByPrise = $pdo->prepare("Call getLeksakerPåPris(?)");
        $ToyByPrise->bindParam(1, $_POST["Prise"], PDO::PARAM_INT);
        $ToyByPrise->execute();
        $FetchToyByPrise = $ToyByPrise->fetchAll(PDO::FETCH_ASSOC);
        $ToyByPrise->closeCursor();


        if (count($FetchToyByPrise) > 0){

            echo("<table>");
                echo("<tr>");
                    echo("<th> Name </th>");
                    echo("<th> ID </th>");
                    echo("<th> Weight </th>");
                    echo("<th> Prise </th>");
                echo("</tr>");
            foreach($FetchToyByPrise as $row) {

                $ToyName = $pdo->prepare("Call getNamnPåLeksak(?)");
                $ToyName->bindParam(1, $row["IdNr"], PDO::PARAM_STR);
                $ToyName->execute();
                $FetchToyName = $ToyName->fetchAll(PDO::FETCH_ASSOC);
                $ToyName->closeCursor();

                foreach($FetchToyName as $row2){
                    echo("<tr>");
                        echo("<td>");
                            print_r($row2["Namn"]);
                        echo("</td>");
                        echo("<td>");
                            print_r($row2["IdNr"]);
                        echo("</td>");
                        echo("<td>");
                            print_r($row2["Vikt"]);
                        echo("</td>");
                        echo("<td>");
                            print_r($row2["Pris"]);
                        echo("</td>");
                    echo("</tr>");    
                }
                
            }
            echo("</table>");
        }
        else{
            echo "<br>";
            echo("No toys found");
        }
    } 
    
    ?>
    
</body>
</html>