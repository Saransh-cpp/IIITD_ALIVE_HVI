import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iiitd_alive/search_location.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  ValueNotifier<GeoPoint?> start = ValueNotifier(null);
  String coordinatesStart = "";

  ValueNotifier<GeoPoint?> end = ValueNotifier(null);
  String coordinatesEnd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Please select"),
            ValueListenableBuilder<GeoPoint?>(
              valueListenable: start,
              builder: (ctx, p, child) {
                return Center(
                  child: p == null ? ElevatedButton(
                    onPressed: () async {
                      var p = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchPage()));
                      if (p != null) {
                        coordinatesStart =
                        "${(p as GeoPoint).latitude}, ${p.longitude}";
                        start.value = p;
                      }
                    },
                    child: const Text("Select starting point"),
                  ) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(coordinatesStart),
                      IconButton(onPressed: () async {
                        var p = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SearchPage()));
                        if (p != null) {
                          coordinatesStart =
                          "${(p as GeoPoint).latitude}, ${p.longitude}";
                          start.value = p;
                        }
                      }, icon: const Icon(Icons.location_on))
                    ],
                  ),
                );
              },
            ),
            ValueListenableBuilder<GeoPoint?>(
              valueListenable: end,
              builder: (ctx, p, child) {
                return Center(
                  child: p == null ? ElevatedButton(
                    onPressed: () async {
                      var p = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchPage()));
                      if (p != null) {
                        coordinatesEnd =
                        "${(p as GeoPoint).latitude}, ${p.longitude}";
                        end.value = p;
                      }
                    },
                    child: const Text("Select starting point"),
                  ) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(coordinatesEnd),
                      IconButton(onPressed: () async {
                        var p = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SearchPage()));
                        if (p != null) {
                          coordinatesEnd =
                          "${(p as GeoPoint).latitude}, ${p.longitude}";
                          end.value = p;
                        }
                      }, icon: const Icon(Icons.location_on))
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(onPressed: () {
              if (coordinatesEnd == "" || coordinatesStart == "") {
                Fluttertoast.showToast(
                    msg: 'Please select both the locations',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    fontSize: 16.0
                );
              } else {
                Navigator.of(context).pop([coordinatesStart, coordinatesEnd]);
              }
            }, child: const Text("Done?"))
          ],
        ),
      ),
    );
  }
}
