import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus { idle, loading, loaded, empty, error }

class LocationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  LocationProvider({required this.sharedPreferences});  

  LocationStatus _locationStatus = LocationStatus.idle;
  LocationStatus get locationStatus => _locationStatus;

  GoogleMapController? controller;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  
  List<Marker> _markers = [];
  List<Marker> get markers => [..._markers];

  void setStateLocationStatus(LocationStatus locationStatus) {
    _locationStatus = locationStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getCurrentPosition(BuildContext context) async {
    setStateLocationStatus(LocationStatus.loading);
    _markers = [];
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      sharedPreferences.setDouble("lat", position.latitude);
      sharedPreferences.setDouble("long", position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark? place = placemarks[0];
      _markers.add(
        Marker(
          markerId: const MarkerId("currentlocation"),
          infoWindow: InfoWindow(
            title: "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}",
          ),
          position: LatLng(position.latitude, position.longitude)
        )
      );
      sharedPreferences.setString("currentNameAddress", "${place.thoroughfare} ${place.subThoroughfare} \n${place.locality}, ${place.postalCode}");
      setStateLocationStatus(LocationStatus.loaded);
    } catch(e) {
      setStateLocationStatus(LocationStatus.error);
      debugPrint(e.toString());
    } 
  }

  String get getCurrentNameAddress => sharedPreferences.getString("currentNameAddress") ?? "Location no Selected"; 

  double get getCurrentLat => sharedPreferences.getDouble("lat") ?? -6.175392;
  
  double get getCurrentLng => sharedPreferences.getDouble("long") ?? 106.827153;
}
