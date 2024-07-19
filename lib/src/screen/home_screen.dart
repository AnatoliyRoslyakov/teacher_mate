import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:teacher_mate/src/pages/mobile/mobile_home_page.dart';
import 'package:teacher_mate/src/pages/web/web_home_page.dart';
import 'package:teacher_mate/src/widgets/shared/drawer_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void deleteLesson({required String id}) {
    context.read<LessonBloc>().add(LessonEvent.delete(id));
  }

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
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            )
          : MobileHomePage(
              deleteLesson: deleteLesson,
              scaffoldKey: _scaffoldKey,
            ),
    );
  }
}
