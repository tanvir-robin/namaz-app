import 'package:challenge/screens/hadith.dart';
import 'package:challenge/screens/quran.dart';
import 'package:challenge/screens/redesigned.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import './screens/compassSc.dart';

import './provider/mainprovider.dart';
import './models/namaz_times/namaz_times.dart';
import './widgtes/gps.dart';
import './snackbar.dart';
import 'noti.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  gpsInfo.askPermission();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  FirebaseMessaging.instance.subscribeToTopic('ad');

  runApp(const Test());
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // List<Products> _products = [];
  NamazTimes? data;
  Position? _position;
  String city = "";
  String cityc = "";
  bool readfromapi = false;
  bool reload = false;
  int activePage = 0;
  bool alreadyLoaded = false;

  void TriggerQuran() {
    setState(() {
      activePage = 1;
    });
  }

  Future<bool> getProducts(BuildContext context) async {
    if (alreadyLoaded && !reload) return true;
    SharedPreferences db = await SharedPreferences.getInstance();
    String month = (DateFormat.M().format(DateTime.now()).toString());
    String year = (DateFormat.y().format(DateTime.now()).toString());

    try {
      final String? cache = db.getString('cacheData');
      final String? cityCache = db.getString('city');
      final String? dateCache = db.getString('my');
      if (cache == null ||
          cityCache == null ||
          dateCache != '$month-$year' ||
          reload) {
        reload = false;
        print('Read from api');
        readfromapi = true;
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        final url = Uri.parse(
            'http://api.aladhan.com/v1/calendar/$year/$month?latitude=${_position!.latitude}&longitude=${_position!.longitude}&method=3&iso8601=true');
        var res = await http.get(url);
        final data1 = json.decode(res.body);
        data = NamazTimes.fromJson(data1);
        // ignore: use_build_context_synchronously
        //Provider.of<MainProvider>(context, listen: false).SetNamazTimes(data1);
        await getCity();
        db.setString('cacheData', res.body);
        db.setString('city', city);
        db.setString('my', '$month-$year');
      } else {
        print('Read from cache');
        final data1 = json.decode(db.getString('cacheData').toString());
        data = NamazTimes.fromJson(data1);
        // ignore: use_build_context_synchronously
        // Provider.of<MainProvider>(context, listen: false).SetNamazTimes(data1);
        final String? cityCache = db.getString('city');
        city = cityCache.toString();
      }
    } catch (e) {
      print(e.toString());
    }
    print(city);
    alreadyLoaded = true;
    return true;
  }

  getCity() async {
    final url = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${_position!.latitude}&longitude=${_position!.longitude}&localityLanguage=en');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    print('Printed coityu');
    print(data["city"].toString());
    if (data["city"].toString().isEmpty) {
      city = data["locality"].toString();
    } else {
      city = '${data["locality"].toString()}, ${data["city"].toString()}';
    }
  }

  void checker() async {
    print('Inside checker');
    // ignore: unused_local_variable
    SharedPreferences db = await SharedPreferences.getInstance();
    if (!readfromapi) {
      print('Inside checker if');
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      final url = Uri.parse(
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${_position!.latitude}&longitude=${_position!.longitude}&localityLanguage=en');
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data["city"].toString().isEmpty) {
        cityc = data["locality"].toString();
      } else {
        cityc = '${data["locality"].toString()}, ${data["city"].toString()}';
      }

      print("______________________");
      print(cityc);

      if (city != cityc) {
        print('match to korlona');
        //SnackbarGlobal.show('Location has been changed. Updating data');
        setState(() {
          reload = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checker();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MainProvider(),
      child: MaterialApp(
          theme:
              ThemeData(primaryColor: const Color.fromARGB(255, 58, 48, 240)),
          scaffoldMessengerKey: SnackbarGlobal.key,
          home: Scaffold(
              bottomNavigationBar: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: GNav(
                  gap: 10,
                  color: const Color.fromARGB(255, 58, 48, 240),
                  backgroundColor: Colors.white,
                  activeColor: const Color.fromARGB(255, 76, 7, 119),
                  tabs: const [
                    GButton(
                      padding: EdgeInsets.all(10),
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      padding: EdgeInsets.all(10),
                      icon: Icons.play_arrow,
                      text: 'Quran',
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Settings',
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                  //  tabBackgroundColor: Color.fromARGB(58, 5, 4, 15),
                  padding: const EdgeInsets.all(15),
                  onTabChange: (value) {
                    setState(() {
                      activePage = value;
                    });
                  },
                ),
              ),
              body: Builder(
                builder: (context) {
                  if (activePage == 0) {
                    return FutureBuilder(
                      future: getProducts(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitThreeBounce(
                            color: Color.fromARGB(255, 58, 48, 240),
                          );
                        }
                        return HomeScreen(
                            data: data, city: city, TriggerQuran: TriggerQuran);
                      },
                    );
                  } else if (activePage == 1) {
                    return QuranSc(
                      namazTimes: data,
                    );
                  }
                  return HadithScreen();
                },
              ))),
    );
  }
}
