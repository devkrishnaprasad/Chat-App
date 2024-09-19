import 'package:chat_app/pages/inbox/widgets/chat_list.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class Inbox extends StatelessWidget {
  Inbox({super.key});
  HelperController helperController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Localizations.override(
          context: context,
          locale: Locale(helperController.currentLanguage.value),
          child: Builder(
            builder: (context) {
              return Text(
                AppLocalizations.of(context)!.message,
                style: mainTitle.copyWith(
                    color: blackColor, fontWeight: FontWeight.w800),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: blackColor,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () {
              if (helperController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ChatList()],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
