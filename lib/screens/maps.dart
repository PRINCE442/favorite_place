import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
        latitude: 37.4222, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;
  final apikey =
      'sk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbWFvN2g3dDBmNmkzdGw1ZTJjZjlzcTUifQ.ay6rnu8T8t3gSoEay-YJzQ';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_pickedLocation);
                },
                icon: const Icon(Icons.save))
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          onTap: !widget.isSelecting
              ? null
              : (tapPosition, point) {
                  setState(() {
                    _pickedLocation = point;
                  });
                },
          center: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 15.0,
        ),
        nonRotatedChildren: [
          RichAttributionWidget(
            popupInitialDisplayDuration: const Duration(seconds: 5),
            animationConfig: const ScaleRAWA(),
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(
                  Uri.parse('https://openstreetmap.org/copyright'),
                ),
              ),
              const TextSourceAttribution(
                'This attribution is the same throughout this app, except where otherwise specified',
                prependCopyright: false,
              ),
            ],
          ),
        ],
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/prince442/clmaoknms019201qyf4of3g3y/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbTdqeDY3MDAxaWwzcGxtZWViYWE4NzAifQ.deWYF6bV5cbSoVp0Trd_Gw',
            userAgentPackageName: 'com.example.favorite_places',
          ),
          MarkerLayer(
            markers: _pickedLocation == null && widget.isSelecting == true
                ? []
                : [
                    Marker(
                      point: _pickedLocation ??
                          LatLng(widget.location.latitude,
                              widget.location.longitude),
                      width: 80,
                      height: 80,
                      builder: (context) => const Icon(
                        Icons.place,
                        size: 50.00,
                        color: Color.fromARGB(255, 174, 16, 5),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}






//https://api.mapbox.com/styles/v1/prince442/clmaoknms019201qyf4of3g3y/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbTdqeDY3MDAxaWwzcGxtZWViYWE4NzAifQ.deWYF6bV5cbSoVp0Trd_Gw

// mapbox://styles/prince442/clmaoknms019201qyf4of3g3y

//  https://api.mapbox.com/styles/v1/prince442/clmaoknms019201qyf4of3g3y/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbTdqeDY3MDAxaWwzcGxtZWViYWE4NzAifQ.deWYF6bV5cbSoVp0Trd_Gw