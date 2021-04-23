import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobil_taxi/travel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mobil_taxi/type1.dart';

class Type3 extends StatefulWidget {
  @override
  _Type3State createState() => _Type3State();
}

double originLatitude = 40.730610, originLongitude = -73.935242;
double destLatitude, destLongitude;
bool go = false;
var date1Controller = TextEditingController();
var date2Controller = TextEditingController();
var locationController = TextEditingController();
DateTime now = DateTime.utc(2020, 12, 31);
DateTime yuzYilOncesi = DateTime(now.year - 1);
GlobalKey<FormFieldState> textkey = new GlobalKey<FormFieldState>();
String date = "Select date";
GoogleMapController mapController;
Map<MarkerId, Marker> markers = {};
Map<PolylineId, Polyline> polylines = {};
PolylinePoints polylinePoints = PolylinePoints();
String apiKey = "AIzaSyAVuhvM7QNoJshqW4Z-cOe2Zs8R2kA166g";
List<LatLng> polylineCoordinates = [];

class _Type3State extends State<Type3> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade800,
          title: Text(
            "Type 3",
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
                        flex: 6,
                        child: TextField(
                          readOnly: true,
                          key: textkey,
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
                                if (secilenTarih.day < 10) {
                                  date =
                                      "${secilenTarih.year}-${secilenTarih.month}-0${secilenTarih.day}";
                                } else {
                                  date =
                                      "${secilenTarih.year}-${secilenTarih.month}-${secilenTarih.day}";
                                }
                                date1Controller.text = "$date";
                              });
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: date,
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
                          flex: 3,
                          child: IconButton(
                            color: Colors.teal.shade800,
                            iconSize: 50,
                            icon: Icon(Icons.local_taxi),
                            onPressed: () {
                              markers.clear();
                              polylines.clear();
                              polylinePoints = PolylinePoints();
                              polylineCoordinates = [];
                              print(date);
                              dbGetTravels();
                              go = true;
                              setState(() {});
                            },
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: size.height / 3,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(originLatitude, originLongitude),
                      zoom: 10),
                  //myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(markers.values),
                  polylines: Set<Polyline>.of(polylines.values),
                ),
              ),
            ),
          ],
        )));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addPolyLine() {
    //draws the route on the map.
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.deepOrangeAccent,
        width: 4,
        points: polylineCoordinates);
    polylines[id] = polyline;
    if (this.mounted) {
      setState(() {});
    }
  }

  getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(originLatitude, originLongitude),
      PointLatLng(destLatitude, destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(
            double.parse(point.latitude.toStringAsFixed(5)),
            double.parse(point.longitude.toStringAsFixed(5))));
      });
    }
    _addPolyLine();
  }

  dbGetTravels() async {
    await Type1State.dbGetTravels();
    List<Travel> list = []..addAll(Type1.dbList);

    Travel maxTravel;
    double maxDisctance = 0;
    for (int j = 0; j < list.length; j++) {
      if (date == list[j].tpep_pickup_datetime.split(" ")[0] &&
          list[j].trip_distance > maxDisctance) {
        maxTravel = list[j];
        maxDisctance = maxTravel.trip_distance;
      }
    }
    print("max distance: " +
        maxDisctance.toString() +
        " " +
        maxTravel.PULocationID.toString());

    await FirebaseDatabase.instance
        .reference()
        .child('taxizones')
        .child(maxTravel.PULocationID.toString())
        .once()
        .then((result) {
      print(result.value);
      originLatitude = double.parse(result.value['latitude']);
      originLongitude = double.parse(result.value['longitude']);
    });

    await FirebaseDatabase.instance
        .reference()
        .child('taxizones')
        .child(maxTravel.DOLocationID.toString())
        .once()
        .then((result) {
      print(result.value);
      destLatitude = double.parse(result.value['latitude']);
      destLongitude = double.parse(result.value['longitude']);
    });
    _addMarker(LatLng(originLatitude, originLongitude), "origin",
        BitmapDescriptor.defaultMarkerWithHue(16));
    // destination marker
    _addMarker(LatLng(destLatitude, destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(170));
    getPolyline();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    // pin the given location on the map
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      alpha: 0.9,
    );
    markers[markerId] = marker;
  }
}
