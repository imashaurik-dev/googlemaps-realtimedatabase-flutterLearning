import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mapps Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  // late FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool mapready = false;
  var currentLocation;
  GoogleMapController? googleMapControlla;
  List<Marker> markers = <Marker>[];

  // late DatabaseReference _databaseReference;
  // late DatabaseReference _reportLocation;
  // late StreamSubscription<Event> _counterSubScription;
  // late StreamSubscription<Event> _reportSubscription;
  bool anchorToBottom = false;

  void initState() {
    super.initState();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((currentLy) {
      setState(() {
        currentLocation = currentLy;
        mapready = true;
      });
    });
  }

  // this is how we get the realLocation of the device
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  padding: EdgeInsets.all(1.4),
                  height: MediaQuery.of(context).size.height - 80,
                  width: double.infinity,
                  child: mapready
                      ? GoogleMap(
                          markers: {
                            Marker(
                                markerId: MarkerId("myreallocation"),
                                position: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                infoWindow: InfoWindow(
                                    title: "real device location my guy")),
                          },
                          mapType: MapType.hybrid,
                          onMapCreated: onMapCreated,
                          trafficEnabled: true,
                          compassEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                currentLocation.latitude,
                                currentLocation.longitude,
                              ),
                              zoom: 25.0,
                              tilt: 90.0,
                              bearing: 45.0),
                          onCameraMove: futuranimateDrawLines,
                          // onLongPress: uploadLocation,
                        )
                      : Column(
                          children: [
                            Spacer(),
                            Container(
                              color: Colors.purple,
                              child: LinearProgressIndicator(),
                            ),
                            Text("loading the map...")
                          ],
                        ))
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              print(
                  "long: ${currentLocation.longitude} \n latitude: ${currentLocation.latitude}");
            },
            tooltip: 'animate Camera',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
              // onPressed: uploadLocation(currentLocation),
              onPressed: uploadLocation(currentLocation),
              child: Icon(Icons.upload))
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      googleMapControlla = controller;
    });
  }

  void futuranimateDrawLines(currentLocation) {}
  uploadLocation(currentLocation) {
    List<String> location = [
      "${currentLocation.longitude}",
      "${currentLocation.latitude}",
      "referencial-audio-file",
      "username",
      "extraInformation?"
    ];
    print(location[1]);
  }
}
