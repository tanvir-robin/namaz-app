import 'data.dart';

class FullSurahArabic {
  int? code;
  String? status;
  Data? data;

  FullSurahArabic({this.code, this.status, this.data});

  factory FullSurahArabic.fromJson(Map<String, dynamic> json) {
    print('Inside arabic from jsom');
    return FullSurahArabic(
      code: json['code'] as int?,
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'data': data?.toJson(),
      };
}
