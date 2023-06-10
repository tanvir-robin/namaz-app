import 'package:challenge/noti.dart';
import 'package:challenge/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import './models/namaz_times/namaz_times.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.data});
  final NamazTimes data;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ind = int.parse(DateFormat.d().format(DateTime.now()).toString()) - 1;
  Duration upcoming = Duration();
  bool calculate = true;
  String wakt = '';
  var myF;
  List times = [];

  String cropeIt(String iso, String wakt, int id) {
    String cutted =
        iso.split(' ')[0].substring(0, iso.split(' ')[0].length - 6);
    Noti.scheduler(
        id: id,
        title: '$wakt Starting',
        body: 'You can start your $wakt from now',
        fln: flutterLocalNotificationsPlugin,
        time: DateTime.parse(cutted));
    return cutted;
  }

  Future<bool> processDates() async {
    times.add(cropeIt(
        widget.data.data![ind].timings!.sunrise.toString(), 'Sunrise', 1));
    times.add(
        cropeIt(widget.data.data![ind].timings!.fajr.toString(), 'Fajr', 2));
    times.add(
        cropeIt(widget.data.data![ind].timings!.dhuhr.toString(), 'Dhur', 3));
    times
        .add(cropeIt(widget.data.data![ind].timings!.asr.toString(), 'Asr', 4));
    times.add(cropeIt(
        widget.data.data![ind].timings!.sunset.toString(), 'Sunset', 5));
    times.add(cropeIt(
        widget.data.data![ind].timings!.maghrib.toString(), 'Maghrib', 6));
    times.add(
        cropeIt(widget.data.data![ind].timings!.isha.toString(), 'Isha', 7));
    times.add(cropeIt(
        widget.data.data![ind + 1].timings!.sunrise.toString(), 'nsunrise', 8));

    for (int i = 0; i < times.length; i++) {
      DateTime converted = DateTime.parse(times[i]);

      if (converted.isAfter(DateTime.now())) {
        upcoming = converted.difference(DateTime.now());
        switch (i) {
          case 0:
          case 7:
            wakt = 'Sunrise';
            break;
          case 1:
            wakt = 'Fajr';
            break;
          case 2:
            wakt = 'Dhuhr';
            break;
          case 3:
            wakt = 'Asar';
            break;
          case 4:
            wakt = 'Sunset';
            break;
          case 5:
            wakt = 'Magribh';
            break;
          case 6:
            wakt = 'Isha';
            break;
        }
        break;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          FutureBuilder(
            future: processDates(),
            builder: (context, snapshot) => Card(
              color: Colors.transparent,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(50), //<-- SEE HERE
                ),
                tileColor: Colors.green.shade300,
                leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/s5.png')),
                title: const Text(
                  'Upcoming',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wakt,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CountdownTimerDemo(duration: upcoming, left: true),
                  ],
                ),
                trailing: const Text(''),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          ListCards(
            assetImageUrl: 'assets/s1.png',
            time: times[1],
            title: 'Fajr',
          ),
          ListCards(
            assetImageUrl: 'assets/sunrise.png',
            time: times[0],
            title: 'Sunrise',
          ),
          ListCards(
            assetImageUrl: 'assets/s2.png',
            time: times[2],
            title: 'Dhur',
          ),
          ListCards(
            assetImageUrl: 'assets/s3.png',
            time: times[3],
            title: 'Asr',
          ),
          ListCards(
            assetImageUrl: 'assets/sunset.png',
            time: times[4],
            title: 'Sunset',
          ),
          ListCards(
            assetImageUrl: 'assets/s4.png',
            time: times[5],
            title: 'Maghrib',
          ),
          ListCards(
            assetImageUrl: 'assets/s5.png',
            time: times[6],
            title: 'Isha',
          ),
        ],
      ),
    );
  }
}

class ListCards extends StatelessWidget {
  const ListCards({
    super.key,
    required this.assetImageUrl,
    required this.time,
    required this.title,
  });
  final assetImageUrl;
  final title;
  final time;

  @override
  Widget build(BuildContext context) {
    final bool isAfter = DateTime.parse(time).isAfter(DateTime.now());
    return Card(
      child: ListTile(
        leading: Image.asset(assetImageUrl, height: 35),
        title: Text(
          title,
          style: isAfter
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              : const TextStyle(fontSize: 16),
        ),
        trailing: Text(
          DateFormat('hh:mm a').format(DateTime.parse(time)),
          style: isAfter
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              : const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
