import 'package:chat_app/services/firebase/firebase_service.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _countryController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  HelperController helperController = Get.find();
  RxBool isPasswordHide = true.obs;
  RxBool isConfirmPasswordHide = true.obs;
  RxString countryCode = ''.obs;
  RxString countryName = ''.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _countryController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Country is required';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform sign-up action
      final email = _emailController.text;
      final password = _passwordController.text;
      final username = _usernameController.text;
      final country = _countryController.text;
      final mobileNumber = _mobileNumberController.text;
      // Print or save the form data
      print('Email: $email');
      print('Password: $password');
      print('Username: $username');
      print('Country: $country');
      print('Mobile Number: $mobileNumber');

      FirebaseAuthService firebaseAuthService = FirebaseAuthService();

      await firebaseAuthService.signUpWithEmailAndPassword(
          email, password, username, country, mobileNumber);
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
                return Text(AppLocalizations.of(context)!.email_address,
                    style: labelText);
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
                return Text(AppLocalizations.of(context)!.username,
                    style: labelText);
              },
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter your username',
              hintStyle: labelText.copyWith(color: shadowColor),
            ),
            validator: _validateUsername,
          ),
          const SizedBox(height: 10),
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(AppLocalizations.of(context)!.country,
                    style: labelText);
              },
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            style: const TextStyle(color: Colors.black),
            items: helperController.countryList.map((country) {
              return DropdownMenuItem<String>(
                value: country.name.common, // Use country code as value
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      country.name.common.toString(),
                      style: labelText.copyWith(),
                    ),
                    const SizedBox(width: 10),
                    Image.network(
                      country.flags.png,
                      width: 30,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/icons/facebook_ic.png',
                          width: 30,
                          height: 30,
                        );
                      },
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newCode) {
              if (newCode != null) {
                countryName.value = newCode;
                countryCode.value = helperController.countryList
                    .firstWhere((country) => country.name.common == newCode)
                    .idd
                    .root!;

                countryCode.value += helperController.countryList
                        .firstWhere((country) => country.name.common == newCode)
                        .idd
                        .suffixes
                        ?.join('') ??
                    '';
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select Country';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(AppLocalizations.of(context)!.mobile_number,
                    style: labelText);
              },
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _mobileNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefix: Obx(
                () {
                  return SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        Text(
                          countryCode.value,
                          style: labelText.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
              hintText: 'Enter your mobile number',
              hintStyle: labelText.copyWith(color: shadowColor),
            ),
            validator: _validateMobileNumber,
          ),
          const SizedBox(height: 10),
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(AppLocalizations.of(context)!.password,
                    style: labelText);
              },
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              return TextFormField(
                controller: _passwordController,
                obscureText: isPasswordHide.value,
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
          Localizations.override(
            context: context,
            locale: Locale(helperController.currentLanguage.value),
            child: Builder(
              builder: (context) {
                return Text(AppLocalizations.of(context)!.confirm_password,
                    style: labelText);
              },
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () {
              return TextFormField(
                controller: _confirmPasswordController,
                obscureText: isConfirmPasswordHide.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      isConfirmPasswordHide.value =
                          !isConfirmPasswordHide.value;
                    },
                    icon: Icon(isConfirmPasswordHide.value
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined),
                  ),
                  hintText: 'Enter your confirm password',
                  hintStyle: labelText.copyWith(color: shadowColor),
                ),
                validator: _validateConfirmPassword,
              );
            },
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
                      : const Text('Sign up');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
