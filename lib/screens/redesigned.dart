import 'package:challenge/screens/SunInfo.dart';
import 'package:challenge/screens/compassSc.dart';
import 'package:challenge/screens/hadith.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';

import 'package:challenge/noti.dart';
import 'package:challenge/timer.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/namaz_times/namaz_times.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.data,
      required this.city,
      required this.TriggerQuran});
  final Function TriggerQuran;
  final NamazTimes? data;
  final city;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int ind = int.parse(DateFormat.d().format(DateTime.now()).toString()) - 1;
  Duration upcoming = Duration();
  bool calculate = true;
  String wakt = '';
  int waktindex = 0;
  var myF;
  List times = [];
  List waktnames = [
    'Fajr',
    'Sunrise',
    'Duhr',
    'Asr',
    'Sunset',
    'Maghrib',
    'Isha'
  ];

  String cropeIt(String iso, String wakt, int id) {
    String cutted =
        iso.split(' ')[0].substring(0, iso.split(' ')[0].length - 6);
    if (id == 2 || id == 5 || id == 8) {
      Noti.scheduler(
          id: id,
          title: 'Sun update',
          body: '$wakt happening',
          fln: flutterLocalNotificationsPlugin,
          time: DateTime.parse(cutted));
    } else {
      Noti.scheduler(
          id: id,
          title: '$wakt',
          body: 'You can start your $wakt from now',
          fln: flutterLocalNotificationsPlugin,
          time: DateTime.parse(cutted));
    }
    return cutted;
  }

  Future<bool> processDates() async {
    times.add(
        cropeIt(widget.data!.data![ind].timings!.fajr.toString(), 'Fajr', 1));
    times.add(cropeIt(
        widget.data!.data![ind].timings!.sunrise.toString(), 'Sunrise', 2));
    times.add(
        cropeIt(widget.data!.data![ind].timings!.dhuhr.toString(), 'Dhur', 3));
    times.add(
        cropeIt(widget.data!.data![ind].timings!.asr.toString(), 'Asr', 4));
    times.add(cropeIt(
        widget.data!.data![ind].timings!.sunset.toString(), 'Sunset', 5));
    times.add(cropeIt(
        widget.data!.data![ind].timings!.maghrib.toString(), 'Maghrib', 6));
    times.add(
        cropeIt(widget.data!.data![ind].timings!.isha.toString(), 'Isha', 7));
    times.add(cropeIt(widget.data!.data![ind + 1].timings!.sunrise.toString(),
        'nsunrise', 8));

    for (int i = 0; i < times.length; i++) {
      DateTime converted = DateTime.parse(times[i]);

      if (converted.isBefore(DateTime.now())) {
        wakt = waktnames[i];
        waktindex = i;
      }
      if (converted.isAfter(DateTime.now())) {
        upcoming = converted.difference(DateTime.now());

        // switch (i) {
        //   case 0:
        //   case 7:
        //     wakt = 'Sunrise';
        //     break;
        //   case 1:
        //     wakt = 'Fajr';
        //     break;
        //   case 2:
        //     wakt = 'Dhuhr';
        //     break;
        //   case 3:
        //     wakt = 'Asar';
        //     break;
        //   case 4:
        //     wakt = 'Sunset';
        //     break;
        //   case 5:
        //     wakt = 'Magribh';
        //     break;
        //   case 6:
        //     wakt = 'Isha';
        //     break;
        // }
        break;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).viewPadding.top;
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
            future: processDates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitThreeBounce(
                  color: Color.fromARGB(255, 58, 48, 240),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.topCenter, children: [
                      Container(
                          alignment: Alignment.topCenter,
                          height: 260,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(50),
                            ),
                            color: Color.fromARGB(255, 58, 48, 240),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: pad + 25, left: 18, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(children: [
                                        Text(
                                          widget.city,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.white),
                                        ),
                                      ]),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children:
                                            waktnames[waktindex] != 'Sunrise'
                                                ? [
                                                    Text(
                                                      '${waktnames[waktindex]} ',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    CountdownTimerDemo(
                                                        duration: upcoming,
                                                        left: true),
                                                  ]
                                                : [
                                                    Text(
                                                      '${waktnames[waktindex + 1]} satrting on ',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    CountdownTimerDemo(
                                                        duration: upcoming,
                                                        left: false),
                                                  ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.supervised_user_circle_outlined,
                                      size: 40,
                                    ))
                              ],
                            ),
                          )),
                      Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: pad + 100),
                          width: 350,
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const MenuIcons(
                                    title: 'Routine',
                                    url: 's1',
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.TriggerQuran();
                                    },
                                    child: const MenuIcons(
                                      title: 'Quran',
                                      url: 'quran',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CompassSc()),
                                      );
                                    },
                                    child: const MenuIcons(
                                      title: 'Compass',
                                      url: 'compass',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HadithScreen()));
                                    },
                                    child: const MenuIcons(
                                      title: 'Al-Hadith',
                                      url: 'hadith',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MenuIcons(
                                    title: 'Routine',
                                    url: 's3',
                                  ),
                                  MenuIcons(
                                    title: 'Quran',
                                    url: 's1',
                                  ),
                                  MenuIcons(
                                    title: 'Mosque',
                                    url: 's4',
                                  ),
                                  MenuIcons(
                                    title: 'Donation',
                                    url: 's2',
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ]),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: SunInfo(
                        sunrise: DateFormat('hh:mm a')
                            .format((DateTime.parse(times[1]))),
                        sunset: DateFormat('hh:mm a')
                            .format((DateTime.parse(times[4]))),
                      ),
                    ),
                    Column(
                      children: [
                        PrayerTiles(
                          title: 'Fajr',
                          isDone: true,
                          time: times[0],
                          nextime: times[1],
                        ),
                        PrayerTiles(
                            title: 'Duhr',
                            isDone: true,
                            time: times[2],
                            nextime: times[3]),
                        PrayerTiles(
                            title: 'Asr',
                            isDone: true,
                            time: times[3],
                            nextime: times[4]),
                        PrayerTiles(
                            title: 'Maghrib',
                            isDone: false,
                            time: times[5],
                            nextime: times[6]),
                        PrayerTiles(
                            title: 'Isha',
                            isDone: false,
                            time: times[6],
                            nextime: times[0]),
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}

// ignore: must_be_immutable
class PrayerTiles extends StatelessWidget {
  PrayerTiles(
      {super.key,
      required this.title,
      required this.isDone,
      this.time,
      required this.nextime});

  final title;
  final bool isDone;
  final time;
  final nextime;
  bool running = true;

  @override
  Widget build(BuildContext context) {
    DateTime formated = (DateTime.parse(time));
    DateTime formatedn = (DateTime.parse(nextime));
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title Prayer',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(
                DateFormat('hh:mm a').format((DateTime.parse(time))),
              )
            ],
          ),
          formated.isBefore(DateTime.now()) && formatedn.isAfter(DateTime.now())
              ? Image.asset(
                  'assets/rotate.png',
                  height: 24,
                )
              : formated.isBefore(DateTime.now())
                  ?
                  // ? const Icon(
                  //     size: 25,
                  //     Icons.check_circle,
                  //     color: Color.fromARGB(255, 58, 48, 240),
                  //   )
                  Image.asset(
                      'assets/checked.png',
                      height: 23,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      size: 24,
                      color: Color.fromARGB(255, 58, 48, 240),
                    )
        ],
      ),
    );
  }
}

class MenuIcons extends StatelessWidget {
  const MenuIcons({
    super.key,
    required this.title,
    required this.url,
  });

  final url;
  final title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade100,
          child: Image.asset(
            'assets/$url.png',
            height: 35,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
