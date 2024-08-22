import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/core/router/app_router.dart';
import 'package:teacher_mate/src/widgets/shared/app_button.dart';
import 'package:teacher_mate/src/widgets/shared/user_info_widget.dart';

class DrawerMobileWidget extends StatelessWidget {
  const DrawerMobileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: const UserInfoWidget())),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppButton.settings(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  label: 'Calendar settings',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(MobileRoutes.settings.path);
                  }),
              const SizedBox(
                height: 10,
              ),
              AppButton.settings(
                backgroundColor: Colors.white.withOpacity(0.4),
                label: 'My students list',
                icon: Icons.group,
                onTap: () {
                  Navigator.pop(context);
                  context.push(MobileRoutes.students.path);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              AppButton.settings(
                backgroundColor: Colors.white.withOpacity(0.4),
                iconColor: Colors.red,
                label: 'Logout',
                icon: Icons.logout,
                onTap: () {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
