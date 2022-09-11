import 'dart:io';

import 'package:chat_realtime/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textAreaCtrl = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatMessage> messages = [];

  bool _isWritting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text(
                "AL",
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(),
            Text(
              "Alex Cantón",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (_, i) => messages[i],
                reverse: true,
              ),
            ),
            const Divider(),
            // TODO: Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textAreaCtrl,
              onSubmitted: _handleSubmit,
              onChanged: (String str) {
                setState(() {
                  _isWritting = str.trim().length > 0;
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: "Enviar mensaje"),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWritting ? () => _handleSubmit : null,
                    child: const Text("Enviar"),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(
                          Icons.send,
                        ),
                        onPressed: _isWritting ? () => _handleSubmit : null,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textAreaCtrl.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: texto,
      uid: "123",
      animationCrtl: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ),
      ),
    );
    messages.insert(0, newMessage);
    newMessage.animationCrtl.forward();

    setState(() {
      _isWritting = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Off del socket

    //Clear messages instances
    for (ChatMessage message in messages) {
      message.animationCrtl.dispose();
    }
  }
}
