import 'package:flutter/material.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';
import 'package:teacher_mate/src/widgets/shared/student_list_widget.dart';

class TogglePanelWidget extends StatefulWidget {
  const TogglePanelWidget({super.key});

  @override
  State<TogglePanelWidget> createState() => _TogglePanelWidgetState();
}

class _TogglePanelWidgetState extends State<TogglePanelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> widthAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    widthAnimation = Tween<double>(
      begin: _minPanelWidth,
      end: _maxPanelWidth,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addListener(() {
      setState(() {
        _panelWidth = widthAnimation.value;
      });
    });
  }

  double _panelWidth = 0.0;
  final double _maxPanelWidth = 400.0;
  final double _minPanelWidth = 0.0;
  final double _fadeThreshold = 200.0;

  void _togglePanel() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePanel,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double fadeValue = 1.0;
            if (_panelWidth < _fadeThreshold) {
              fadeValue = (_panelWidth - _minPanelWidth - 100) /
                  (_fadeThreshold - _minPanelWidth);
            }
            return Row(
              children: [
                Center(
                  child: Container(
                    width: 12,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        _controller.status == AnimationStatus.completed
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                  height: double.infinity,
                  color: Colors.grey.withOpacity(0.3),
                ),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(fadeValue),
                  child: Container(
                    width: _panelWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.7),
                      const Color.fromARGB(255, 159, 175, 255)
                          .withOpacity(0.001),
                    ])),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 55,
                          ),
                          Text(
                            'List of students',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.b5f18,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Expanded(
                              child: StudentListWidget(
                            toggle: true,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
