<?php

require_once('../class/reservation_class.php');
//Connexion à la base de donnée
//$code = new PDO("mysql:host=127.0.0.1;dbname=locations_biens_saisonniers",'root','');

//Connexion à la base de donnée
    try {
        $code = new PDO("mysql:host=127.0.0.1;dbname=locations_biens_saisonniers",'root','Flutter04*');
    }
    catch( PDOException $e ) {
        echo "Erreur SQL :", $e->getMessage();
    }
    //echo "connection";
    
    $sql = "SELECT * FROM biens";
    $sql = "SELECT * FROM `biens` V, `communes` C WHERE V.Idcom = C.Idcom";
    //$sql = "SELECT * FROM `biens` B, `communes` C , `tarif` T WHERE B.Idcom = C.Idcom AND B.id_bien = T.id_bien";
    $stmt1=$code->Query($sql);
    
    while($row = $stmt1->fetch(PDO::FETCH_ASSOC)):
        //echo $row['id_bien'];
        
    endwhile;
    
    // exemple bien
    //'title': 'Maison Santa',
    //  'place': 'wembley, Londres',
    //  'distance': 2,
    //  'review': 36,
    //  'picture': 'images/hotel_1.png',
    //  'price': '180',
    
    $tableau_bien=[];
        $i=0;
        $stmt=$code->Query($sql);
        foreach ($stmt as $unstmt ) {
            
            // recherche nombre de commentaire
            $sql2 = "SELECT COUNT(commentaire) AS nb_commentaire FROM reservation WHERE id_bien =".$unstmt['id_bien'];
            $stmt2=$code->Query($sql2);
            $row2=$stmt2->fetch(PDO::FETCH_ASSOC);
            $tableau_bien[$i]['review']=$row2['nb_commentaire'];
            
            // recherche des 2 tarifs
            $sql3 = "SELECT prix_loc FROM tarif WHERE id_bien =".$unstmt['id_bien'];
            $stmt3=$code->Query($sql3);
            $row3=$stmt3->fetch(PDO::FETCH_ASSOC);
            $tableau_bien[$i]['price']=strval($row3['prix_loc']);
            $row3=$stmt3->fetch(PDO::FETCH_ASSOC);
            $tableau_bien[$i]['price2']=strval($row3['prix_loc']);
            
            $tableau_bien[$i]['title']=$unstmt['nom_bien'];
            $tableau_bien[$i]['place']=$unstmt['nom_commune_postal'];
            $tableau_bien[$i]['distance']=2;
            $tableau_bien[$i]['picture']='images/hotel_1.png';
            // recherche de la premiere photo
            $sql4 = "SELECT * FROM photos WHERE id_bien =".$unstmt['id_bien'];
            $stmt4=$code->Query($sql4);
            if ($stmt4->rowCount()==0) {
                $tableau_bien[$i]['picture']='images/hotel_1.png';
            }
            else
            {
                $row4=$stmt4->fetch(PDO::FETCH_ASSOC);
                $tableau_bien[$i]['picture']='C:\XAMPP\htdocs\location_saisonniere_git\Location-de-biens-saisonniers-lisa\Location-de-biens-saisonniers\photo\\'.$row4['lien_photo'];
                $tableau_bien[$i]['picture']='images//'.$row4['lien_photo'];

            }
            $tableau_bien[$i]['id_bien']=$unstmt['id_bien'];
            
            $i=$i+1;  
        }
        echo json_encode($tableau_bien);
    
?>