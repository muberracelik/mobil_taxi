import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(140, 170, 160, 11),
        title: Center(
            child: Text(
          "Mobile-Taxi",
          style: TextStyle(
              fontFamily: "AmaticSC",
              fontSize: size.height / 18,
              fontWeight: FontWeight.w800),
        )),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/type1");
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "En fazla yolcu taşınan 5 gün ve toplam yolcu sayıları",
                    style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: size.height / 20,
                        fontWeight: FontWeight.w800),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.red.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/type2");
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "İki tarih arasında belirli bir lokasyondan hareket eden araç sayısı ",
                    style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: size.height / 20,
                        fontWeight: FontWeight.w800),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/type3");
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  //color: Colors.blue,
                  child: Center(
                      child: Text(
                    "Belirli bir günde yapılan en uzun seyahatin haritası",
                    style: TextStyle(
                        fontFamily: "AmaticSC",
                        fontSize: size.height / 20,
                        fontWeight: FontWeight.w800),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
