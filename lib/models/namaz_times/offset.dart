class Offset {
  int? imsak;
  int? fajr;
  int? sunrise;
  int? dhuhr;
  int? asr;
  int? maghrib;
  int? sunset;
  int? isha;
  int? midnight;

  Offset({
    this.imsak,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.sunset,
    this.isha,
    this.midnight,
  });

  factory Offset.fromJson(Map<String, dynamic> json) => Offset(
        imsak: json['Imsak'] as int?,
        fajr: json['Fajr'] as int?,
        sunrise: json['Sunrise'] as int?,
        dhuhr: json['Dhuhr'] as int?,
        asr: json['Asr'] as int?,
        maghrib: json['Maghrib'] as int?,
        sunset: json['Sunset'] as int?,
        isha: json['Isha'] as int?,
        midnight: json['Midnight'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Imsak': imsak,
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Sunset': sunset,
        'Isha': isha,
        'Midnight': midnight,
      };
}
