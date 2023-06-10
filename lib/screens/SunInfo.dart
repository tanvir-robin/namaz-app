import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class SunInfo extends StatelessWidget {
  SunInfo({required this.sunrise, required this.sunset});

  final String sunrise;
  final String sunset;
  String getTime(int x) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(x * 1000);
    String f = DateFormat('jm').format(date);
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          'assets/sunrise1.png',
          height: 80,
          //width: 20,
        ),
        Container(
          alignment: Alignment.center,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sun Rise',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                sunrise,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 30,
          // child: VerticalDivider(),
        ),
        Image.asset(
          'assets/sunset (1).png',
          height: 120,
          //width: 20,
        ),
        Container(
          alignment: Alignment.center,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sun Set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sunset, style: const TextStyle(fontSize: 13)),
            ],
          ),
        )
      ],
    );
  }
}
