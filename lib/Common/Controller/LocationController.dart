import 'dart:developer';

import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Locationcontroller extends GetxController {
  var isLoading = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  GoogleMapController? mapController;
  static const LatLng initialPosition = LatLng(28.6139, 77.2090);
   RxString currentCountry = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }


  Future<void> getCurrentCountry() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      currentCountry.value = placemarks.first.country ?? "";
      log("Current Country: ${currentCountry.value}");
    }
  }


  Future<void> moveToCurrentLocation() async {
    Position position = await getCurrentLocation();

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 16,
        ),
      ),
    );
  }

  RxSet<Marker> markers = <Marker>{}.obs;

  Future<void> fetchLocation() async {
    try {
      isLoading.value = true;

      Position position = await getCurrentLocation();

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      markers.value = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Current Location',
          ),
        ),
      };

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );

      update(); // if using GetBuilder
    } catch (e) {
      CustomWidget().showCustomToast(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
