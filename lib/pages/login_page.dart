// ignore_for_file: use_build_context_synchronously

import 'package:chat_realtime/helpers/show_alerts.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:chat_realtime/services/socket_service.dart';
import 'package:chat_realtime/widgets/btn_azul.dart';
import 'package:chat_realtime/widgets/custom_input.dart';
import 'package:chat_realtime/widgets/labels.dart';
import 'package:chat_realtime/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(
                  title: "Messenger",
                ),
                _Form(),
                const Labels(nameRoute: "¡Crea una ahora!", route: 'register'),
                const Text(
                  "Terminos y Condiciones de uso.",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Email",
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.password_outlined,
            placeholder: "Contraseña",
            isPassword: true,
            textController: passwordCtrl,
          ),
          BtnAzul(
            text: "Iniciar Sesión",
            callBackFunction: authService.authenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final isLogged = await authService.signIn(
                        emailCtrl.text.trim(), passwordCtrl.text.trim());

                    if (isLogged) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      showAlert(context, "Error en el Login",
                          "Compruebe que sus credenciales son correctas!");
                    }
                  },
          ),
        ],
      ),
    );
  }
}
