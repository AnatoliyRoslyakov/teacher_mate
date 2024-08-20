import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

import 'package:teacher_mate/src/router/app_router.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> sliderText = {
      'Добро пожаловать!':
          'Ваш личный помошник для планирования занятий с вашими учениками!',
      'Планирование':
          'Удобное планирование и отслеживание занятий с вашими учениками с помощью встроенного календаря',
      'Занятия':
          'Быстрое создание и редактирование занятий с вашими учениками в пару кликов',
      'Ученики':
          'Список всех текущих учеников в одном месте. Заполните информацию о них, чтобы не потерять'
    };

    return CircularMotionAnimation(
      web: kIsWeb,
      startAngel: 0, // 0, pi/2, 3pi/4, pi,
      step: 4, // step >= 1
      scale: 1.4,
      sliderContent: List.generate(
          sliderText.length,
          (i) => SliderContent(
              title: sliderText.keys.toList()[i],
              description: sliderText.values.toList()[i])),
    );
  }
}

class SliderContent extends StatelessWidget {
  final String title;
  final String description;
  const SliderContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(textAlign: TextAlign.center, description)
      ],
    );
  }
}

class CircularMotionAnimation extends StatefulWidget {
  final double startAngel;
  final int step;
  final double scale;
  final List<MaterialColor> colors;
  final Duration duration;
  final List<Widget> sliderContent;
  final Curve animation;
  final bool web;
  const CircularMotionAnimation(
      {super.key,
      this.startAngel = 0,
      this.step = 4,
      this.scale = 1,
      this.colors = const [
        Colors.amber,
        Colors.green,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
      this.duration = const Duration(milliseconds: 1000),
      required this.sliderContent,
      this.animation = Curves.easeInOutCubicEmphasized,
      required this.web});

  @override
  State<CircularMotionAnimation> createState() =>
      _CircularMotionAnimationState();
}

class _CircularMotionAnimationState extends State<CircularMotionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentAngle; // 0, pi/2, 3pi/4, pi
  late int _step; // step >= 1
  late double _angleStep;
  late int indexColor;
  late double _scale;
  late List<MaterialColor> _colors;
  late double startAngle;
  late double endAngle;

  @override
  void initState() {
    super.initState();
    indexColor = 0;
    _colors = widget.colors;
    _scale = widget.scale;
    _step = widget.step;
    _currentAngle = widget.startAngel;
    _angleStep = 2 * pi / _step;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });
  }

  void _animateQuarter({bool reverse = false}) {
    startAngle = _currentAngle;
    endAngle = _currentAngle + (reverse ? -_angleStep : _angleStep);
    _animation = Tween<double>(
      begin: startAngle,
      end: endAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animation,
    ));
    reverse ? indexColor-- : indexColor++;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(
                        25 * cos(_currentAngle + pi),
                        -50 * sin(_currentAngle + pi),
                      ),
                      child: Container(
                        width: 180 * _scale,
                        height: 180 * _scale,
                        decoration: BoxDecoration(
                          color: _colors[indexColor].withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _colors[indexColor].withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        20 * cos(_currentAngle),
                        20 * sin(_currentAngle),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          clipBehavior: Clip.antiAlias,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                            child: Container(
                              width: 200 * _scale,
                              height: 200 * _scale,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(69, 255, 255, 255),
                                    width: 4),
                                gradient: RadialGradient(
                                  colors: [
                                    _colors[indexColor].withOpacity(0.5),
                                    _colors[indexColor].withOpacity(0.2),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )),
                    ),
                    Transform.translate(
                      offset: Offset(
                        130 * _scale * cos(_currentAngle),
                        140 * _scale * sin(_currentAngle),
                      ),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _colors[indexColor].withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _colors[indexColor].withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        110 * _scale * cos(_currentAngle + 3 * pi / 6),
                        110 * _scale * sin(_currentAngle + 3 * pi / 5),
                      ),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _colors[indexColor].withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _colors[indexColor].withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.web ? 200 : null,
                child: CarouselSlider(
                  items: widget.sliderContent,
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: widget.web ? 10 : 16 / 9,
                    enlargeFactor: 0.6,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    initialPage: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    indexColor == 0
                        ? const SizedBox.shrink()
                        : TextButton(
                            onPressed: indexColor != 0
                                ? () {
                                    buttonCarouselController.previousPage(
                                        duration: widget.duration,
                                        curve: widget.animation);
                                    _animateQuarter(reverse: true);
                                  }
                                : null,
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300),
                            )),
                    CircularStepProgressIndicator(
                      height: 70,
                      width: 70,
                      totalSteps: _step,
                      currentStep: indexColor + 1,
                      stepSize: 4,
                      padding: pi / 10,
                      unselectedColor: Colors.transparent,
                      selectedColor: _colors[indexColor],
                      roundedCap: (_, isSelected) => isSelected,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(200),
                          onTap: _step != indexColor + 1
                              ? () {
                                  buttonCarouselController.nextPage(
                                      duration: widget.duration,
                                      curve: widget.animation);
                                  _animateQuarter.call();
                                }
                              : () {
                                  context.go(MobileRoutes.login.path);
                                },
                          child: CircleAvatar(
                            backgroundColor: _colors[indexColor],
                            child: _step == indexColor + 1
                                ? const Text(
                                    'GO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
