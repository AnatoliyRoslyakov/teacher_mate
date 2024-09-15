import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class InfoPanelWidget extends StatelessWidget {
  const InfoPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.mainColor,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTextButton(Icons.info, 'О нас', () {}),
              _buildTextButton(Icons.contact_mail, 'Контакты', () {}),
              Expanded(
                  child: _buildTextButton(Icons.support, 'Поддержка', () {})),
            ],
          ),

          const Divider(
            color: Colors.black87,
            thickness: 1,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: null,
                child: Image.asset(
                  'image.png',
                  height: 70,
                ),
              ),
            ],
          ),

          // ),
        ],
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        color: Colors.black87,
        icon,
      ),
      label: Text(
        label,
        style: AppTextStyle.b4f14,
      ),
    );
  }
}
