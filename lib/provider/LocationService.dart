import 'dart:async';

import 'package:location/location.dart';
import 'package:martialme/model/userLocation.dart';

class LocationService {
  UserLocation _currentLocation;

  var location = Location();

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude, longitude: userLocation.longitude);
    } on Exception catch (e) {
      print('Tidak dapat mengakses lokasi: ${e.toString()}');
    }
    return _currentLocation;
  }

  StreamController<UserLocation> _locationController = StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService(){
    location.requestPermission().then((granted){
      if(granted){
        location.onLocationChanged().listen((locationData){
          if(locationData != null){
            _locationController.add(UserLocation(latitude: locationData.latitude,longitude: locationData.longitude));
          }
        });
      }
    });
  }
}
