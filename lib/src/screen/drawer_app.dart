import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/bloc/user_details_bloc/user_details_bloc.dart';
import 'package:teacher_mate/src/router/app_router.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';

class DrawerApp extends StatelessWidget {
  final bool mobile;
  const DrawerApp({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        width: mobile ? null : 400,
        child: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserInfoWidget(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            context.push(MobileRoutes.settings.path);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Calendar settings'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            context.push(MobileRoutes.students.path);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.group),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('My students list'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEvent.logout());
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : CalendarSettingsWidget());
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
      return Container(
        height: 170,
        decoration: const BoxDecoration(color: Colors.amber),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                      backgroundColor: Colors.white, child: Icon(Icons.person)),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text(
                            state.tgName,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.send,
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
