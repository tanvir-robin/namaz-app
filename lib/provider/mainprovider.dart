import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/namaz_times/namaz_times.dart';

import '../models/namaz_times/namaz_times.dart';

class MainProvider extends ChangeNotifier {
  late NamazTimes NamazTimedata;
  int ind = int.parse(DateFormat.d().format(DateTime.now()).toString()) - 1;

  void SetNamazTimes(var jsonData) {
    NamazTimedata = NamazTimes.fromJson(jsonData);
    print('Data has been set');
  }
}
