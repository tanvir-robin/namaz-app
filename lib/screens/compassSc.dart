import 'dart:math';

import 'package:challenge/widgtes/Loading.dart';
import 'package:flutter/material.dart';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class CompassSc extends StatefulWidget {
  const CompassSc({super.key});

  @override
  State<CompassSc> createState() => _CompassScState();
}

class _CompassScState extends State<CompassSc> with TickerProviderStateMixin {
  void permissionEnabler() {
    Permission.locationWhenInUse.status.then((value) {
      if (value.isDenied) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  late AnimationController controller;
  late Animation<double> animation;
  double xDirection = 0;

  @override
  void initState() {
    super.initState();
    permissionEnabler();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 58, 48, 240)),
        title: const Text(
          'Qibla Direction',
          style: TextStyle(
              fontFamily: 'Poppins-Regular',
              color: Color.fromARGB(255, 58, 48, 240),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            double? direction = snapshot.data!.heading;
            if (direction == null) {
              return const Text('No compass');
            }
            controller = AnimationController(
                vsync: this, duration: const Duration(milliseconds: 250));
            animation =
                Tween<double>(begin: xDirection, end: (2 * (pi / 180) * (-1)))
                    .animate(controller);
            xDirection = direction * (pi / 180) * (-1);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              child: Transform.rotate(
                  angle: direction * (pi / 180) * (-1),
                  child: Image.asset('assets/compassbg2.png')),
            );
          },
        ),
      ),
    );
  }
}
