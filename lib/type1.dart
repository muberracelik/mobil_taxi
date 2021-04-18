import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobil_taxi/travel.dart';

List<Travel> list1 = List();

class Type1 extends StatefulWidget {
  @override
  _Type1State createState() => _Type1State();
}

class _Type1State extends State<Type1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade800,
          title: Text(
            "Type 1",
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade600,
        body: Container(
            child: FutureBuilder<List<String>>(
                future: dbGetTravels(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.green.withOpacity(0.4),
                      child: ListView.builder(
                        itemBuilder: (context, index) => Card(
                          borderOnForeground: true,
                          elevation: 20,
                          child: ListTile(
                            title: Text(
                              snapshot.data[index],
                            ),
                            onTap: () {},
                          ),
                        ),
                        itemCount: 5,
                      ),
                    );
                  } else {
                    return Container(
                        child: Center(
                      child:
                          CircularProgressIndicator(), // if the process takes longer create loading icon.
                    ));
                  }
                })));
  }

  Future<List<String>> dbGetTravels() async {
    List<Travel> list = [];
    List<String> sortedDays = [];
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
          double.parse(result.value[i + 1]['congestion_surcharge'].toString()),
          double.parse(result.value[i + 1]['improvement_surcharge'].toString()),
          double.parse(result.value[i + 1]['total_amount'].toString()),
        ));
      }
    });
    Travel temp;
    for (int j = 0; j < list.length; j++) {
      for (int i = j + 1; i < list.length; i++) {
        if (list[i].passenger_count > list[j].passenger_count) {
          temp = list[i];
          list[j] = list[i];
          list[i] = temp;
        }
      }
    }
    Map<String, int> wordCounts = new Map<String, int>();
    for (int j = 0; j < list.length; j++) {
      if (wordCounts.containsKey(list[j].tpep_pickup_datetime.split(" ")[0])) {
        wordCounts[list[j].tpep_pickup_datetime.split(" ")[0]] +=
            list[j].passenger_count;
      } else {
        wordCounts[list[j].tpep_pickup_datetime.split(" ")[0]] = 0;
      }
    }
    var sortedKeys = wordCounts.keys.toList(growable: true)
      ..sort((k2, k1) => wordCounts[k1].compareTo(wordCounts[k2]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => wordCounts[k]);
    for (int j = 0; j < sortedMap.length; j++) {
      sortedDays.add(sortedMap.keys.elementAt(j).toString() +
          " Total number of passengers: " +
          sortedMap.values.elementAt(j).toString());
    }
    return sortedDays;
  }
}
