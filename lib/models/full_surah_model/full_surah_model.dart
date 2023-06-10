import 'data.dart';

class FullSurahModel {
  int? code;
  String? status;
  Data? data;

  FullSurahModel({this.code, this.status, this.data});

  factory FullSurahModel.fromJson(Map<String, dynamic> json) {
    print('Inside eng from jsom');
    return FullSurahModel(
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
