import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:geocode/geocode.dart';

class ClientAddressMapController{

  late BuildContext context;
  Function? refresh;
  Position? _position;
  String? addressName;
  LatLng? addressLatLng;

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(9.9354937, -84.0753634),
      zoom: 16
  );

  Completer<GoogleMapController> _mapController = Completer();

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address' : addressName,
      'lat' : addressLatLng?.latitude,
      'lng': addressLatLng?.longitude
    };

    Navigator.pop(context, data);
  }

  Future<Null> setLocationDraggableInfo() async {
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;


     // List<Placemark> address = await placemarkFromCoordinates(lat, lng);


    //  List<Placemark> address = await placemarkFromCoordinates(lat,lng);

    //  GeoCode address2 = (await GeoCode().reverseGeocoding(latitude lat, longitude: lng)) as GeoCode;


   //   Future<Address> reverseGeocoding({double latitude, double longitude});

  //    List<GeoCode> address = GeoCode().reverseGeocoding(latitude: lat, longitude: lng) as List<GeoCode>;


      GeoCode geoCode = GeoCode();

      Address? address = await geoCode.reverseGeocoding(latitude: lat, longitude: lng);


      String? direction = address?.streetAddress ?? '';
      String? street = address.streetNumber.toString();
      String? city = address?.city ?? '';
      String? region = address?.region.toString() ?? '';

      addressName = '${direction ?? ''}, ${city ?? ''}, ${region ?? ''}';
      addressLatLng = LatLng(lat, lng);
      print('LAT ${addressLatLng!.latitude}');
      print('LAT ${addressLatLng!.longitude}');

      refresh!();



      //Future<Address> reverseGeocoding({double latitude, double longitude})

     // List<PlaceMark> address = await
    }
  }

  void onMapCreated(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async{
    try{

      await _determinePosition(); // Obtiene la ubicación actual y también solocita los permisos
      _position = await Geolocator.getLastKnownPosition();
      animateCameraToPosition(_position!.latitude, _position!.longitude);

    }catch(e){
      print('Error: $e');
    }
  }

  void checkGPS() async{
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled){
      updateLocation();
    }else{
      bool locationGPS = await location.Location().requestService();
      if(locationGPS){
        updateLocation();
      }
    }
  }

  Future animateCameraToPosition(double lat, double lng) async{
    GoogleMapController controller = await _mapController.future;
    if(controller != null){
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
          zoom: 16,
          bearing: 0
        )
      ));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
  
}