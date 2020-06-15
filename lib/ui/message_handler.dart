import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pushnotificationpoc/model/message.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('On Message: $message');
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
            title: notification['title'],
            body: notification['body']
          ));
        });

      },
      onLaunch: (Map<String, dynamic> message) async {
        print('On Launch: $message');
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: notification['title'],
              body: notification['body']
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('On Resume: $message');
        final notification = message['data'];
        setState(() {
          messages.add(Message(
              title: notification['title'],
              body: notification['body']
          ));
        });
      },
    );
    if(Platform.isIOS){
      _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true,alert: true,badge: true));
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: messages.map(buildMessage).toList()
  );

  Widget buildMessage(Message message) => ListTile(
    title: Text(message.title),
    subtitle: Text(message.body),
  );
}
