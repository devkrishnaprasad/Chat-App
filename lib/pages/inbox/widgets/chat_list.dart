import 'package:chat_app/pages/chat/chat_box.dart';
import 'package:chat_app/pages/chat/controller/chat_controller.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  ChatController chatController = Get.put(ChatController());
  HelperController helperController = Get.find();
  ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var data = helperController.userList[index];
            return GestureDetector(
              onTap: () {
                chatController.reciverId.value = data.userId;
                chatController.senderUsername.value = data.username;
                chatController.revicerDeviceToken.value = data.deviceToken;
                Get.to(ChatBox());
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: getRandomColor(),
                    radius: 25,
                    child: Text(
                      data.username[0].toUpperCase(),
                      style: chatPersonName.copyWith(color: whiteColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.username,
                              style: chatPersonName,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          data.mobileNumber,
                          style: messageText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.2,
              height: 40,
              color: Colors.grey,
            );
          },
          itemCount: helperController.userList.length,
        );
      },
    );
  }
}
