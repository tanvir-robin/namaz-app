class Month {
  int? number;
  String? en;

  Month({this.number, this.en});

  factory Month.fromJson(Map<String, dynamic> json) => Month(
        number: json['number'] as int?,
        en: json['en'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'en': en,
      };
}
