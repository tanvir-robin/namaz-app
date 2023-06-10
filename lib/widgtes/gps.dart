import 'package:permission_handler/permission_handler.dart';

class gpsInfo {
  static askPermission() async {
    var status = await Permission.location.status;
    var statusn = await Permission.notification.status;
    print(status);
    print(statusn);
    if (status.isDenied) {
      await Permission.location.request();
    }
  }
}
