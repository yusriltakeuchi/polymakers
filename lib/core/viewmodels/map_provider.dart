
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:polymaker/core/config/config.dart';
import 'package:polymaker/core/models/location_model.dart';
import 'package:polymaker/core/models/polymaker_model.dart';
import 'package:polymaker/core/services/polymaker_services.dart';
import 'package:polymaker/core/utils/dialog_utils.dart';

class MapProvider extends ChangeNotifier {

  //------------------------//
  //   PROPERTY SECTIONS    //
  //------------------------//
  
  //Property zoom camera
  double _cameraZoom = 16;
  double get cameraZoom => _cameraZoom;

  //Property camera position
  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;

  //Property camera tilt
  double _cameraTilt = 0;
  double get cameraTilt => _cameraTilt;

  //Property camera bearing
  double _cameraBearing = 0;
  double get cameraBearing => _cameraBearing;

  //Property my location data
  LatLng _sourceLocation;
  LatLng get sourceLocation => _sourceLocation;

  //Property Google Map Controller completer
  Completer<GoogleMapController> _completer = Completer();
  Completer<GoogleMapController> get completer => _completer;

  //Property Google Map Controller
  GoogleMapController _controller;
  GoogleMapController get controller => _controller;

  //Property to save all markers
  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  //Property custom icon to point polygon
  BitmapDescriptor _pointIcon;
  BitmapDescriptor get pointIcon => _pointIcon;

  //Property custom icon to polygon location
  BitmapDescriptor _polyIcon;
  BitmapDescriptor get polyIcon => _polyIcon;

  //Property to mapStyle
  String _mapStyle;
  String get mapStyle => _mapStyle;

  //Property location services
  Location location = new Location();

  //Property to handle edit mode
  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;
  

  //Property polygon list
  Set<Polygon> _polygons = new Set();
  Set<Polygon> get polygons => _polygons;

  //Property temporary polygon list
  Set<Polygon> _tempPolygons = new Set();
  Set<Polygon> get tempPolygons => _tempPolygons;

  //Property temporary location
  List<LatLng> _tempLocation = new List();
  List<LatLng> get tempLocation => _tempLocation;

  //Property to get uniqueId for markers
  String _uniqueID = "";
  String get uniqueID => _uniqueID;

  //Property Polymaker Services
  PolyMakerServices polyMakerServices = new PolyMakerServices();
  
  //------------------------//
  //   FUNCTION SECTIONS   //
  //------------------------//

  //Function to initialize camera
  void initCamera() async {
    
    //Get current locations
    await initLocation();

    //Set current location to camera
    _cameraPosition = CameraPosition(
      zoom: cameraZoom,
      bearing: cameraBearing,
      tilt: cameraTilt,
      target: sourceLocation
    );
    notifyListeners();
  }

  //Function to get current locations
  void initLocation() async {
    var locData = await location.getLocation();
    _sourceLocation = LatLng(locData.latitude, locData.longitude);
    
    notifyListeners();
  }

  //Function to load all polygons saved from database
  void loadPolygons() async {
    _polygons.clear();
    _markers.clear();
    List<PolyMakerModel> result = await polyMakerServices.getAll();

    for(var polyMaker in result) {
      polygons.add(Polygon(
        polygonId: PolygonId("${polyMaker.id}-${polyMaker.title}"),
        points: polyMaker.location.map((val) => LatLng(val.latitude, val.longitude)).toList(),
        strokeWidth: 3,
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        )
      );
      
      setMarkerLocation(
        "${polyMaker.id}", 
        LatLng(polyMaker.location[0].latitude, polyMaker.location[0].longitude), 
        _polyIcon,
        title: polyMaker.title
      );
    }
    notifyListeners();
  }

  
  //Function to handle when maps created
  void onMapCreated(GoogleMapController controller) async {
    
    //Loading map style
    _mapStyle = await rootBundle.loadString(Config.mapStyleFile);

    _completer.complete(controller);
    _controller = controller;

    setIcons();
    loadPolygons();

    //Set style to map
    _controller.setMapStyle(_mapStyle);
    
    notifyListeners();
  }

  //Function to set custom icon marker
  void setIcons() async {
    _pointIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), "${Config.imageIcon}/point_location.png");

    _polyIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), "${Config.imageIcon}/poly_location.png");

    notifyListeners();
  }

  //Function to change camera position
  void changeCameraPosition(LatLng location) {
    _controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(location.latitude, location.longitude,), cameraZoom)
    );

    notifyListeners();
  }

  //Function to change toggle edit mode
  void changeEditMode() {
    _isEditMode = !_isEditMode;

    if (_isEditMode == false) {
      _uniqueID = "";
      _tempPolygons.clear();
      _tempLocation.clear();
      _markers.clear();
      loadPolygons();
    } else {
      _polygons.clear();
      _markers.clear();
    }
    notifyListeners();
  }

  //Function to handle onTap Map and get location
  void onTapMap(LatLng _location) {
    if (isEditMode == true) {
      _tempLocation.add(_location);
      if (_uniqueID == "") {
        _uniqueID = Random().nextInt(10000).toString();
      }
      
      setMarkerLocation(_tempLocation.length.toString(), _location, _pointIcon);
      setTempToPolygon();
    }
    notifyListeners();
  }

  //Function to set marker locations
  void setMarkerLocation(String id, LatLng _location, BitmapDescriptor icon, {String title}) {
    _markers.add(Marker(
      markerId: MarkerId("${uniqueID + id}"),
      position: _location,
      icon: icon,
      infoWindow: title != null ? InfoWindow(title: title, snippet: "Area Polygon Nomor ${id}") : null
    ));

    notifyListeners();
  }

  //Function to set temporary polygons to polygons
  void setTempToPolygon() {
    if (_tempPolygons != null) {
      _tempPolygons.removeWhere((poly) => poly.polygonId == uniqueID);
    }

    _tempPolygons.add(Polygon(
      polygonId: PolygonId(uniqueID),
      points: _tempLocation,
      strokeWidth: 3,
      fillColor: Colors.red.withOpacity(0.3),
      strokeColor: Colors.red)
    );
    _polygons = _tempPolygons;
    notifyListeners();
  }

  //Function to undo select location in edit mode
  void undoLocation() {
    if (_tempLocation.length > 0) {
      _markers.removeWhere((mark) => mark.position == _tempLocation.last);
      _tempLocation.removeLast();
      if (_tempLocation.length == 0) {
        _tempPolygons.clear();
      }
    }
    notifyListeners();
  }

  //Function to save polygon to database
  void savePolygon(TextEditingController titleController, BuildContext context) {
    if (_tempLocation.length > 0) {
      DialogUtils.showReport(context, "Menyimpan Polygon", titleController, () async {
        Navigator.pop(context);

        //Inserting to database
        var polyMakerModel = PolyMakerModel(
          title: titleController.text,
          location: _tempLocation.map((_loc) => LocationModel.fromMap({
            "latitude": _loc.latitude,
            "longitude": _loc.longitude
          })).toList()
        );

        try {
          bool result = await polyMakerServices.create(polyMakerModel);
          if (result) {
            DialogUtils.showDialogWarning(
              context, 
              "Menyimpan Polygon", 
              "Berhasil Menyimpan lokasi polygon", () => Navigator.pop(context));
          }
          changeEditMode();
        } catch(e) {
          DialogUtils.showDialogWarning(
              context, 
              "Gagal Menyimpan", 
              "Gagal Menyimpan lokasi polygon", () => Navigator.pop(context));
          changeEditMode();
        }
      });
    }
  }

}