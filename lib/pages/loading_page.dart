import 'package:chat_realtime/pages/login_page.dart';
import 'package:chat_realtime/pages/usuarios_page.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:chat_realtime/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ((context, snapshot) {
          return const Center(
            child: Text("Espere..."),
          );
        }),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);

    final authenticated = await authService.isLoggedIn();

    if (authenticated) {
      socketService.connect();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    }
  }
}
