import 'package:class_occupation_system/directions.dart';
import 'package:class_occupation_system/main.dart';
import 'package:class_occupation_system/reservepage.dart';
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

ValueNotifier valuechange = ValueNotifier(0);
bool themevalue = false;
TextEditingController searchcontroller = TextEditingController();
List<String> pages = [
  "Offices",
  "Labs",
  "Classrooms",
  "Halls",
  "SOE",
  "Resource Center",
  "School of Business",
  "Admat",
  "Athi house",
  "Depertments",
];
int current_page = 0;
PageController pageController = PageController();

void showWindow(
  BuildContext context,
  String name,
) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 60,
                    child: Text(
                      "Cl",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                Text(name),
                const Text("Resource center second floor"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reservepage(
                                      roomname: "rc18",
                                    )));
                      },
                      child: const Column(
                        children: [Icon(Icons.book), Text("Reserve room")],
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Directions()));
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.location_on_sharp),
                                Text("Directions")
                              ],
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    pageController.addListener(
      () {
        current_page = pageController.page!.ceil();
        valuechange.value++;
      },
    );
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
            // SizedBox(
            //   height: 50,
            //   width: MediaQuery.of(context).size.width,
            //   child: PageView(
            //     scrollDirection: Axis.horizontal,
            //     children: pages,
            //   ),
            // ),
            StatefulBuilder(
              builder: (BuildContext context, setStaterow) {
                return ListenableBuilder(
                    listenable: valuechange,
                    builder: (context, child) {
                      return SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: pages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                current_page = index;
                                pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut);
                                setStaterow(() {});
                              },
                              enableFeedback: false,
                              splashColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  // textAlign: TextAlign.center,
                                  pages[index],
                                  style: current_page == index
                                      ? const TextStyle(
                                          decoration: TextDecoration.underline,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    });
              },
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  //offices
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            showWindow(context, "final");
                          },
                          enableFeedback: false,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(117, 123, 123, 123),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Finance office "),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Office:  Resource center, first floor, left side")
                                  ],
                                ),
                                Text(
                                  "Ocuppied",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  //labs
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(4),
                        child: InkWell(
                          onTap: () {
                            showWindow(context, "final");
                          },
                          enableFeedback: false,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(117, 123, 123, 123),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("mechatronics lab 1 "),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        "lab:  School of engineering, ground floor, left side")
                                  ],
                                ),
                                Text(
                                  "Ocuppied",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  //Classrooms
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            showWindow(context, "final");
                          },
                          enableFeedback: false,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(117, 123, 123, 123),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("RC 18 "),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Class:  Resource center, first floor, left side")
                                  ],
                                ),
                                Text(
                                  "Ocuppied",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  //lecture halls
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            showWindow(context, "final");
                          },
                          enableFeedback: false,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(117, 123, 123, 123),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("satima hall"),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Lecture Hall:  Resource center, first floor, left side")
                                  ],
                                ),
                                Text("vacant",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 13, 0, 255))),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  //Soe rooms
                  ListView.builder(
                    itemCount: 11,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            showWindow(context, "final");
                          },
                          enableFeedback: false,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(117, 123, 123, 123),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("B7"),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Class:  Soe, first floor, left side")
                                  ],
                                ),
                                Text(
                                  "Ocuppied",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
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
