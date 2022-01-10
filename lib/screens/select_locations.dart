import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'search_location.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  // notifiers and variables to check if the user has selected a location
  // and to store the coordinates respectively
  ValueNotifier<GeoPoint?> start = ValueNotifier(null);
  String coordinatesStart = "";

  ValueNotifier<GeoPoint?> end = ValueNotifier(null);
  String coordinatesEnd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [

            // a better looking back button
            Positioned(child: FloatingActionButton(
              backgroundColor: Colors.deepOrange[600],
              child: const Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),

            // background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Please select your pickup and drop location",
                    style: TextStyle(color: Colors.deepOrange[600]),),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height / 6,),

                  // getting the pickup point from the user
                  // if the user has selected a location -> display the coordinates
                  // if the user has not selected the location -> display a button to select location
                  ValueListenableBuilder<GeoPoint?>(
                    valueListenable: start,
                    builder: (ctx, p, child) {
                      return Center(
                        child: p == null ? ElevatedButton(
                          onPressed: () async {
                            // push the search screen and wait for a `GeoPoint` object
                            var p = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const SearchPage()));

                            // if the user selects a location, extract the coordinates
                            if (p != null) {
                              coordinatesStart =
                              "${(p as GeoPoint).latitude}, ${p.longitude}";
                              start.value = p;
                            }
                          },
                          child: const Text("Select pickup point"),
                        ) :

                        // if p is not null (has the value of coordinates) -> show the coordinates
                        // and a button to pick the location again
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(coordinatesStart),
                            IconButton(onPressed: () async {
                              // push the search screen and wait for a `GeoPoint` object
                              var p = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SearchPage()));

                              // if the user selects a location, extract the coordinates
                              if (p != null) {
                                coordinatesStart =
                                "${(p as GeoPoint).latitude}, ${p.longitude}";
                                start.value = p;
                              }
                            }, icon: const Icon(Icons.restore_outlined))
                          ],
                        ),
                      );
                    },
                  ),

                  // getting the drop point from the user
                  // if the user has selected a location -> display the coordinates
                  // if the user has not selected the location -> display a button to select location
                  ValueListenableBuilder<GeoPoint?>(
                    valueListenable: end,
                    builder: (ctx, p, child) {
                      return Center(

                        // check if p is null, as the value of end
                        // is initialised as null,
                        // if it is null -> display a button to select location
                        child: p == null ? ElevatedButton(
                          onPressed: () async {
                            // push the search screen and wait for a `GeoPoint` object
                            var p = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const SearchPage()));

                            // if the user selects a location, extract the coordinates
                            if (p != null) {
                              coordinatesEnd =
                              "${(p as GeoPoint).latitude}, ${p.longitude}";
                              end.value = p;
                            }
                          },
                          child: const Text("Select drop point"),
                        ) :

                        // if p is not null (has the value of coordinates) -> show the coordinates
                        // and a button to pick the location again
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(coordinatesEnd),
                            IconButton(onPressed: () async {
                              // push the search screen and wait for a `GeoPoint` object
                              var p = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SearchPage()));

                              // if the user selects a location, extract the coordinates
                              if (p != null) {
                                coordinatesEnd =
                                "${(p as GeoPoint).latitude}, ${p.longitude}";
                                end.value = p;
                              }
                            }, icon: const Icon(Icons.restore_outlined))
                          ],
                        ),
                      );
                    },
                  ),

                  // a button to construct the path between 2 selected points
                  // the container is meant for styling
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange[600]!,
                            Colors.deepOrange[400]!
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                    ),

                    // the button
                    child: MaterialButton(onPressed: () {
                      // raise a toast if the locations have not been selected (validation)
                      if (coordinatesEnd == "" || coordinatesStart == "") {
                        Fluttertoast.showToast(
                            msg: 'Please select both the locations',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0
                        );
                      }
                      // if the inputs are present, pass them to previous screen while
                      // popping this screen
                      else {
                        Navigator.of(context).pop(
                            [coordinatesStart, coordinatesEnd]);
                      }
                    }, child: const Text("Find the path!")),
                  )
                ],
              ),
            ),
          ]
      ),
    );
  }
}
