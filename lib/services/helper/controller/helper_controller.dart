import 'dart:developer';
import 'package:chat_app/services/firebase/firebase_service.dart';
import 'package:chat_app/services/helper/api/helper_api.dart';
import 'package:chat_app/services/helper/model/country_model.dart';
import 'package:chat_app/services/helper/model/user_model.dart';
import 'package:chat_app/services/helper/model/users_list_model.dart';
import 'package:chat_app/services/local_storage/local_sql_db.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HelperController extends GetxController {
  HelperApiService helperApiService = HelperApiService();
  DBOperations dbOperations = Get.put(DBOperations());
  RxString currentLanguage = 'en'.obs;

  RxBool isLoading = false.obs;
  RxBool isAutLoading = false.obs;
  RxString userId = ''.obs;
  var countryList = <CountryList>[].obs;
  var userDetails = <UserDetails>[].obs;
  var userList = <UserList>[].obs;
  var friendsList = <FriendsList>[].obs;
  getCountryList() async {
    try {
      isLoading.value = true;
      var response = await helperApiService.getCountryList();
      countryList.assignAll(
        response
            .map<CountryList>((json) => CountryList.fromJson(json))
            .toList(),
      );
      log('The lenght is ${countryList.length}');
    } catch (e) {
      log('Error while getting country details $e');
    } finally {
      isLoading.value = false;
    }
  }

  initialSetup() async {
    try {
      isLoading.value = true;
      await dbOperations.initDatabase();

      await requestLocationPermission();
      await getCountryList();

      friendsList.value = await dbOperations.getFriendsList();
    } catch (e) {
      log('Error $e');
      isLoading.value = false;
    }
  }

  requestLocationPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location persmisson are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location persmisson are denied forever');
    }
  }

  getAllUsersList() async {
    try {
      isLoading.value = true;
      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      var result = await firebaseAuthService.getAllUsersCurrent();
      log("Result $result");
      // Convert the result to List<UserList>
      List<UserList> userListItems =
          result.map((userMap) => UserList.fromMap(userMap)).toList();

      // Assign the list to userList
      userList.assignAll(userListItems);

      log(userList.length.toString());
    } catch (e) {
      log("Error while getting user list $e");
    } finally {
      isLoading.value = false;
    }
  }
}
