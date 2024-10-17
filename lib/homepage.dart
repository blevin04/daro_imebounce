import 'package:class_occupation_system/main.dart';
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

bool themevalue = false;
TextEditingController searchcontroller = TextEditingController();
List<String> pages = [
  "Offices",
  "Labs",
  "Classrooms",
  "SOE",
  "Resorse Center",
  "School of Business",
  "Admat",
  "Athi house",
  "Depertments"
];
int current_page = 0;
PageController pageController = PageController();

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState

    getlocation();
    // Location.instance.onLocationChanged.listen((LocationData currentlocation) {
    //   _locationData = currentlocation;
    //   setState(() {});
    // });
    Location.instance
        .changeSettings(accuracy: LocationAccuracy.high, interval: 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getlocation();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Daro"),
          actions: [
            StatefulBuilder(
              builder: (BuildContext context, setStatetheme) {
                return IconButton(
                    onPressed: () {
                      if (themevalue) {
                        MyApp.of(context)!.changeTheme(ThemeMode.dark);
                      } else {
                        MyApp.of(context)!.changeTheme(ThemeMode.light);
                      }
                      themevalue = !themevalue;
                      setStatetheme(() {});
                    },
                    icon: themevalue
                        ? const Icon(Icons.sunny)
                        : const Icon(Icons.dark_mode));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SearchBar(
              controller: TextEditingController(),
              leading: const Icon(Icons.search),
              hintText: "Search rooms ",
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      pages[index],
                      style: current_page == index
                          ? const TextStyle(
                              decoration: TextDecoration.underline,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            FutureBuilder(
              future: getlocation(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // print(".......................................");
                return StreamBuilder(
                  stream: Location.instance.onLocationChanged,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
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
                              ),
                              Text(
                                latitude,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "longitude",
                              ),
                              Text(
                                longitude,
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
          ],
        ));
  }
}
