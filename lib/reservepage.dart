import 'package:flutter/material.dart';

class Reservepage extends StatelessWidget {
  final roomname;
  const Reservepage({super.key, required this.roomname});
  static const occasions = [
    "Cat",
    "Event",
    "Study session",
    "Tutorial",
    "Other",
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController durationcontroller = TextEditingController();
    bool occasion_open = false;
    String selected = "Select the occassion";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(117, 123, 123, 123),
        title: Text("Reserve $roomname"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, setStateocassion) {
                return Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 144, 143, 143)),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selected),
                          IconButton(
                              onPressed: () {
                                setStateocassion(() {
                                  occasion_open = !occasion_open;
                                });
                              },
                              icon: const Icon(Icons.keyboard_arrow_down))
                        ],
                      ),
                      Visibility(
                        visible: occasion_open,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: occasions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  setStateocassion(() {
                                    selected = occasions[index];
                                    occasion_open = !occasion_open;
                                  });
                                },
                                child: Text(
                                    textAlign: TextAlign.left,
                                    occasions[index]),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            DatePickerDialog(
                initialEntryMode: DatePickerEntryMode.input,
                // initialCalendarMode: DatePickerMode.day,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030)),
            TimePickerDialog(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                initialTime: TimeOfDay.now()),
            //const Text("Duration"),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: durationcontroller,
              decoration: InputDecoration(
                  hintText: "Duration ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 174, 174, 174)))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(onPressed: () {}, child: const Text("Reserve"))
          ],
        ),
      ),
    );
  }
}
