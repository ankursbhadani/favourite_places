import 'package:favourite_places/model/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath,'places.db'),
      onCreate: (db,version){
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY kEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)');
      },
      version: 1
  );
  return db;
}
class UserPlaceNotifier extends StateNotifier<List<Places>>{

  UserPlaceNotifier():super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) =>
        Places(
          id: row['id'] as String,
          title: row['title'] as String,
            image: File(row['image'] as String),
            placeLocation: PlaceLocation(longitude: row['lng'] as double,
                latitude: row['lat'] as double,
                address: row['address'] as String),),).toList();
    state = places;
  }


  void addPlaces(String title,File image,PlaceLocation placeLocation)
   async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');
    final newPlace = Places(title: title,image: copiedImage,placeLocation: placeLocation);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id':newPlace.id,
      'title':newPlace.title,
      'image':newPlace.image.path,
      'lat':newPlace.placeLocation.latitude,
      'lng':newPlace.placeLocation.longitude,
      'address':newPlace.placeLocation.address,
    });
    state = [newPlace,...state];
  }
}
final userPlacesProvider = StateNotifierProvider<UserPlaceNotifier,List<Places>>((ref) => UserPlaceNotifier());