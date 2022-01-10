import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: true,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomPickerLocation(
        controller: controller,
        bottomWidgetPicker: Positioned(
          bottom: 12,
          right: 8,
          child: FloatingActionButton(
            onPressed: () async {
              GeoPoint p = await controller.selectAdvancedPositionPicker();
              Navigator.pop(context, p);
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ),
        initZoom: 15,
      ),
    );
  }
}