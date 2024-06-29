import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:teacher_mate/src/entity/calendar_settings.dart';

class CalendarSettingsWidget extends StatefulWidget {
  const CalendarSettingsWidget({
    super.key,
  });
  @override
  _CalendarSettingsWidgetState createState() => _CalendarSettingsWidgetState();
}

class _CalendarSettingsWidgetState extends State<CalendarSettingsWidget> {
  double minutesGrid = 1.0;
  int startHour = 9;
  int endHour = 22;
  int viewDay = 7;
  bool startOfWeek = true;

  @override
  void initState() {
    final CalendarSettingsEntity settings =
        context.read<CalendarBloc>().state.calendarSettings;
    minutesGrid = settings.minutesGrid;
    startHour = settings.startHour;
    endHour = settings.endHour;
    viewDay = settings.viewDay;
    startOfWeek = settings.startOfWeek;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 350,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Setting up a calendar',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grid (minutes):'),
                  DropdownButton<double>(
                    value: minutesGrid,
                    items: const [
                      DropdownMenuItem(
                        value: 0.5,
                        child: Text('30 minutes'),
                      ),
                      DropdownMenuItem(
                        value: 1.0,
                        child: Text('60 minutes'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        minutesGrid = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start day:'),
                  DropdownButton<int>(
                    value: startHour,
                    items: List.generate(16, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('$index'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        startHour = value!;
                      });
                    },
                  ),
                ],
              ),
              // End Hour
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('End day:'),
                  DropdownButton<int>(
                    value: endHour,
                    items: List.generate(8, (index) {
                      return DropdownMenuItem(
                        value: 16 + index,
                        child: Text('${16 + index}'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        endHour = value!;
                      });
                    },
                  ),
                ],
              ),
              // View Day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of days:'),
                  DropdownButton<int>(
                    value: viewDay,
                    items: List.generate(15, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        viewDay = value!;
                      });
                    },
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Start on Monday:'),
                  Switch(
                    value: startOfWeek,
                    onChanged: (value) {
                      setState(() {
                        startOfWeek = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<CalendarBloc>().add(CalendarEvent.settings(
                      minutesGrid, startHour, endHour, viewDay, startOfWeek));
                },
                child: const Text('Save settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
