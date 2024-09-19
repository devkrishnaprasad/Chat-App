import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/login/login_page.dart';
import 'package:chat_app/pages/spalsh_screen/spalsh_screen.dart';
import 'package:chat_app/services/firebase/notification_servce.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:chat_app/services/local_storage/local_storage.dart';
import 'package:chat_app/utils/nav_bar.dart';
import 'package:chat_app/utils/themes/app_theme.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

RxBool isLoggedIn = false.obs;
HelperController helperController = Get.put(HelperController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Messaging
  await FirebaseMessaging.instance.getInitialMessage();

  // Initialize your custom notification service
  await NotificationService().init();
  // Initialize notifications
  await NotificationService().initNotification();
  // Initialize LocalStorage and check token
  LocalStorage localStorage = LocalStorage();
  var token = await localStorage.read('username');

  if (token == null) {
    isLoggedIn.value = false;
  } else {
    helperController.userId.value = await localStorage.read('userId');

    isLoggedIn.value = true;
    await helperController.getAllUsersList();
  }

  await helperController.initialSetup();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        appBarTheme: appBarTheme,
        dropdownMenuTheme: dropdownThemeData,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: blackColor,
        ),
        elevatedButtonTheme: lightElevatedButtonTheme,
        scaffoldBackgroundColor: whiteColor,
        inputDecorationTheme: textFiledDecoration,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        bottomSheetTheme: bottomSheetThemeData,
        useMaterial3: true,
      ),
      home: Obx(
        () {
          return helperController.isLoading.value
              ? const SpalshScreen()
              : isLoggedIn.value
                  ? const NavigationWidget()
                  : const LoginPage();
        },
      ),
    );
  }
}
