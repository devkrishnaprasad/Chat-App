import 'dart:math';

import 'package:chat_app/pages/location/controller/location_controller.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: use_key_in_widget_constructors
class LocationPage extends StatelessWidget {
  final LocationController _locationController =
      Get.put(LocationController()); // Instantiate controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () {
          if (_locationController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _locationController.currentLocation.value,
                  zoom: 13.0,
                ),
                onMapCreated: (GoogleMapController controller) {},
                markers: _locationController.markers,
                polygons: {
                  Polygon(
                    polygonId: const PolygonId('current_location_rectangle'),
                    points: _calculateRectanglePoints(
                        _locationController.currentLocation.value, 2000),
                    strokeColor: Colors.red..withOpacity(0.2),
                    strokeWidth: 1,
                    fillColor: shadowColor.withOpacity(0.1),
                  ),
                },
              ),
            );
          }
        },
      ),
    );
  }

  List<LatLng> _calculateRectanglePoints(LatLng center, double radius) {
    final double latDelta = radius / 111300;
    final double lonDelta = radius / (111300 * cos(center.latitude * pi / 180));

    return [
      LatLng(center.latitude + latDelta, center.longitude - lonDelta),
      LatLng(center.latitude + latDelta, center.longitude + lonDelta),
      LatLng(center.latitude - latDelta, center.longitude + lonDelta),
      LatLng(center.latitude - latDelta, center.longitude - lonDelta),
    ];
  }
}
