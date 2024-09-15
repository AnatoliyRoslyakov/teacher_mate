import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/core/router/app_router.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/resource/svgs.dart';
import 'package:teacher_mate/src/widgets/shared/app_button.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppButton.settings(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  label: 'My students list',
                  icon: SvgPicture.asset(
                    Svgs.users,
                    color: AppColors.mainColor,
                  ),
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
                    label: 'Calendar settings',
                    icon: SvgPicture.asset(
                      Svgs.settings,
                      color: AppColors.mainColor,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(MobileRoutes.settings.path);
                    }),
                const SizedBox(
                  height: 10,
                ),
                AppButton.settings(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  label: 'Logout',
                  icon: SvgPicture.asset(
                    Svgs.logout,
                    color: Colors.red,
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthEvent.logout());
                  },
                ),
                const DividerTitleWidget(
                  title: 'Soon',
                  height: 8,
                ),
                Opacity(
                  opacity: 0.5,
                  child: AppButton.settings(
                      backgroundColor: Colors.white.withOpacity(0.4),
                      label: 'Financial analysis',
                      icon: SvgPicture.asset(
                        Svgs.chart,
                        color: AppColors.mainColor,
                      ),
                      onTap: () {}),
                ),
                const SizedBox(
                  height: 10,
                ),
                Opacity(
                  opacity: 0.5,
                  child: AppButton.settings(
                      backgroundColor: Colors.white.withOpacity(0.4),
                      label: 'Push Notifications',
                      icon: SvgPicture.asset(
                        Svgs.bell,
                        color: AppColors.mainColor,
                      ),
                      onTap: () {}),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
