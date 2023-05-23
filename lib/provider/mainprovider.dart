import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class MainProvider extends ChangeNotifier {
  late Position _position;

  // void setPosition() async {
  //   _position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print(_position.latitude);
  //   print(_position.longitude);
  // }
}
