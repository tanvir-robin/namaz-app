import 'package:flutter/material.dart';
import './models/namaz_times/namaz_times.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateWidget extends StatefulWidget {
  DateWidget({super.key, required this.data});
  NamazTimes data;
  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  int ind = int.parse(DateFormat.d().format(DateTime.now()).toString()) - 1;

  String getHijri(String date) {
    String month = date.split('-')[1];
    if (month == '01') {
      return '${date.split('-')[0]} Muḥarram, ${date.split('-')[2]}';
    } else if (month == '02') {
      return '${date.split('-')[0]} Ṣafar, ${date.split('-')[2]}';
    } else if (month == '03') {
      return '${date.split('-')[0]} Rabī\' al-awwal, ${date.split('-')[2]}';
    } else if (month == '04') {
      return '${date.split('-')[0]} Rabī\' ath-thānī, ${date.split('-')[2]}';
    } else if (month == '05') {
      return '${date.split('-')[0]} Jumādá al-ūlá, ${date.split('-')[2]}';
    } else if (month == '06') {
      return '${date.split('-')[0]} Jumādá al-ākhirah, ${date.split('-')[2]}';
    } else if (month == '07') {
      return '${date.split('-')[0]} Rajab, ${date.split('-')[2]}';
    } else if (month == '08') {
      return '${date.split('-')[0]} Sha‘bān, ${date.split('-')[2]}';
    } else if (month == '09') {
      return '${date.split('-')[0]} Ramaḍān, ${date.split('-')[2]}';
    } else if (month == '10') {
      return '${date.split('-')[0]} Shawwāl, ${date.split('-')[2]}';
    } else if (month == '11') {
      return '${date.split('-')[0]} Dhū al-Qa‘dah, ${date.split('-')[2]}';
    } else if (month == '12') {
      return '${date.split('-')[0]} Dhū al-Ḥijjah, ${date.split('-')[2]}';
    }
    return date;
  }

  String getGorgeon(String date) {
    String month = date.split('-')[1];
    if (month == '01') {
      return '${date.split('-')[0]} January, ${date.split('-')[2]}';
    } else if (month == '02') {
      return '${date.split('-')[0]} February, ${date.split('-')[2]}';
    } else if (month == '03') {
      return '${date.split('-')[0]} March, ${date.split('-')[2]}';
    } else if (month == '04') {
      return '${date.split('-')[0]} April, ${date.split('-')[2]}';
    } else if (month == '05') {
      return '${date.split('-')[0]} May, ${date.split('-')[2]}';
    } else if (month == '06') {
      return '${date.split('-')[0]} June, ${date.split('-')[2]}';
    } else if (month == '07') {
      return '${date.split('-')[0]} July, ${date.split('-')[2]}';
    } else if (month == '08') {
      return '${date.split('-')[0]} August, ${date.split('-')[2]}';
    } else if (month == '09') {
      return '${date.split('-')[0]} September, ${date.split('-')[2]}';
    } else if (month == '10') {
      return '${date.split('-')[0]} October, ${date.split('-')[2]}';
    } else if (month == '11') {
      return '${date.split('-')[0]} November, ${date.split('-')[2]}';
    } else if (month == '12') {
      return '${date.split('-')[0]} December, ${date.split('-')[2]}';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          getHijri(widget.data.data![ind].date!.hijri!.date.toString()),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
            getGorgeon(widget.data.data![ind].date!.gregorian!.date.toString()),
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }
}
