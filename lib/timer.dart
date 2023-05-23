import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimerDemo extends StatefulWidget {
  CountdownTimerDemo({super.key, required this.duration});
  Duration duration;
  @override
  State<CountdownTimerDemo> createState() => _CountdownTimerDemoState();
}

class _CountdownTimerDemoState extends State<CountdownTimerDemo> {
  // Step 2
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  /// Timer related methods ///
  // Step 3
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => widget.duration = Duration(days: 5));
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = widget.duration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        widget.duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(widget.duration.inDays);
    // Step 7
    final hours = strDigits(widget.duration.inHours.remainder(24));
    final minutes = strDigits(widget.duration.inMinutes.remainder(60));
    final seconds = strDigits(widget.duration.inSeconds.remainder(60));
    return Column(
      children: [
        Text(
          '$hours:$minutes:$seconds',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
        // SizedBox(height: 20),
        // // Step 9
        // ElevatedButton(
        //   onPressed: startTimer,
        //   child: Text(
        //     'Start',
        //     style: TextStyle(
        //       fontSize: 30,
        //     ),
        //   ),
        // ),
        // // Step 10
        // ElevatedButton(
        //   onPressed: () {
        //     if (countdownTimer == null || countdownTimer!.isActive) {
        //       stopTimer();
        //     }
        //   },
        //   child: Text(
        //     'Stop',
        //     style: TextStyle(
        //       fontSize: 30,
        //     ),
        //   ),
        // ),
        // // Step 11
        // ElevatedButton(
        //     onPressed: () {
        //       resetTimer();
        //     },
        //     child: Text(
        //       'Reset',
        //       style: TextStyle(
        //         fontSize: 30,
        //       ),
        //     ))
      ],
    );
  }
}
