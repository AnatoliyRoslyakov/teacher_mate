import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/mobile/drawer_mobile_widget.dart';
import 'package:teacher_mate/src/widgets/web/drawer_web_widget.dart';

class DrawerApp extends StatelessWidget {
  final bool mobile;
  const DrawerApp({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        width: mobile ? null : 400,
        child: mobile
            ? const DrawerMobileWidget()
            : DrawerWebWidget(mobile: mobile));
  }
}
