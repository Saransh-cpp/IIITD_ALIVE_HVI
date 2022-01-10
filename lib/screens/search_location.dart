import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  // create a controller to pick up location provided by user
  late PickerMapController controller;

  @override
  void initState() {
    super.initState();

    // initialise the controller with user's current location
    controller = PickerMapController(
      initMapWithUserPosition: true,
    );
  }

  // pick the location selected by user and pass the `GeoPoint` object
  // back to the previous screen
  void pickLocation () async {
    GeoPoint point = await controller.selectAdvancedPositionPicker();
    Navigator.pop(context, point);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPickerLocation(
        controller: controller,
        bottomWidgetPicker: Positioned(
          bottom: 12,
          right: 8,
          child: FloatingActionButton(
            backgroundColor: Colors.deepOrange[600],
            onPressed: pickLocation,
            child: const Icon(Icons.chevron_right),
          ),
        ),
        initZoom: 15,
      ),
    );
  }
}