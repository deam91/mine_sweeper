import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({Key? key, required this.time, required this.header})
      : super(key: key);

  final String time;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          header,
          style: const TextStyle(color: Colors.black45),
        ),
      ],
    );
  }
}
