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
            
            
            
            $tableau_bien[$i]['title']=$unstmt['nom_bien'];
            $tableau_bien[$i]['place']='Bayonne';
            $tableau_bien[$i]['distance']=2;
            $tableau_bien[$i]['review']=36;
            $tableau_bien[$i]['picture']='images/hotel_1.png';
            $tableau_bien[$i]['price']='180';
            
            $i=$i+1;  
        }
        echo json_encode($tableau_bien);
    
?>