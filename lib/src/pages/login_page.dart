import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/router/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//           onPressed: () {
//             context.go(MobileRoutes.home.path);
//           },
//           child: const Icon(Icons.turn_right)),
//     );
//   }
// }

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final showKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.token.isNotEmpty) {
        //   context.read<AuthBloc>().add(const AuthInitEvent());
        // }
      },
      builder: (context, state) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 126,
                  ),
                  const SizedBox(
                    height: 76,
                  ),
                  const Text(
                    'Введи код',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 40,
                    width: 240,
                    child: TextFormField(
                      onChanged: (value) {
                        context
                            .read<AuthBloc>()
                            .add(AuthUpdateCodeEvent(value));
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        // fillColor: context.colors.secondaryElement,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 15, right: 15),
                        // hintText: context.localization.loginField,
                        // hintStyle: AppTextStyle.appButton1.copyWith(
                        //   color: context.colors.white,
                        //   fontSize: 15,
                        // ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      height: 32,
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {
                            UrlUtils.openBot();
                          },
                          child: const Text('go'))
                      // SecondaryButton.normal(
                      //   label: context.localization.loginGetCode,
                      //   fontSize: 12,
                      //   onTap: () {
                      //     UrlUtils.openBot();
                      //   },
                      // ),
                      ),
                  if (!showKeyboard) ...[
                    const SizedBox(
                      height: 108,
                    ),
                    SizedBox(
                        height: 40,
                        width: 208,
                        child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthGetTokenEvent());
                            },
                            child: const Text('next'))),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UrlUtils {
  // tgBot: tg:resolve?domain=finance_auth_bot
// tgDownload: https://play.google.com/store/apps/details?id=org.telegram.messenger

  static Future<void> openBot() async {
    final Uri url = Uri.parse('tg://resolve?domain=teacher_mate_bot');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
