import 'package:flutter/material.dart';
import 'package:mine_sweeper/widgets/time_card.dart';

class Time extends StatelessWidget {
  const Time({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Finished in',
          style: TextStyle(fontSize: 40, color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeCard(time: hours_string, header: 'HOURS'),
            const SizedBox(
              width: 8,
            ),
            TimeCard(time: minutes_string, header: 'MINUTES'),
            const SizedBox(
              width: 8,
            ),
            TimeCard(time: seconds_string, header: 'SECONDS'),
          ],
        )
      ],
    );
  }
}
