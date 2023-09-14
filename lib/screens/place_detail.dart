import 'package:favorite_places/screens/maps.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    const apiKey =
        'pk.eyJ1IjoicHJpbmNlNDQyIiwiYSI6ImNsbTdrM2Z2ZzAxbnUzY281N2ZuZHdtbnMifQ.vtbFZzlOLp5YZqYDbU3uIA';

    return 'https://api.mapbox.com/styles/v1/mapbox/light-v11/static/pin-s-l+ff0000($lng,$lat)/$lng,$lat,14/300x300?access_token=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapScreen(
                          location: place.location,
                          isSelecting: false,
                        ),
                      ));
                    },
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
