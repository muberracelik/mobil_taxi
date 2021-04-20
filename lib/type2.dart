import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobil_taxi/travel.dart';

String date1 = "Select date 1";
String date2 = "Select date 2";
String location = "Select Location";
bool go = false;

class Type2 extends StatefulWidget {
  @override
  _Type2State createState() => _Type2State();
}

class _Type2State extends State<Type2> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var date1Controller = TextEditingController();
    var date2Controller = TextEditingController();
    var locationController = TextEditingController();
    DateTime now = DateTime.utc(2020, 12, 31);
    DateTime yuzYilOncesi = DateTime(now.year - 1);
    GlobalKey<FormFieldState> textkey1 = new GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> textkey2 = new GlobalKey<FormFieldState>();
    GlobalKey<FormFieldState> locationkey = new GlobalKey<FormFieldState>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade800,
          title: Text(
            "Type 2",
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade600,
        body: Container(
            child: Column(
          children: [
            Container(
              height: size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          key: textkey1,
                          controller: date1Controller,
                          onTap: () {
                            showDatePicker(
                                    cancelText: "CANCEL",
                                    confirmText: "OK",
                                    helpText: "Select Date 1",
                                    context: context,
                                    initialDate: now,
                                    firstDate: yuzYilOncesi,
                                    lastDate: now)
                                .then((secilenTarih) {
                              setState(() {
                                date1 =
                                    "${secilenTarih.year}-${secilenTarih.month}-${secilenTarih.day}";
                                date1Controller.text = "$date1";
                              });
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: date1,
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: locationController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: location,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            location = text;
                          },
                          onEditingComplete: () {
                            go = false;
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          key: textkey2,
                          controller: date2Controller,
                          onTap: () {
                            showDatePicker(
                                    cancelText: "CANCEL",
                                    confirmText: "OK",
                                    helpText: "Select Date 2",
                                    context: context,
                                    initialDate: now,
                                    firstDate: yuzYilOncesi,
                                    lastDate: now)
                                .then((secilenTarih) {
                              setState(() {
                                date2 =
                                    "${secilenTarih.year}-${secilenTarih.month}-${secilenTarih.day}";
                                date2Controller.text = "$date2";
                              });
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: date2,
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                      child: IconButton(
                    color: Colors.teal.shade800,
                    iconSize: 50,
                    icon: Icon(Icons.local_taxi),
                    onPressed: () {
                      go = true;
                      setState(() {});
                    },
                  ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: size.height * 0.6,
                child: FutureBuilder<String>(
                    future:
                        go == true ? dbGetTravels(true) : dbGetTravels(false),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == "") {
                          return Container();
                        } else {
                          return Container(
                              child: Text(
                            snapshot.data,
                            style:
                                TextStyle(fontSize: 40, color: Colors.white60),
                          ));
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ],
        )));
  }

  Future<String> dbGetTravels(bool isGo) async {
    List<Travel> list = [];
    List<Travel> selectedTravels = [];
    int carCount = 0;
    if (isGo == true) {
      print("gooo");

      await FirebaseDatabase.instance
          .reference()
          .child('travels')
          .once()
          .then((result) {
        for (int i = 0; i < result.value.length - 1; i++) {
          list.add(Travel.db(
            int.parse(result.value[i + 1]['VendorID'].toString()),
            result.value[i + 1]['tpep_pickup_datetime'].toString(),
            result.value[i + 1]['tpep_dropoff_datetime'].toString(),
            int.parse(result.value[i + 1]['passenger_count'].toString()),
            double.parse(result.value[i + 1]['trip_distance'].toString()),
            int.parse(result.value[i + 1]['RatecodeID'].toString()),
            result.value[i + 1]['store_and_fwd_flag'].toString(),
            int.parse(result.value[i + 1]['PULocationID'].toString()),
            int.parse(result.value[i + 1]['DOLocationID'].toString()),
            int.parse(result.value[i + 1]['payment_type'].toString()),
            double.parse(result.value[i + 1]['mta_tax'].toString()),
            double.parse(result.value[i + 1]['fare_amount'].toString()),
            double.parse(result.value[i + 1]['tip_amount'].toString()),
            double.parse(result.value[i + 1]['tolls_amount'].toString()),
            double.parse(result.value[i + 1]['extra'].toString()),
            double.parse(
                result.value[i + 1]['congestion_surcharge'].toString()),
            double.parse(
                result.value[i + 1]['improvement_surcharge'].toString()),
            double.parse(result.value[i + 1]['total_amount'].toString()),
          ));
        }
      });
      for (int j = 0; j < list.length; j++) {
        int date = int.parse(list[j]
            .tpep_pickup_datetime
            .toString()
            .split(" ")[0]
            .split("-")[2]);
        int startDate = int.parse(date1.split("-")[2]);
        int endDate = int.parse(date2.split("-")[2]);
        if (date <= endDate &&
            date >= startDate &&
            location == list[j].PULocationID.toString()) {
          selectedTravels.add(list[j]);
          print(list[j].toString());
        }
      }
      carCount = selectedTravels.length;
      print(carCount);
      return carCount.toString();
    } else {
      return carCount.toString();
    }
  }
}
