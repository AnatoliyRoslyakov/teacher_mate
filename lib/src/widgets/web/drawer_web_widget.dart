import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';
import 'package:teacher_mate/src/theme/resource/svgs.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
import 'package:teacher_mate/src/widgets/shared/user_info_widget.dart';
import 'package:teacher_mate/src/widgets/web/info_panel_widget.dart';

class DrawerWebWidget extends StatefulWidget {
  const DrawerWebWidget({
    super.key,
    required this.mobile,
  });

  final bool mobile;

  @override
  State<DrawerWebWidget> createState() => _DrawerWebWidgetState();
}

class _DrawerWebWidgetState extends State<DrawerWebWidget> {
  bool customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              UserInfoWidget(
                mobile: widget.mobile,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                  title: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 242, 242, 242),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.settings,
                            size: 20,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Settings',
                        style: AppTextStyle.b5f15,
                      ),
                    ],
                  ),
                  children: const [
                    CalendarSettingsWidget(),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      customTileExpanded = expanded;
                    });
                  },
                ),
              ),
              IconButtonWeb(
                onTap: () {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
                icon: SvgPicture.asset(
                  Svgs.logout,
                  height: 20,
                  color: Colors.red,
                ),
                title: 'Logout',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DividerTitleWidget(
                  title: 'Soon',
                  height: 8,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: IconButtonWeb(
                  onTap: () {},
                  icon: SvgPicture.asset(
                    Svgs.chart,
                    height: 20,
                    color: AppColors.mainColor,
                  ),
                  title: 'Financial analysis',
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: IconButtonWeb(
                  onTap: () {},
                  icon: SvgPicture.asset(
                    Svgs.bell,
                    height: 20,
                    color: AppColors.mainColor,
                  ),
                  title: 'Push Notifications',
                ),
              ),
            ],
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 242, 242),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.info,
                      size: 20,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Info',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            children: const [InfoPanelWidget()],
            onExpansionChanged: (bool expanded) {
              setState(() {
                customTileExpanded = !expanded;
              });
            },
          ),
        ),
      ],
    );
  }
}

class IconButtonWeb extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final String title;
  const IconButtonWeb({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 242, 242),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: icon,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: AppTextStyle.b5f15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
