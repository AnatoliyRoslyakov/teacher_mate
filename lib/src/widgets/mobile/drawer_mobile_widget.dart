import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/router/app_router.dart';
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
        const UserInfoWidget(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppButton.settings(
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
