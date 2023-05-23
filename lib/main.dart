import 'package:challenge/dateWidget.dart';
import 'package:challenge/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import './provider/mainprovider.dart';
import './products.dart';
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
  gpsInfo.askPermission();

  runApp(const Test());
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Products> _products = [];
  late NamazTimes data;
  late Position _position;
  String city = "";
  String cityc = "";
  bool readfromapi = false;
  bool reload = false;

  Future<bool> getProducts() async {
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
            'http://api.aladhan.com/v1/calendar/$year/$month?latitude=${_position.latitude}&longitude=${_position.longitude}&method=3&iso8601=true');
        var res = await http.get(url);
        final data1 = json.decode(res.body);
        data = NamazTimes.fromJson(data1);
        await getCity();
        db.setString('cacheData', res.body);
        db.setString('city', city);
        db.setString('my', '$month-$year');
      } else {
        print('Read from cache');
        final data1 = json.decode(db.getString('cacheData').toString());
        data = NamazTimes.fromJson(data1);
        final String? cityCache = db.getString('city');
        city = cityCache.toString();
      }
    } catch (e) {
      print(e.toString());
    }
    print(city);
    return true;
  }

  getCity() async {
    final url = Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${_position.latitude}&longitude=${_position.longitude}&localityLanguage=en');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    city = '${data["locality"].toString()}, ${data["city"].toString()}';
  }

  void checker() async {
    SharedPreferences db = await SharedPreferences.getInstance();
    if (!readfromapi) {
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      final url = Uri.parse(
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${_position.latitude}&longitude=${_position.longitude}&localityLanguage=en');
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      cityc = '${data["locality"].toString()}, ${data["city"].toString()}';
      print("______________________");
      print(cityc);

      if (city != cityc) {
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
          scaffoldMessengerKey: SnackbarGlobal.key,
          home: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bgg.jpeg'), fit: BoxFit.cover)),
              child: FutureBuilder(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitThreeBounce(
                      color: Colors.blue,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        city,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      DateWidget(
                        data: data,
                      ),
                      HomePage(
                        data: data,
                      ),
                    ],
                  );
                },
              ),
            ),
          )),
    );
  }
}
