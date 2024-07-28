import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teacher_mate/src/pages/mobile/mobile_home_page.dart';
import 'package:teacher_mate/src/pages/web/web_home_page.dart';
import 'package:teacher_mate/src/screen/drawer_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerApp(
        mobile: !kIsWeb,
      ),
      backgroundColor: Colors.white,
      // виджеты -- сила, в зависимости от платформы будет меняться только компановка
      body: kIsWeb
          ? WebHomePage(
              scaffoldKey: _scaffoldKey,
            )
          : MobileHomePage(
              scaffoldKey: _scaffoldKey,
            ),
    );
  }
}
