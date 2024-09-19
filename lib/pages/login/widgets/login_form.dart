import 'package:chat_app/services/firebase/firebase_service.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  HelperController helperController = Get.find();
  RxBool isPasswordHide = true.obs;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Add a more robust email validation if needed
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform sign-in action
      final email = _emailController.text;
      final password = _passwordController.text;

      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      await firebaseAuthService.signInWithEmailAndPassword(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(
                  AppLocalizations.of(context)!.email_address,
                  style: labelText,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email address',
              hintStyle: labelText.copyWith(color: shadowColor),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 10),
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(
                  AppLocalizations.of(context)!.password,
                  style: labelText,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              return TextFormField(
                controller: _passwordController,
                obscureText: isPasswordHide.value ? true : false,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      isPasswordHide.value = !isPasswordHide.value;
                    },
                    icon: Icon(isPasswordHide.value
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: labelText.copyWith(color: shadowColor),
                ),
                validator: _validatePassword,
              );
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Localizations.override(
              context: context,
              locale: Locale(helperController.currentLanguage.value),
              child: Builder(
                builder: (context) {
                  return Text(
                    AppLocalizations.of(context)!.forgot_password,
                    style: labelText,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Obx(
                () {
                  return helperController.isAutLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : Localizations.override(
                          context: context,
                          locale:
                              Locale(helperController.currentLanguage.value),
                          child: Builder(
                            builder: (context) {
                              return Text(
                                AppLocalizations.of(context)!.sign_in,
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
    );
  }
}
