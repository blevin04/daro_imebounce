import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

late LocationData _locationData;
Future getlocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return location;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    getlocation();
    Location.instance.onLocationChanged.listen((LocationData currentlocation) {
      _locationData = currentlocation;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getlocation();
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getlocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Location.instance.onLocationChanged,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Location.instance.changeSettings(
                  accuracy: LocationAccuracy.high, interval: 100);
              String latitude = snapshot.data.latitude.toString();
              String longitude = snapshot.data.longitude.toString();
              String altitude = snapshot.data.altitude.toString();
              return Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "latitude",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          latitude,
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "longitude",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          longitude,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text("altitude"), Text(altitude)],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
