import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/bloc/config_bloc/config_bloc.dart';
import 'package:teacher_mate/src/util/url_util.dart';
import 'package:teacher_mate/src/widgets/shared/app_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/widgets/shared/text_form_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc, ConfigState>(
      listenWhen: (p, c) => p.isConnected != c.isConnected,
      listener: (context, state) {
        if (!state.isConnected) {
          _showNointernatConnection(context);
          return;
        }
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                textDirection: TextDirection.ltr,
                                text: const TextSpan(
                                  text: 'Teacher',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Mate',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              'Enter the code',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                child: TextFormFieldWidget(
                                    textAlign: TextAlign.center,
                                    onChange: (text) {
                                      setState(() {
                                        code = text;
                                      });
                                      context
                                          .read<AuthBloc>()
                                          .add(AuthUpdateCodeEvent(code));
                                      log(text);
                                      return code;
                                    },
                                    hintText: 'code')),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 150,
                              child: AppButton.settings(
                                label: 'Get the code',
                                iconColor: Colors.blue,
                                icon: Icons.telegram,
                                onTap: () {
                                  UrlUtils.openBot();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppButton.base(
                              label: 'Continue',
                              onTap: code.isNotEmpty
                                  ? () {
                                      context
                                          .read<AuthBloc>()
                                          .add(const AuthGetTokenEvent());
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showNointernatConnection(BuildContext context) {
  showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (BuildContext context) {
      return const NoInternetConnectionDialog();
    },
  );
}

class NoInternetConnectionDialog extends StatelessWidget {
  const NoInternetConnectionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 550, maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.signal_wifi_off,
                  size: 50,
                  color: Colors.black12,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Internet access is required for registration',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 24,
                ),
                AppButton.base(
                  label: 'Try again',
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      );
}
