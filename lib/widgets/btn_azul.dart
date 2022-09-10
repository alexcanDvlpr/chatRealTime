import 'package:flutter/material.dart';

class BtnAzul extends StatelessWidget {
  final dynamic callBackFunction;
  final String text;

  const BtnAzul({
    super.key,
    required this.text,
    required this.callBackFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callBackFunction,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
