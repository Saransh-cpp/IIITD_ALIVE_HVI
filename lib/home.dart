// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iiitd_alive/select_locations.dart';


class MainExample extends StatefulWidget {
  const MainExample({Key? key}) : super(key: key);

  @override
  _MainExampleState createState() => _MainExampleState();
}

class _MainExampleState extends State<MainExample> {
  late MapController controller;
  late GlobalKey<ScaffoldState> scaffoldKey;
  Key mapGlobalkey = UniqueKey();
  Timer? timer;
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: true,
    );
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("IIITD"),
        actions: [
          IconButton(onPressed: () async {
            var coordinates = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SelectLocation()));
            print(coordinates);
            List point1 = [
              double.parse(coordinates[0].split(",")[0].trim()),
              double.parse(coordinates[0].split(",")[1].trim())
            ];
            List point2 = [
              double.parse(coordinates[1].split(",")[0].trim()),
              double.parse(coordinates[1].split(",")[1].trim())
            ];
            print(coordinates[0]);
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
                showMarkerOfPOI: true,
                zoomInto: true,
              ),
            );
            print("${roadInfo.distance}km");
            print("${roadInfo.duration}sec");
          }, icon: const Icon(Icons.directions))
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
            initZoom: 15,
            minZoomLevel: 2,
            maxZoomLevel: 19,
            stepZoom: 1.0,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 100,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 100,
                ),
              ),
            ),
            showContributorBadgeForOSM: true,
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
            bottom: 10,
            left: 10,
            child: Column(
              children: [
                ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    controller.zoomIn();
                  },
                ),
                ElevatedButton(
                  child: const Icon(Icons.remove),
                  onPressed: () async {
                    controller.zoomOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!trackingNotifier.value) {
              GeoPoint coordinates = await controller.myLocation();
              await controller.currentLocation();
              await controller.enableTracking();
              Fluttertoast.showToast(
                  msg: '${coordinates.latitude}, ${coordinates.longitude}',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  fontSize: 16.0
              );
            } else {
              await controller.disabledTracking();
            }
            trackingNotifier.value = !trackingNotifier.value;
          },
          child: const Icon(Icons.my_location)
      ),
    );
  }
}