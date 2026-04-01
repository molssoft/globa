<?php
$baseUrl = "https://impro.lv/marsruti_bildes/";
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="Windows-1257">
    <title>Maršruta attēli</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            padding: 20px;
        }

        .image-block {
            border: 1px solid #ccc;
            padding: 15px;
            background: #fafafa;
            box-shadow: 2px 2px 6px rgba(0, 0, 0, 0.1);
        }

        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"] {
            width: 100%;
            padding: 6px;
            box-sizing: border-box;
        }

        .button-container {
            text-align: center;
            margin-top: 30px;
        }

        .save-button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
			text-decoration:none;
        }

        .save-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<h1 align=center>Maršruta bildes</h1>
<? include 'v_menu.php' ?>
<form method="post" action="c_bildes.php?f=save&gid=<?=$gid?>">

    <div class="grid-container">
        <?php foreach ($data as $index => $item): 
            $imgUrl = $baseUrl . $item['path'] . $item['bilde'];
        ?>
            <div class="image-block">
                <img src="<?= htmlspecialchars($imgUrl) ?>" alt="">
                <input type="text" name="alt_texts[<?= $item['mbid'] ?>]" placeholder="Ievadiet atslēgas vārdus vai nosaukumu" value="<?= $item['atsl_vardi'] ?>">
            </div>
        <?php endforeach; ?>
    </div>

    <div class="button-container">
        <button type="submit" class="save-button">Saglabāt</button>
        <a href="grupa_edit2.asp?gid=<?=$_GET['gid']?>" class="save-button">Atgriezties</a>
    </div>

</form>

</body>
</html>
