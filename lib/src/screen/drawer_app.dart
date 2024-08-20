import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/mobile/drawer_mobile_widget.dart';
import 'package:teacher_mate/src/widgets/web/drawer_web_widget.dart';

class DrawerApp extends StatelessWidget {
  final bool mobile;
  const DrawerApp({super.key, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Drawer(
              backgroundColor: Colors.white.withOpacity(0.7),
              width: mobile ? null : 400,
              child: mobile
                  ? const DrawerMobileWidget()
                  : DrawerWebWidget(mobile: mobile)),
        ));
  }
}
