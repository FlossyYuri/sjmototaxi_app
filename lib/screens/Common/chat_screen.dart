import 'package:sjmototaxi_app/widget/common/chat_bubble.dart';
import 'package:sjmototaxi_app/widget/common/received_bubble.dart';
import 'package:sjmototaxi_app/widget/layout/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const SimpleAppBar(
            title: 'Conversa',
            isDark: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  children: [
                    Text(
                      'Historico',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: Image.asset(
                        'assets/images/kfc.jpg',
                        fit: BoxFit.cover,
                      ).image,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: const SingleChildScrollView(
                    child: Column(
                      children: [
                        SentMessage(message: "Hello this is cool"),
                        ReceivedMessage(
                            message: "Hi this is awesome chat bubble"),
                        SentMessage(message: "Hello this is cool"),
                        ReceivedMessage(
                            message: "Hi this is awesome chat bubble"),
                        SentMessage(message: "Hello this is cool"),
                        ReceivedMessage(
                            message: "Hi this is awesome chat bubble"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
