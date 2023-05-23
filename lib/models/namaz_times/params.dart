class Params {
  int? fajr;
  int? isha;

  Params({this.fajr, this.isha});

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json['Fajr'] as int?,
        isha: json['Isha'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Isha': isha,
      };
}
