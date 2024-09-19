import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  RxBool isLoading = false.obs;
  var currentLocation = const LatLng(27.7172, 85.3240).obs;
  var markers = Set<Marker>().obs;
  BitmapDescriptor? customIcon;

  @override
  void onInit() {
    super.onInit();
    _loadCustomIcon(); // Load the custom icon
    _getCurrentLocation();
  }

  // Method to load the custom red location icon
  Future<void> _loadCustomIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Set size if needed
      'assets/images/location_ic.png', // Path to your asset
    );
  }

  // Method to fetch current location
  Future<void> _getCurrentLocation() async {
    try {
      isLoading.value = true;

      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Update the current location
      currentLocation.value = newLocation;

      // Add marker at current location with custom icon
      markers.clear(); // Clear any existing markers
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: newLocation,
          icon: customIcon ?? BitmapDescriptor.defaultMarker, // Use custom icon
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    } catch (e) {
      log('Location Error $e');
    } finally {
      isLoading.value = false;
    }
  }
}
