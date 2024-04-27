import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:mysql1/mysql1.dart';

import 'calendar_page.dart';
import 'bien_page.dart';

const d_blue = Color.fromARGB(255, 145, 184, 242);
const d_green = Color(0xFF54D3C2);

var hotelListBDglobal;
var bienIdglobal;

Future<void> main(List<String> arguments) async {
//Future main() async {
  /*
  print("Connexion au serveur MySQL...");

  // create connection
  final conn = await MySqlConnection.connect(
    ConnectionSettings(
      host: "127.0.0.1",
      port: 3306,
      user: "root",
      password: "Flutter04*",
      db: "locations_biens_saisonniers", // optional
    ),
  );

  print("Connecté");

  var i = 0;
  var userId = 1;
  var results = await conn.query('select nom_bien, rue_bien from biens where id_bien=?', [userId]);
  for (var row in results) {
      print('Nom: ${row[0]}, Rue: ${row[1]}');
      i = i+1;
  };
  await conn.close();
  */
  Future<List> listehotelListBD = getbiens();

  final List hotelListBDmain = await  listehotelListBD;
  print(hotelListBDmain);
  hotelListBDglobal = hotelListBDmain;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOUNDEF Computing',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchSection(),
            HotelSection(),
          ],
        ),
      ),
    );
  }
}


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.grey[800],
          size: 20,
        ),
        onPressed: null,
      ),
      centerTitle: true,
      title: Text(
        'Explorer',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite_outline_rounded,
            color: Colors.grey[800],
            size: 20,
          ),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(
            Icons.place,
            color: Colors.grey[800],
            size: 20,
          ),
          onPressed: null,
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}
  
/*class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(),
    );
  }
}*/



class SearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Londres',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CalendarPage();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 26,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: CircleBorder(),
                    shadowColor: Colors.white,
                    //primary: d_green,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choisir la date',
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '12 Déc - 22 Déc',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre de chambres',
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1 Chambre - 2 Adulte',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<List> getbiens() async {
  //final res = await http.get("http://localhost:62607//Users/lisad/Dev/application_biens/lib/get_biens.php");

  //const String apiEndpoint2 =
          'http://127.0.0.1/Users/lisad/Dev/application_biens/lib/get_biens.php'; 
  
 // 192.168.56.1 est l'adresse ipv4 récupéré en faisant ipconfig sour cmd

  const String apiEndpoint = 'http://192.168.56.1/location_saisonniere_git/Location-de-biens-saisonniers-lisa/Location-de-biens-saisonniers/front/getBienFlutter.php'; 
  final Uri url = Uri.parse(apiEndpoint);
  final res = await http.post(url);
  return json.decode(res.body);
}

Future<List> getUnseulbien(int id) async {
 // 192.168.56.1 est l'adresse ipv4 récupéré en faisant ipconfig sour cmd

  const String apiEndpoint = 'http://192.168.56.1/location_saisonniere_git/Location-de-biens-saisonniers-lisa/Location-de-biens-saisonniers/front/getBienFlutter.php?id=2'; 
  final Uri url = Uri.parse(apiEndpoint);
  final res = await http.post(url);
  return json.decode(res.body);
}

class HotelSection extends StatelessWidget {

//final List hotelListBD = [{"title":"Maison Santa","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Maison Le Vieux Port ","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Appartement Chouki","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Maison ","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Appart H\u00f4tel Bellevue\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Appartements lumineux, quartier Bonnefoy\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Maison Hyper Centre Brive","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Appartement centre-ville avec terrasse\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"2 Paris apartment Eiffel - your home in Paris view & large terrace\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Le Petit Pavillon de Versailles\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"La Casa Boh\u00e8me - Superbe maison avec parking priv\u00e9\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Coup de C\u0153ur assur\u00e9 pour ce T2 r\u00e9nov\u00e9 Hyper centre\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Villa Le Mauret\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"G\u00eete Jullianges, 3 pi\u00e8ces, 5 personnes - FR-1-582-214\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"VILLA GABY - Rare 6 Personnes - Localisation Id\u00e9ale\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"La Maison aux murs anciens et ses chambres\r\n","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Maison des roses","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"yohan","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"Test","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"},{"title":"fgh","place":"Bayonne","distance":2,"review":36,"picture":"images\/hotel_1.png","price":"180"}];
//Future<List> listehotelListBD = getbiens();

//List hotelListBD = await  listehotelListBD;
final List hotelListBD = hotelListBDglobal;
@override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4 biens trouvés',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Filtres',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list_outlined,
                        color: d_green,
                        size: 25,
                      ),
                      onPressed: null,
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: hotelListBD.map((hotel) {
              return HotelCard(hotel);
            }).toList(),
          ),
        ],
      ),
    );
  }
}




