import 'package:flutter/material.dart';
import 'package:teacher_mate/src/pages/mobile/settings_page.dart';
import 'package:teacher_mate/src/widgets/mobile/wrapper/modal_bottom_sheet_wrapper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetScaffoldWrapper(
        title: 'Calendar settings', child: SettingsPage());
  }
}
