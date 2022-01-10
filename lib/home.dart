// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iiitd_alive/select_locations.dart';

class CustomController extends MapController {
  CustomController({
    bool initMapWithUserPosition = true,
    GeoPoint? initPosition,
    BoundingBox? areaLimit = const BoundingBox.world(),
  })
      : assert(
  initMapWithUserPosition || initPosition != null,
  ),
        super(
        initMapWithUserPosition: initMapWithUserPosition,
        initPosition: initPosition,
        areaLimit: areaLimit,
      );
}

class MainExample extends StatefulWidget {
  const MainExample({Key? key}) : super(key: key);

  @override
  _MainExampleState createState() => _MainExampleState();
}

class _MainExampleState extends State<MainExample> with OSMMixinObserver {
  late CustomController controller;
  late GlobalKey<ScaffoldState> scaffoldKey;
  Key mapGlobalkey = UniqueKey();
  Timer? timer;
  int x = 0;

  @override
  void initState() {
    super.initState();
    controller = CustomController(
      initMapWithUserPosition: true,
    );
    controller.addObserver(this);
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<void> mapIsInitialized() async {
    await controller.setMarkerOfStaticPoint(
      id: "line 2",
      markerIcon: const MarkerIcon(
        icon: Icon(
          Icons.train,
          color: Colors.orange,
          size: 48,
        ),
      ),
    );

    await controller.setStaticPosition(
      [
        GeoPointWithOrientation(
          latitude: 47.4433594,
          longitude: 8.4680184,
          angle: pi / 4,
        ),
        GeoPointWithOrientation(
          latitude: 47.4517782,
          longitude: 8.4716146,
          angle: pi / 2,
        ),
      ],
      "line 2",
    );
    final bounds = await controller.bounds;
    print(bounds.toString());
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await mapIsInitialized();
    }
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
      key: scaffoldKey,
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
            await controller.addMarker(GeoPoint(latitude: point1[0],
              longitude: point1[1],), markerIcon: const MarkerIcon(
              icon: Icon(Icons.pin),
            ));
            await controller.addMarker(GeoPoint(latitude: point2[0],
              longitude: point2[1],), markerIcon: const MarkerIcon(
              icon: Icon(Icons.pin_drop),
            ));
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
                showMarkerOfPOI: false,
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
                  Icons.person,
                  size: 64,
                  color: Colors.brown,
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
            GeoPoint coordinates = await controller.myLocation();
            Fluttertoast.showToast(
                msg: '${coordinates.latitude}, ${coordinates.longitude}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                fontSize: 16.0
            );
            await controller.currentLocation();
            await controller.enableTracking();
          },
          child: const Icon(Icons.my_location)
      ),
    );
  }
}