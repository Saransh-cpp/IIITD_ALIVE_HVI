import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textEditingController = TextEditingController();
    late PickerMapController controller = PickerMapController(
      initMapWithUserPosition: true,
    );

    @override
    void initState() {
      super.initState();
      textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPickerLocation(
      controller: controller,
      appBarPicker: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: TextField(
          controller: textEditingController,
          onEditingComplete: () async {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          decoration: InputDecoration(
            suffix: ValueListenableBuilder<TextEditingValue>(
              valueListenable: textEditingController,
              builder: (ctx, text, child) {
                if (text.text.isNotEmpty) {
                  return child!;
                }
                return const SizedBox.shrink();
              },
              child: InkWell(
                focusNode: FocusNode(),
                onTap: () {
                  textEditingController.clear();
                  controller.setSearchableText("");
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            focusColor: Colors.black,
            filled: true,
            hintText: "Search",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: Colors.white,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
      topWidgetPicker: const TopSearchWidget(),
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
      initZoom: 8,
    );
  }
}

class TopSearchWidget extends StatefulWidget {
  const TopSearchWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = const Key("streamAddressSug");

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(const Duration(seconds: 3), (timer) async {
            await suggestionProcessing(v);
            timer.cancel();
          });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: const Duration(
            milliseconds: 500,
          ),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(
            child: child!,
          ),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () async {
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(
                      FocusNode(),
                    );
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
