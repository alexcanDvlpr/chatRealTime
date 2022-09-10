import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String nameRoute;
  final String route;
  final bool isLogin;

  const Labels(
      {super.key,
      required this.nameRoute,
      required this.route,
      this.isLogin = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
            visible: isLogin,
            child: const Text(
              "¿No tienes cuenta?",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
            child: Text(
              nameRoute,
              style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
