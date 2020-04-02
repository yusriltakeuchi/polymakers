
import 'package:polymaker/core/database/database.dart';
import 'package:polymaker/core/models/location_model.dart';
import 'package:polymaker/core/models/polymaker_model.dart';
import 'package:sqflite/sqflite.dart';

class PolyMakerDB {

  //Instance database helper
  var helper = new DatabaseHelper();

  Future getAll() async {
    Database db = await helper.database;

    //Get All polygons data
    var result = await db.query("polygon");
    return result;
  }

  Future getLocationByPolygonID(int id) async {
    Database db = await helper.database;

    var result = await db.rawQuery("select * from location where polygon_id = ${id}");
    return result;
  }

  Future<int> create(PolyMakerModel polyMakerModel) async {
    Database db = await helper.database;

    //Insert polygon data
    var result = db.insert("polygon", polyMakerModel.toMap());
    
    //insert location
    polyMakerModel.location.forEach((location) async {
      var locModel = LocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
        polygonID: await result
      );
      db.insert("location", locModel.toMap());
    });
    return result;
  }
}