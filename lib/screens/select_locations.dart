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

  ValueNotifier<GeoPoint?> start = ValueNotifier(null);
  String coordinatesStart = "";

  ValueNotifier<GeoPoint?> end = ValueNotifier(null);
  String coordinatesEnd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
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
                  ValueListenableBuilder<GeoPoint?>(
                    valueListenable: start,
                    builder: (ctx, p, child) {
                      return Center(
                        child: p == null ? ElevatedButton(
                          onPressed: () async {
                            var p = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const SearchPage()));
                            if (p != null) {
                              coordinatesStart =
                              "${(p as GeoPoint).latitude}, ${p.longitude}";
                              start.value = p;
                            }
                          },
                          child: const Text("Select pickup point"),
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
                            }, icon: const Icon(Icons.restore_outlined))
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
                                MaterialPageRoute(
                                    builder: (_) => const SearchPage()));
                            if (p != null) {
                              coordinatesEnd =
                              "${(p as GeoPoint).latitude}, ${p.longitude}";
                              end.value = p;
                            }
                          },
                          child: const Text("Select drop point"),
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
                            }, icon: const Icon(Icons.restore_outlined))
                          ],
                        ),
                      );
                    },
                  ),
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
                    child: MaterialButton(onPressed: () {
                      if (coordinatesEnd == "" || coordinatesStart == "") {
                        Fluttertoast.showToast(
                            msg: 'Please select both the locations',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0
                        );
                      } else {
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
