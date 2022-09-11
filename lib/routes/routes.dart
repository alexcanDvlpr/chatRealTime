import 'package:chat_realtime/pages/chat_page.dart';
import 'package:chat_realtime/pages/loading_page.dart';
import 'package:chat_realtime/pages/login_page.dart';
import 'package:chat_realtime/pages/register_page.dart';
import 'package:chat_realtime/pages/usuarios_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => const ChatPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'loading': (_) => const LoadingPage()
};