// classe qui fonctionne avec liste de bien en dur
class HotelSection2 extends StatelessWidget {
  final List hotelList = [
    {
      'title': 'Maison Santa',
      'place': 'wembley, Londres',
      'distance': 2,
      'review': 36,
      'picture': 'images/hotel_1.png',
      'price': '180',
      'price2': '200',
    },
    {
      'title': 'Appartement Blue',
      'place': 'wembley, Londres',
      'distance': 3,
      'review': 13,
      'picture': 'images/hotel_2.png',
      'price': '220',
      'price2': '200',
    },
    {
      'title': 'Maison Cooly',
      'place': 'wembley, Londres',
      'distance': 6,
      'review': 88,
      'picture': 'images/hotel_3.png',
      'price': '400',
      'price2': '200',
    },
    {
      'title': 'Appartement Berat',
      'place': 'wembley, Londres',
      'distance': 11,
      'review': 34,
      'picture': 'images/hotel_4.png',
      'price': '910',
      'price2': '200',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4 biens trouvés',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Filtres',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list_outlined,
                        color: d_green,
                        size: 25,
                      ),
                      onPressed: null,
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: hotelList.map((hotel) {
              return HotelCard(hotel);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

final List hotelList = [
    {
      'title': 'Maison Santa',
      'place': 'wembley, Londres',
      'distance': 2,
      'review': 80,
      'picture': 'images/hotel1.jpg',
      'price': '180',
      'price2': '200',
    },
    {
      'title': 'Appartement Blue',
      'place': 'wembley, Londres',
      'distance': 2,
      'review': 80,
      'picture': 'images/hotel2.jpg',
      'price': '220',
      'price2': '200',
    },
    {
      'title': 'Maison Cooly',
      'place': 'wembley, Londres',
      'distance': 6,
      'review': 88,
      'picture': 'images/hotel_3.png',
      'price': '400',
      'price2': '200',
    },
    {
      'title': 'Appartement Berat',
      'place': 'wembley, Londres',
      'distance': 11,
      'review': 34,
      'picture': 'images/hotel_4.png',
      'price': '910',
      'price2': '200',
    },
  ];

  class HotelCard extends StatelessWidget {
  final Map hotelData;
  HotelCard(this.hotelData);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              image: DecorationImage(
                image: AssetImage(
                  hotelData['picture'],
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: -15,
                  child: MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    onPressed: () {},
                    child: Icon(
                      Icons.favorite_outline_rounded,
                      color: d_green,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 85,
                  right: -15,
                  child: MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // affiche bien
                          //var monBienPage = BienPage(hotelData['id_bien']);
                          bienIdglobal=hotelData['id_bien'];

                          /*Future<List> listehotelListBD2 = getUnSeulbien(bienIdglobal);
                          final List hotelListBDmain2 = await  listehotelListBD2;
                          hotelListBDglobal = hotelListBDmain2;*/
                          return BienPage();
                        },
                      ),
                    );
                  },
                    child: Icon(
                      Icons.keyboard_double_arrow_right,
                      color: d_green,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotelData['title'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '\€' + hotelData['price'] + '-' + hotelData['price2'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotelData['place'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: d_green,
                      size: 14.0,
                    ),
                    Text(
                      hotelData['distance'].toString() + ' km de la ville',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  'par nuit',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 3, 10, 0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rate,
                      color: d_green,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: d_green,
                      size: 14.0,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  hotelData['review'].toString() + ' commentaires',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: d_green,
          ),
          label: 'Explorer',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_outline_rounded,
            color: d_green,
          ),
          label: 'Conseils',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: d_green,
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
