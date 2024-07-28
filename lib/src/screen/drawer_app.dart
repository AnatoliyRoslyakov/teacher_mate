import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/router/app_router.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';

class DrawerApp extends StatelessWidget {
  final bool mobile;
  const DrawerApp({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    log('message');
    return Drawer(
        backgroundColor: Colors.white,
        width: mobile ? null : 400,
        child: SafeArea(
          child: mobile
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
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
                      )
                    ],
                  ),
                )
              : CalendarSettingsWidget(),
        ));
  }
}
