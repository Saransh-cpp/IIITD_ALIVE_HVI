import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

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
            child: const Icon(Icons.arrow_forward),
          ),
        ),
        initZoom: 15,
      ),
    );
  }
}