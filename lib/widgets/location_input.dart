import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/maps.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isgettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    const apiKey =
        'sk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbWFvN2g3dDBmNmkzdGw1ZTJjZjlzcTUifQ.ay6rnu8T8t3gSoEay-YJzQ';

    return 'https://api.mapbox.com/styles/v1/mapbox/light-v11/static/pin-s-l+ff0000($lng,$lat)/$lng,$lat,14/500x300?access_token=$apiKey';
  }

  void _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json?access_token=sk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbWFvN2g3dDBmNmkzdGw1ZTJjZjlzcTUifQ.ay6rnu8T8t3gSoEay-YJzQ');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['features'] != null &&
          responseData['features'].isNotEmpty) {
        final address = responseData['features'][0]['place_name'];

        setState(() {
          _pickedLocation = PlaceLocation(
              latitude: latitude, longitude: longitude, address: address);
          _isgettingLocation = false;
        });

        widget.onSelectLocation(_pickedLocation!);
        _savePlace(latitude, longitude);
      }
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isgettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=sk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbWFvN2g3dDBmNmkzdGw1ZTJjZjlzcTUifQ.ay6rnu8T8t3gSoEay-YJzQ');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['features'] != null &&
          responseData['features'].isNotEmpty) {
        final address = responseData['features'][0]['place_name'];
        if (mounted) {
          setState(() {
            _pickedLocation =
                PlaceLocation(latitude: lat, longitude: lng, address: address);
            _isgettingLocation = false;
          });
        }

        widget.onSelectLocation(_pickedLocation!);
      }
    }
    _savePlace(lat, lng);
    print(locationData.latitude);
    print(locationData.longitude);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (builder) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (pickedLocation == null) {
      return;
    }
    if (mounted) {
      setState(() {
        _savePlace(pickedLocation.latitude, pickedLocation.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen yet !',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage.toString(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isgettingLocation == true) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1.0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}

class IconMarker extends StatelessWidget {
  const IconMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.place,
      color: Color.fromARGB(255, 174, 16, 5),
    );
  }
}


// API KEY = AIzaSyB26Ew9IVsJOq4DrPGYFvq4WiibgC_ngrA
// https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyBQYxmAKLS19k6ug78gWzbCN2mO9iQ7Tgk