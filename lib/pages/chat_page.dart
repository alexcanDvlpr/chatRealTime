import 'dart:io';

import 'package:chat_realtime/models/chat_messages_response.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:chat_realtime/services/chat_service.dart';
import 'package:chat_realtime/services/socket_service.dart';
import 'package:chat_realtime/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textAreaCtrl = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', (data) => _listenSocketMessage);

    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory(String uid) async {
    List<Message> lstMessage = await chatService.getChatMessages(uid);

    final history = lstMessage.map(
      (m) => ChatMessage(
        text: m.message,
        uid: m.from,
        animationCrtl: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0),
        ),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenSocketMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
      text: payload['message'],
      uid: payload['from'],
      animationCrtl: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationCrtl.forward();
  }

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
              child: Text(
                chatService.userTo.name.substring(0, 2).toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(),
            Text(
              chatService.userTo.name,
              style: const TextStyle(
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
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
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
      uid: authService.user.uid,
      animationCrtl: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200,
        ),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationCrtl.forward();

    setState(() {
      _isWritting = false;
    });

    socketService.emit('mensaje-personal', {
      'from': authService.user.uid,
      'to': chatService.userTo.uid,
      'message': texto
    });
  }

  @override
  void dispose() {
    //Clear messages instances
    for (ChatMessage message in _messages) {
      message.animationCrtl.dispose();
    }

    // Off del socket
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
