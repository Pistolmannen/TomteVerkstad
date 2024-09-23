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

    foreach( $pdo->query("select * from Tomtenisse") as $row) {
        echo("<pre>");
        print_r($row);
        echo("<pre>");
    }

    ?>
</body>
</html>