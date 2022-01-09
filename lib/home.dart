// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  ValueNotifier<bool> zoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> visibilityZoomNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> advPickerNotifierActivation = ValueNotifier(false);
  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(true);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
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

            // RoadInfo roadInfo = await controller.drawRoad(
            //   GeoPoint(latitude: 47.35387, longitude: 8.43609),
            //   GeoPoint(latitude: 47.4371, longitude: 8.6136),
            //   roadType: RoadType.car,
            //   roadOption: RoadOption(
            //     roadWidth: 10,
            //     roadColor: Colors.blue,
            //     showMarkerOfPOI: false,
            //     zoomInto: true,
            //   ),
            // );
            // print("${roadInfo.distance}km");
            // print("${roadInfo.duration}sec");
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

//   void roadActionBt(BuildContext ctx) async {
//     try {
//       await controller.removeLastRoad();
//
//       ///selection geoPoint
//       GeoPoint point = await controller.selectPosition(
//           icon: const MarkerIcon(
//             icon: Icon(
//               Icons.person_pin_circle,
//               color: Colors.amber,
//               size: 100,
//             ),
//           ));
//       GeoPoint point2 = await controller.selectPosition();
//       showFab.value = false;
//       ValueNotifier<RoadType> notifierRoadType = ValueNotifier(RoadType.car);
//
//       final bottomPersistant = scaffoldKey.currentState!.showBottomSheet(
//             (ctx) {
//           return RoadTypeChoiceWidget(
//             setValueCallback: (roadType) {
//               notifierRoadType.value = roadType;
//             },
//           );
//         },
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//       );
//       await bottomPersistant.closed.then((roadType) async {
//         showFab.value = true;
//         RoadInfo roadInformation = await controller.drawRoad(
//           point, point2,
//           roadType: notifierRoadType.value,
//           //interestPoints: [pointM1, pointM2],
//           roadOption: RoadOption(
//               roadWidth: 10,
//               roadColor: Colors.blue,
//               showMarkerOfPOI: false,
//               zoomInto: true
//           ),
//         );
//         print("duration:${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}");
//         print("distance:${roadInformation.distance}Km");
//         print(roadInformation.route.length);
//         // final box = await BoundingBox.fromGeoPointsAsync([point2, point]);
//         // controller.zoomToBoundingBox(
//         //   box,
//         //   paddinInPixel: 64,
//         // );
//       });
//     } on RoadException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "${e.errorMessage()}",
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Future<void> mapRestored() async {
//     super.mapRestored();
//     print("log map restored");
//   }
// }
//
// class RoadTypeChoiceWidget extends StatelessWidget {
//   final Function(RoadType road) setValueCallback;
//
//   const RoadTypeChoiceWidget({Key? key,
//     required this.setValueCallback,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 96,
//       child: WillPopScope(
//         onWillPop: () async => false,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 64,
//             width: 196,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             alignment: Alignment.center,
//             margin: const EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     setValueCallback(RoadType.car);
//                     Navigator.pop(context, RoadType.car);
//                   },
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.directions_car),
//                       Text("Car"),
//                     ],
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setValueCallback(RoadType.bike);
//                     Navigator.pop(context);
//                   },
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.directions_bike),
//                       Text("Bike"),
//                     ],
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setValueCallback(RoadType.foot);
//                     Navigator.pop(context);
//                   },
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.directions_walk),
//                       Text("Foot"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
}