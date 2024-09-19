import 'package:chat_app/main.dart';
import 'package:chat_app/pages/login/widgets/login_form.dart';
import 'package:chat_app/pages/register/register.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/chat_ic.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Localizations.override(
                    context: context,
                    locale: Locale(helperController.currentLanguage.value),
                    child: Builder(
                      builder: (context) {
                        return Text(
                          AppLocalizations.of(context)!.sign_in_to_account,
                          style: headingText,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                LoginForm(),
                const SizedBox(height: 20),
                Center(
                  child: Localizations.override(
                    context: context,
                    locale: Locale(helperController.currentLanguage.value),
                    child: Builder(
                      builder: (context) {
                        return Text(
                          AppLocalizations.of(context)!.other_way_to_sign_in,
                          style: labelText.copyWith(color: shadowColor),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border:
                              Border.all(color: shadowColor.withOpacity(0.2))),
                      child: Center(
                        child: Image.asset('assets/icons/google_ic.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border:
                              Border.all(color: shadowColor.withOpacity(0.2))),
                      child: Center(
                        child: Image.asset('assets/icons/facebook_ic.png'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Localizations.override(
                      context: context,
                      locale: Locale(helperController.currentLanguage.value),
                      child: Builder(
                        builder: (context) {
                          return Text(
                            AppLocalizations.of(context)!.no_account,
                            style: labelText,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Get.to(RegisterPage());
                      },
                      child: Localizations.override(
                        context: context,
                        locale: Locale(helperController.currentLanguage.value),
                        child: Builder(
                          builder: (context) {
                            return Text(
                              AppLocalizations.of(context)!.create_account,
                              style: labelText.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
