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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
            children: [
              // background image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover,),
                ),
              ),

              // a better looking back button
              Positioned(
                  top: 10,
                  left: 10,
                  child: FloatingActionButton(
                    backgroundColor: Colors.deepOrange[600],
                    child: const Icon(Icons.chevron_left),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // styled text
                    Container(
                      // margin: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Select your pickup\nand drop location!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.deepOrange[600],
                              fontSize: 30,
                              fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height / 10,),

                    // getting the pickup point from the user
                    // if the user has selected a location -> display the coordinates
                    // if the user has not selected the location -> display a button to select location
                    ValueListenableBuilder<GeoPoint?>(
                      valueListenable: start,
                      builder: (ctx, p, child) {
                        return Center(
                          child: p == null ? Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.deepOrange[400]
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange[400],
                                shadowColor: Colors.deepOrange[400],
                                elevation: 0,
                              ),
                              onPressed: () async {
                                // push the search screen and wait for a `GeoPoint` object
                                var p = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (
                                            _) => const SearchLocation()));

                                // if the user selects a location, extract the coordinates
                                if (p != null) {
                                  coordinatesStart =
                                  "${(p as GeoPoint).latitude}, ${p.longitude}";
                                  start.value = p;
                                }
                              },
                              child: const Text("Select pickup point",
                                style: TextStyle(color: Colors.white),),
                            ),
                          ) :

                          // if p is not null (has the value of coordinates) -> show the coordinates
                          // and a button to pick the location again
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.75,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.deepOrange[400]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(coordinatesStart,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white),),
                                  IconButton(onPressed: () async {
                                    // push the search screen and wait for a `GeoPoint` object
                                    var p = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (
                                                _) => const SearchLocation()));

                                    // if the user selects a location, extract the coordinates
                                    if (p != null) {
                                      coordinatesStart =
                                      "${(p as GeoPoint).latitude}, ${p
                                          .longitude}";
                                      start.value = p;
                                    }
                                  },
                                      icon: const Icon(Icons.restore_outlined,
                                        color: Colors.white,))
                                ],
                              ),
                            ),
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
                          child: p == null ? Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.deepOrange[400]
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange[400],
                                shadowColor: Colors.deepOrange[400],
                                elevation: 0,
                              ),
                              onPressed: () async {
                                // push the search screen and wait for a `GeoPoint` object
                                var p = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (
                                            _) => const SearchLocation()));

                                // if the user selects a location, extract the coordinates
                                if (p != null) {
                                  coordinatesEnd =
                                  "${(p as GeoPoint).latitude}, ${p.longitude}";
                                  end.value = p;
                                }
                              },
                              child: const Text("Select drop point",
                                style: TextStyle(color: Colors.white),),
                            ),
                          ) :

                          // if p is not null (has the value of coordinates) -> show the coordinates
                          // and a button to pick the location again
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.75,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.deepOrange[400]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    coordinatesEnd, textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white),),
                                  IconButton(onPressed: () async {
                                    // push the search screen and wait for a `GeoPoint` object
                                    var p = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (
                                                _) => const SearchLocation()));

                                    // if the user selects a location, extract the coordinates
                                    if (p != null) {
                                      coordinatesEnd =
                                      "${(p as GeoPoint).latitude}, ${p
                                          .longitude}";
                                      end.value = p;
                                    }
                                  },
                                      icon: const Icon(Icons.restore_outlined,
                                        color: Colors.white,))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 8,
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
                              Colors.deepOrange[200]!
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
                      },
                          child: const Text("Find the path!",
                            style: TextStyle(color: Colors.white),)),
                    )
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}
