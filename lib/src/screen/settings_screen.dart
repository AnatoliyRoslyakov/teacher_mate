import 'package:flutter/material.dart';
import 'package:teacher_mate/src/widgets/mobile/modal_bottom_sheet_wrapper.dart';
import 'package:teacher_mate/src/widgets/shared/calendar_settings_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ModalBottomSheetScaffoldWrapper(
        title: 'Calendar settings', child: CalendarSettingsWidget());
  }
}
