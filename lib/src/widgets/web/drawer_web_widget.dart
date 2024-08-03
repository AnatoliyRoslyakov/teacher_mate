import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';
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
  bool customTileExpanded = true;
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
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
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
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.logout,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
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
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Settings',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w500),
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
                      color: Colors.amber,
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
            children: [InfoPanelWidget()],
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
