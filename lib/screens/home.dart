// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'select_locations.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // MapController for flutter_osm plugin
  late MapController controller;

  // store if the user is tracking their location
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);

  // check if a path exists if the user wants to clear one
  ValueNotifier<bool> clear = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    // initialise the map with user's position
    controller = MapController(
      initMapWithUserPosition: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // a wrapper method for `MapController.drawRoad`
  // takes in 2 locations from a user and visualises the path from
  // the pickup point to the drop point
  void drawRoad() async {
    // push the `SelectionLocation` screen and wait for the coordinates of
    // 2 points which will be used to construct a path
    var coordinates = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SelectLocation()));

    if (coordinates == null) return;

    // the returned value is a list of strings of the form
    // ["latitude1, longitude1", "latitude2, longitude2"]
    // hence, process the variable to obtain the pickup point
    List point1 = [
      double.parse(coordinates[0].split(",")[0].trim()),
      double.parse(coordinates[0].split(",")[1].trim())
    ];
    // process the variable to obtain the drop point
    List point2 = [
      double.parse(coordinates[1].split(",")[0].trim()),
      double.parse(coordinates[1].split(",")[1].trim())
    ];

    // draw a road between the pickup and drop point for a car
    RoadInfo roadInfo = await controller.drawRoad(
      GeoPoint(
        latitude: point1[0],
        longitude: point1[1],
      ),
      GeoPoint(
        latitude: point2[0],
        longitude: point2[1],
      ),
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        showMarkerOfPOI: true,  // marks the pickup and drop point
        zoomInto: true,  // zooms into the road
      ),
    );

    // set the value of clear to true as we have a path on the map now
    clear.value = true;
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
  }

  // show or hide the current location of a user
  void showLocation() async {
    // if the user has not already requested to show their location
    if (!trackingNotifier.value) {

      // obtain the coordinated of user
      GeoPoint coordinates = await controller.myLocation();

      // move the map to user's current location and start tracking
      await controller.currentLocation();
      await controller.enableTracking();

      // display the coordinated using a toast
      Fluttertoast.showToast(
          msg: '${coordinates.latitude}, ${coordinates.longitude}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0
      );
    }
    // if the location is already being tracked
    else {
      // disable location tracking
      await controller.disabledTracking();
    }

    // update the value of notifier for next iteration
    trackingNotifier.value = !trackingNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange[600],
          title: const Text("Human Vehicle Interaction"),
          actions: [
            // select 2 points and visualise the path between them on map
            IconButton(onPressed: drawRoad, icon: const Icon(Icons.directions))
          ],
        ),
        body: Stack(
          children: [
            OSMFlutter(
              controller: controller,
              androidHotReloadSupport: true,
              mapIsLoading: const Center(
                child: CircularProgressIndicator(),
              ),
              initZoom: 15,  // default zoom of the map when it is loaded
              minZoomLevel: 2,  // minimum zoom level a user can use
              maxZoomLevel: 19,  // maximum zoom level a user can use
              stepZoom: 1.0,

              // marker used for user's current location
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 100,
                  ),
                ),

                // to display the direction of the motion of user
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 100,
                  ),
                ),
              ),

              // acknowledging open source contributions
              showContributorBadgeForOSM: true,

              // configurations for drawing a path/road
              roadConfiguration: RoadConfiguration(
                startIcon: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
                endIcon: const MarkerIcon(
                  icon: Icon(
                    Icons.beenhere_rounded,
                    size: 100,
                    color: Colors.red,
                  ),
                ),
                roadColor: Colors.red,
              ),
            ),
            Positioned(
              top:10,
              right: 10,

                // listens to clear,
                // shows a button to remove the highlighted path
                // if the value of clear is true (if a path is present
                // on the map)
              child: ValueListenableBuilder<bool>(
                valueListenable: clear,
                builder: (ctx, p, builderChild) {
                  // if there is a path, show a button to remove the same
                  if (p) {
                  return FloatingActionButton(
                    backgroundColor: Colors.deepOrange[600],
                      onPressed: () async {

                      // remove the road/path present on map
                      await controller.removeLastRoad();

                      // set the value of clear as false (no path
                      // is present on the map now)
                      clear.value = false;
                  },
                      child: const Icon(Icons.clear_rounded));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                children: [

                  // 2 buttons for zooming in and zooming out
                  // to make the process more accessible on emulator
                  ElevatedButton(
                    child: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange[600]
                    ),
                    onPressed: () async {
                      controller.zoomIn();
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.remove),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange[600]
                    ),
                    onPressed: () async {
                      controller.zoomOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        // centre the map to user's current coordinates
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange[600],
            onPressed: showLocation,
            child: const Icon(Icons.my_location)
        ),
      ),
    );
  }
}