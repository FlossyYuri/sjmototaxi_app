import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agotaxi/model/place.dart';
import 'package:agotaxi/services/maps.dart';
import 'package:agotaxi/store/maps_store_controller.dart';

class MapSearchField extends StatefulWidget {
  final Function callback;
  const MapSearchField({super.key, required this.callback});

  @override
  State<MapSearchField> createState() => _MapSearchFieldState();
}

class _MapSearchFieldState extends State<MapSearchField> {
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());
  TextEditingController _textController = TextEditingController();
  List<GoogleMapsPlace> places = [];
  String query = '';
  bool isSearching = false;
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();

  Future<void> searchPlaces(String query) async {
    List<dynamic> foundPlaces =
        await textSearchGoogleMapsPlaces(query, LatLng(-25.8858, 32.6129));
    setState(() {
      places = foundPlaces.map((place) {
        return GoogleMapsPlace(
          place['name'],
          place['place_id'],
          LatLng(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']),
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isSearching = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset(0, 5),
                      color: Colors.black.withAlpha(50),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.grey.shade400),
                      onPressed: () {
                        mapsStoreController.requestStep.value = 0;
                      },
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escreva seu destino aqui',
                        ),
                        onChanged: (text) async {
                          setState(() {
                            query = text;
                            isLoading = true;
                          });
                          if (text.isNotEmpty) {
                            await searchPlaces(text);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color:
                            query.isEmpty ? Colors.grey.shade400 : Colors.black,
                      ),
                      onPressed: () {
                        _textController.text = '';
                        _focusNode.unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isSearching)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset(0, 5),
                      color: Colors.black.withAlpha(50),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 2,
                      )
                    : Container(
                        height: places.length > 3 ? 250 : null,
                        child: ListView.builder(
                          itemCount: places.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(places[index].name),
                              splashColor: Colors.grey.shade100,
                              titleTextStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              selectedColor: Colors.grey.shade100,
                              onTap: () {
                                widget.callback(
                                    places[index].geometry, places[index].name);
                                _textController.text = places[index].name;
                                _focusNode.unfocus();
                              },
                            );
                          },
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
