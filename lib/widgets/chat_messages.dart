import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authedUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chat is empty'));
          }
          if (chatSnapshot.hasError) {
            return const Center(child: Text('Smth went wrong'));
          }
          final loadedMsges = chatSnapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
              reverse: true,
              itemCount: loadedMsges.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMsges[index].data();
                final nextChatMessage = index + 1 < loadedMsges.length
                    ? loadedMsges[index + 1].data()
                    : null;

                final currentMassegeUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;

                final nextUserIsSame =
                    nextMessageUserId == currentMassegeUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authedUser!.uid == currentMassegeUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userImage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authedUser!.uid == currentMassegeUserId);
                }
              });
        });
  }
}
