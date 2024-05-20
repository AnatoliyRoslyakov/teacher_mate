import 'package:calendar/src/logic/calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:calendar/src/config/global_config.dart' as config;

/// Widget that show on time planner as the tasks
class TimePlannerTask extends StatelessWidget {
  final CalendarTask task;

  /// This will be happen when user tap on task, for example show a dialog or navigate to other page
  final Function? onTap;

  /// parameter to set space from left, to set it: config.cellWidth! * dateTime.day.toDouble()
  final double? leftSpace;

  /// parameter to set width of task, to set it: (config.cellWidth!.toDouble() * (daysDuration ?? 1)) -config.horizontalTaskPadding!
  final double? widthTask;

  /// Widget that show on time planner as the tasks
  const TimePlannerTask({
    super.key,
    this.leftSpace,
    this.widthTask,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ((config.cellHeight! * (task.dateTime.hour - config.startHour)) +
              ((task.dateTime.minutes * config.cellHeight!) / 60))
          .toDouble(),
      left:
          config.cellWidth! * task.dateTime.day.toDouble() + (leftSpace ?? 0.0),
      child: SizedBox(
        width: widthTask,
        child: Padding(
          padding:
              EdgeInsets.only(left: config.horizontalTaskPadding!.toDouble()),
          child: Material(
            elevation: 3,
            borderRadius: config.borderRadius,
            child: Stack(
              children: [
                InkWell(
                  onTap: onTap as void Function()? ?? () {},
                  child: Container(
                    height: ((task.minutesDuration.toDouble() *
                            config.cellHeight!) /
                        60),
                    width: (config.cellWidth!.toDouble()),
                    decoration: BoxDecoration(
                        borderRadius: config.borderRadius, color: task.color),
                    child: Center(
                      child: Text(task.title),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
