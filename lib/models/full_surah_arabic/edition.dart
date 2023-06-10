class Edition {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  String? direction;

  Edition({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json['identifier'] as String?,
        language: json['language'] as String?,
        name: json['name'] as String?,
        englishName: json['englishName'] as String?,
        format: json['format'] as String?,
        type: json['type'] as String?,
        direction: json['direction'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'language': language,
        'name': name,
        'englishName': englishName,
        'format': format,
        'type': type,
        'direction': direction,
      };
}
