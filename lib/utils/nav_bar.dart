import 'package:chat_app/pages/inbox/inbox.dart';
import 'package:chat_app/pages/location/location.dart';
import 'package:chat_app/pages/settings/settings.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // Prevents back button press
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: navigationController.selectedIndex.value,
            onTap: (index) async {
              // Update the selected index when user taps on a BottomNavigationBar item
              navigationController.selectedIndex.value = index;
              HelperController helperController = Get.find();
              if (navigationController.selectedIndex.value == 1) {
                await helperController.requestLocationPermission();
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin), label: 'Location'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
        body: Obx(
          () => navigationController
              .screens[navigationController.selectedIndex.value],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    Inbox(),
    LocationPage(),
    SettingsPage(),
  ];
}
