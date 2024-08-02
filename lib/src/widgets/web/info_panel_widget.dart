import 'package:flutter/material.dart';

class InfoPanelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Текстовые кнопки с иконками
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTextButton(Icons.info, 'О нас', () {}),
              _buildTextButton(Icons.contact_mail, 'Контакты', () {}),
              _buildTextButton(Icons.support, 'Поддержка', () {}),
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

          // const Divider(
          //   color: Colors.black87,
          //   thickness: 1,
          // ),

          // // Дополнительная информация
          // const Text(
          //   'Дополнительная информация:',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16.0,
          //   ),
          // ),
          // const SizedBox(height: 10.0),
          // const Text(
          //   'Мы стремимся предоставлять вам лучшие услуги. '
          //   'Если у вас есть вопросы или предложения, не стесняйтесь обращаться к нам.',
          //   style: TextStyle(color: Colors.black87),
          // ),
        ],
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black87),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}
