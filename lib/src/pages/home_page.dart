import 'package:flutter/widgets.dart';
import 'package:teacher_mate/src/widgets/calendar_base_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const CalendarBaseWidget();
  }
}
