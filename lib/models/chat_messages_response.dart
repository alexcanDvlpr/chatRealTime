// To parse this JSON data, do
//
//     final chatMessagesResponse = chatMessagesResponseFromJson(jsonString);

import 'dart:convert';

ChatMessagesResponse chatMessagesResponseFromJson(String str) =>
    ChatMessagesResponse.fromJson(json.decode(str));

String chatMessagesResponseToJson(ChatMessagesResponse data) =>
    json.encode(data.toJson());

class ChatMessagesResponse {
  ChatMessagesResponse({
    required this.ok,
    required this.messages,
  });

  bool ok;
  List<Message> messages;

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) =>
      ChatMessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  String from;
  String to;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
