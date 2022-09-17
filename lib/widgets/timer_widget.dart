import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/colors.dart';
import '../providers/timer.dart';

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: ref.watch(startStopTimer));
    final total_seg = duration.inSeconds; // 79 - 1 min 19 seconds
    final hours = total_seg ~/ 3600;
    final rest_seg = total_seg - (hours * 3600);
    final hours_string =
        hours.toString().length < 2 ? '0$hours' : hours.toString();

    final minutes = rest_seg ~/ 60;
    final minutes_string =
        minutes.toString().length < 2 ? '0$minutes' : minutes.toString();
    final seconds = rest_seg - (minutes * 60);
    final seconds_string =
        seconds.toString().length < 2 ? '0$seconds' : seconds.toString();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.timer_rounded,
            color: Colors.white,
          ),
          Text(
            '$hours_string:$minutes_string:$seconds_string',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
