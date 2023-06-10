import 'datum.dart';

class QuranData {
  int? code;
  String? status;
  List<Datum>? data;

  QuranData({this.code, this.status, this.data});

  factory QuranData.fromJson(Map<String, dynamic> json) => QuranData(
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
