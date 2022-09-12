import 'package:chat_realtime/helpers/show_alerts.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:chat_realtime/services/socket_service.dart';
import 'package:chat_realtime/widgets/btn_azul.dart';
import 'package:chat_realtime/widgets/custom_input.dart';
import 'package:chat_realtime/widgets/labels.dart';
import 'package:chat_realtime/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                  title: "Regístrate",
                ),
                _Form(),
                const Labels(
                  nameRoute: "Inicia sesión con tu cuenta",
                  route: 'login',
                  isLogin: false,
                ),
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
  final nameCtrl = TextEditingController();
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
            icon: Icons.perm_identity_outlined,
            placeholder: "Nombre y apellidos",
            textController: nameCtrl,
          ),
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
            text: "Regístrate",
            callBackFunction: authService.authenticating
                ? null
                : () async {
                    final isRegistered = await authService.signUp(nameCtrl.text,
                        emailCtrl.text.trim(), passwordCtrl.text.trim());
                    if (isRegistered == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      showAlert(context, "Registro incorrecto", isRegistered);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
