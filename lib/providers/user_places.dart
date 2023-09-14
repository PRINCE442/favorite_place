import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:favorite_places/models/place.dart';

Future<Database> _getDatabase() async {
  final databasePath = await sql.getDatabasesPath();
  final dataBase = await sql.openDatabase(
    path.join(databasePath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return dataBase;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final dataBase = await _getDatabase();
    final dbData = await dataBase.query('user_places');
    final places = dbData
        .map(
          (row44) => Place(
            id: row44['id'] as String,
            title: row44['title'] as String,
            image: File(row44['image'] as String),
            location: PlaceLocation(
                latitude: row44['lat'] as double,
                longitude: row44['lng'] as double,
                address: row44['address'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDirectory.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final dataBase = await _getDatabase();

    dataBase.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
