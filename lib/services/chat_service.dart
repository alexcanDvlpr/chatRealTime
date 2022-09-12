import 'package:chat_realtime/global/environment.dart';
import 'package:chat_realtime/models/chat_messages_response.dart';
import 'package:chat_realtime/models/usuario.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario userTo;

  Future<List<Message>> getChatMessages(String userUid) async {
    final resp = await http.get(
      Uri.parse('${Environment.apiUrl}/messages/$userUid'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? "",
      },
    );

    final messagesRes = chatMessagesResponseFromJson(resp.body);

    return messagesRes.messages;
  }
}
