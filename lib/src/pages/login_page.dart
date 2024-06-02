import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/router/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            context.go(MobileRoutes.home.path);
          },
          child: const Icon(Icons.turn_right)),
    );
  }
}
