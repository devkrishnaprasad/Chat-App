import 'package:chat_app/services/firebase/firebase_service.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  HelperController helperController = Get.find();
  SettingsPage({super.key});
  RxString selectedOption = 'English'.obs; // Default language is English

  @override
  Widget build(BuildContext context) {
    selectedOption.value =
        helperController.currentLanguage.value == 'en' ? "English" : "Arabic";
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
                  return Localizations.override(
                    context: context,
                    locale: Locale(helperController.currentLanguage.value),
                    child: Builder(
                      builder: (context) {
                        return Text(
                          AppLocalizations.of(context)!.change_language,
                          style: labelText,
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedOption.value.isEmpty
                      ? null
                      : selectedOption
                          .value, // Ensure the value is not empty or null
                  items: const [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'Arabic',
                      child: Text('Arabic'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      selectedOption.value = value;

                      selectedOption.value == "English"
                          ? helperController.currentLanguage.value = 'en'
                          : helperController.currentLanguage.value = 'ar';
                      // Perform additional actions if needed, e.g., updating the app language
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Language',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    FirebaseAuthService firebaseAuthService =
                        FirebaseAuthService();
                    await firebaseAuthService.signOutUser();
                  },
                  child: Obx(
                    () {
                      return Localizations.override(
                        context: context,
                        locale: Locale(helperController.currentLanguage.value),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              AppLocalizations.of(context)!.sign_out,
                              style: labelText,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
