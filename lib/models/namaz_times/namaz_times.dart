import 'datum.dart';

class NamazTimes {
  int? code;
  String? status;
  List<Datum>? data;

  NamazTimes({this.code, this.status, this.data});

  factory NamazTimes.fromJson(Map<String, dynamic> json) => NamazTimes(
        code: json['code'] as int?,
        status: json['status'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
