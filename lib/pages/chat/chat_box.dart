import 'package:chat_app/main.dart';
import 'package:chat_app/pages/chat/controller/chat_controller.dart';
import 'package:chat_app/utils/themes/colors.dart';
import 'package:chat_app/utils/themes/fonts.dart';
import 'package:chat_app/utils/wrappers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBox extends StatelessWidget {
  final ChatController chatController = Get.find();
  final AppWrapper appWrapper = AppWrapper();
  final ScrollController _scrollController = ScrollController();

  ChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              chatController.senderUsername.value,
              style: mainTitle.copyWith(
                color: blackColor,
                fontWeight: FontWeight.w200,
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    chatController.getMessage(helperController.userId.value),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Loading...'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No messages'));
                  }

                  final List<QueryDocumentSnapshot> message =
                      snapshot.data!.docs;
                  if (message.isEmpty) {
                    return Text('Empty chat');
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      final messageData = message[index].data() as Map?;
                      final String messagetext =
                          messageData!['message'] ?? "No message Found";

                      return Align(
                        alignment: messageData['sender_id'] ==
                                helperController.userId.value
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: messageData['sender_id'] ==
                                  helperController.userId.value
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: messageData['sender_id'] ==
                                        helperController.userId.value
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft: messageData['sender_id'] ==
                                          helperController.userId.value
                                      ? const Radius.circular(15)
                                      : const Radius.circular(0),
                                  bottomRight: messageData['sender_id'] ==
                                          helperController.userId.value
                                      ? const Radius.circular(0)
                                      : const Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                messagetext,
                                style: labelText.copyWith(
                                  color: messageData['sender_id'] ==
                                          helperController.userId.value
                                      ? Colors.white
                                      : blackColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    4), // Space between the message and the timestamp
                            Text(
                              appWrapper.formatTimestamp(messageData[
                                  'timestamp']), // Assuming timestamp is a string
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: () {
                      // Add send message functionality here
                      String message = messageController.text.trim();
                      if (message.isNotEmpty) {
                        chatController.sendMessage(message);
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
