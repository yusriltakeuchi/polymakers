

class LocationModel {
  double latitude;
  double longitude;
  int polygonID;

  LocationModel({
    this.latitude, this.longitude,
    this.polygonID
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  //Converter from object to map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
		map['latitude'] = latitude;
		map['longitude'] = longitude;
    map["polygon_id"] = polygonID;
		
		return map;
  }
}