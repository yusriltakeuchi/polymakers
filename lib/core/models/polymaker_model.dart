
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polymaker/core/models/location_model.dart';

class PolyMakerModel {
  String id;
  String title;
  List<LocationModel> location;

  PolyMakerModel({
    this.id, this.title,this.location
  });

  //Converter from map to object
  factory PolyMakerModel.fromMap(Map<String, dynamic> map, List<LocationModel> _location) {
    return PolyMakerModel(
      id: map['id'].toString(),
      title: map['title'],
      location: _location
    );
  }

  //Converter from object to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = id;
		}
		map['title'] = title;
		
		return map;
  }
}