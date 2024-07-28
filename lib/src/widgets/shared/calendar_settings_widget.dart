import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/settings_bloc/settings_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarSettingsWidget extends StatefulWidget {
  const CalendarSettingsWidget({
    super.key,
  });
  @override
  _CalendarSettingsWidgetState createState() => _CalendarSettingsWidgetState();
}

class _CalendarSettingsWidgetState extends State<CalendarSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 200,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        SettingsCardWidget(
                            title: 'Grid',
                            icon: Icons.border_horizontal,
                            initialValue: state.minutesGrid,
                            valueList: const [0.5, 1.0],
                            textList: const ['30 minutes', '60 minutes'],
                            onChanged: (String? value) {
                              context.read<SettingsBloc>().add(
                                  SettingsEvent.grid(
                                      minutesGrid: double.parse(value!)));
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        SettingsCardWidget(
                            title: 'Start time',
                            icon: Icons.access_time,
                            initialValue: state.startDay,
                            valueList: List.generate(16, (index) => index + 1),
                            textList: List.generate(
                                16, (index) => '${(index + 1)} hours'),
                            onChanged: (String? value) {
                              context.read<SettingsBloc>().add(
                                  SettingsEvent.startDay(
                                      startDay: int.parse(value!)));
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        SettingsCardWidget(
                            title: 'End time',
                            icon: Icons.access_time,
                            initialValue: state.endDay,
                            valueList: List.generate(8, (index) => index + 16),
                            textList: List.generate(
                                16, (index) => '${(index + 16)} hours'),
                            onChanged: (String? value) {
                              context.read<SettingsBloc>().add(
                                  SettingsEvent.endDay(
                                      endDay: int.parse(value!)));
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Column(
                        children: [
                          SettingsCardWidget2(
                              title: '3 Days',
                              icon: Icons.event,
                              select: state.three,
                              onChanged: (bool value) {
                                context.read<SettingsBloc>().add(
                                    SettingsEvent.threeDays(threeDays: value));
                              }),
                          const SizedBox(
                            height: 8,
                          ),
                          SettingsCardWidget2(
                              title: 'Week',
                              icon: Icons.date_range,
                              select: state.week,
                              onChanged: (bool value) {
                                context
                                    .read<SettingsBloc>()
                                    .add(SettingsEvent.week(week: value));
                              }),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 12),
                            child: SettingsCardWidget(
                                inactive: state.week || state.three,
                                title: 'Date range',
                                icon: Icons.event_note,
                                initialValue: state.viewDays,
                                valueList:
                                    List.generate(15, (index) => index + 1),
                                textList: List.generate(
                                    15, (index) => '${(index + 1)} day'),
                                onChanged: (String? value) {
                                  context.read<SettingsBloc>().add(
                                      SettingsEvent.viewDays(
                                          viewDays: int.parse(value!)));
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Save settings'),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<SettingsBloc>()
                              .add(const SettingsEvent.defaultSettings());
                        },
                        child: const Icon(Icons.repeat),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

class SettingsCardWidget2 extends StatelessWidget {
  final bool select;
  final String title;
  final IconData icon;
  final void Function(bool) onChanged;
  const SettingsCardWidget2({
    super.key,
    required this.select,
    required this.title,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(title, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Switch(
            value: select,
            onChanged: onChanged,
          ),
        ]),
      ),
    );
  }
}

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final num initialValue;
  final List<num> valueList;
  final List<String> textList;
  final bool decoration;
  final bool inactive;
  final void Function(String?) onChanged;
  const SettingsCardWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.initialValue,
      required this.valueList,
      required this.textList,
      required this.onChanged,
      this.decoration = false,
      this.inactive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration
          ? BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12))
          : null,
      child: Padding(
        padding: decoration ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 5),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              items: List.generate(valueList.length, (i) {
                return DropdownMenuItem(
                  value: valueList[i].toString(),
                  child: Text(textList[i]),
                );
              }),
              value: initialValue.toString(),
              onChanged: inactive
                  ? null
                  : (value) {
                      onChanged.call(value);
                    },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 160,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.expand_more,
                ),
                iconSize: 20,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 160, //double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                offset: const Offset(0, -10),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all(6),
                  thumbVisibility: WidgetStateProperty.all(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
