import 'package:application_biens/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const d_green3 = Color(0xFF54D3C2);

final List hotelList = [
    {
      'id_bien': 2,
      'title': 'Maison Santa',
      'place': 'wembley, Londres',
      'distance': 2,
      'review': 36,
      'picture': 'images/hotel_1.png',
      'price': '180',
      'price2': '180',
      'lit': 4,
      'piece': 5,
      'descriptif' : 'Doté d’un bain à remous, la maison Santa est situé à Ambronay. L’établissement se trouve à 600 mètres de Notre-Dame et dispose de connexion Wi-Fi gratuite dans les locaux.'
    }
];

class Bien {
  int id_bien;
  String title;
  String place;
  int distance;
  int review;
  String picture;
  int price;
  int price2;
  int lit;
  int piece;
  String descriptif;

  Bien({
  this.id_bien=0,
  this.title="",
  this.place="",
  this.distance=0,
  this.review=0,
  this.picture="",
  this.price=0,
  this.price2=0,
  this.lit=0,
  this.piece=0,
  this.descriptif=""
});
}


Future<List> getUnseulbien(int id) async {
 // 192.168.56.1 est l'adresse ipv4 récupéré en faisant ipconfig sour cmd

  const String apiEndpoint = 'http://192.168.56.1/location_saisonniere_git/Location-de-biens-saisonniers-lisa/Location-de-biens-saisonniers/front/getBienFlutter.php?id=2'; 
  final Uri url = Uri.parse(apiEndpoint);
  final res = await http.post(url);
  return json.decode(res.body);
}

class BienPage extends StatelessWidget {
  //int id_bien;
  //BienPage({this.id_bien}); 
  final List hotelListBD1 = hotelListBDglobal;
  //final Bien monBien= hotelListBDglobal.firstWhere((b) => b['id_bien'] == 2);
  final Map hotelListBD2 = hotelListBDglobal.firstWhere((b) => b['id_bien'] == bienIdglobal);
  //final List hotelListBD3 = getUnSeulbien(bienIdglobal);
  //final List hotelListBD3 = (hotelListBDglobal.firstWhere((b) => b['id_bien'] == bienIdglobal)).toList();
  //final List hotelListBD3 = hotelListBDglobal.firstWhere((b) => b['id_bien'] == bienIdglobal)[0];
  int idbien=bienIdglobal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        // ça marche
        //            children: hotelListBD1.map((hotel) {
        //      return BienCard(hotel);
        //    }).toList(),
        //hotelListBDglobal au lieu de hotelList
                    children: hotelListBD1.map((hotel) {
              return BienCard(hotel);
            }).toList(),
          ),
   );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.grey[800],
          size: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

  class BienCard extends StatelessWidget {
  final Map hotelData;
  BienCard(this.hotelData);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 560,
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
                      color: d_green3,
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
                          return CalendarPage();
                        },
                      ),
                    );
                  },
                    child: Icon(
                      Icons.check_box,
                      color: d_green3,
                      size: 20,
                    ),
                  ),
                ),
               
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotelData['title'] + hotelData['id_bien'].toString() + bienIdglobal.toString(),
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
                      color: d_green3,
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
                      color: d_green3,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green3,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green3,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_rate,
                      color: d_green3,
                      size: 14.0,
                    ),
                    Icon(
                      Icons.star_border,
                      color: d_green3,
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
          SizedBox(width: 20),
          Text(
                  hotelData['lit'].toString() + ' lit(s)',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 20),
          Text(
                  hotelData['piece'].toString() + ' pièce(s)',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 20),
          Text(
                  hotelData['descriptif'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: ElevatedButton(
            child: Text(
              'Réserver',
              style: TextStyle(fontSize: 17),
            ),
            style: ElevatedButton.styleFrom(
              //primary: d_green2,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // affiche bien
                          return CalendarPage();
                        },
                      ),
                    );
                  },
          ),
        ),  
        ],
      ),
    );
  }
}