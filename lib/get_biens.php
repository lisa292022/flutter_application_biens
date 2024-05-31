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
    
    // sélection d'un bien ou de tous les biens
    $sql = "SELECT * FROM `biens` V, `communes` C WHERE V.Idcom = C.Idcom";
    if(isset($_POST['id'])){
        $id_bien = $_POST['id'];
        $sql = "SELECT * FROM `biens` V, `communes` C WHERE V.Idcom = C.Idcom and V.id_bien=".$id_bien;
    }
    if(isset($_GET['id'])){
        $id_bien = $_GET['id'];
        $sql = "SELECT * FROM `biens` V, `communes` C WHERE V.Idcom = C.Idcom and V.id_bien=".$id_bien;
    }
    
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
            $sql2 = "SELECT COUNT(commentaire) AS nb_commentaire FROM reservation WHERE commentaire != '' and id_bien =".$unstmt['id_bien'];
            $stmt2=$code->Query($sql2);
            $row2=$stmt2->fetch(PDO::FETCH_ASSOC);
            $tableau_bien[$i]['review']=$row2['nb_commentaire'];
            // recheche des commentaires
            $sql21 = "SELECT * FROM reservation WHERE id_bien =".$unstmt['id_bien'];
            $stmt21=$code->Query($sql21);
            if($stmt21->rowCount() != 0) {
                $tableau_bien[$i]['commentaire']="";
                while($row21 = $stmt21->fetch(PDO::FETCH_ASSOC)):
                    $tableau_bien[$i]['commentaire']= $tableau_bien[$i]['commentaire']." ".$row21['commentaire'];
                endwhile; 
            }
            else
            {
               $tableau_bien[$i]['commentaire']=""; 
            }
            
            
            // recheche d'activités
            $sql51 = "SELECT description FROM activite INNER JOIN possede ON activite.id_activite = possede.id_activite  WHERE possede.id_bien =".$unstmt['id_bien'];
            //$sql51 = "SELECT * FROM possede WHERE id_bien =".$unstmt['id_bien'];
            $stmt51=$code->Query($sql51);
            if($stmt51->rowCount() != 0) {
                $tableau_bien[$i]['activite']="";
                while($row51 = $stmt51->fetch(PDO::FETCH_ASSOC)):
                    $tableau_bien[$i]['activite']= $tableau_bien[$i]['activite']." ".$row51['description'];
                endwhile; 
            }
            else
            {
               $tableau_bien[$i]['activite']=""; 
            }
            
            
            
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
                $tableau_bien[$i]['picture']='images/'.$row4['lien_photo'];

            }
            $tableau_bien[$i]['id_bien']=$unstmt['id_bien'];
            
            $tableau_bien[$i]['lit']=strval($unstmt['nb_couchage']);
            $tableau_bien[$i]['piece']=strval($unstmt['nb_piece']);
            $tableau_bien[$i]['chambre']=strval($unstmt['nb_chambre']);
            $tableau_bien[$i]['superficie']=strval($unstmt['superficie_bien']);
            $tableau_bien[$i]['descriptif']=$unstmt['descriptif'];
            $tableau_bien[$i]['rue']=$unstmt['rue_bien'];
            
            $i=$i+1;  
        }
        echo json_encode($tableau_bien);
    
?>