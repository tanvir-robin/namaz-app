class FullHadith {
  String? id;
  String? title;
  String? hadeeth;
  String? attribution;
  String? grade;
  String? explanation;
  List<dynamic>? hints;
  List<String>? categories;
  List<String>? translations;

  FullHadith({
    this.id,
    this.title,
    this.hadeeth,
    this.attribution,
    this.grade,
    this.explanation,
    this.hints,
    this.categories,
    this.translations,
  });

  factory FullHadith.fromJson(Map<String, dynamic> json) => FullHadith(
        id: json['id'] as String?,
        title: json['title'] as String?,
        hadeeth: json['hadeeth'] as String?,
        attribution: json['attribution'] as String?,
        grade: json['grade'] as String?,
        explanation: json['explanation'] as String?,
        hints: json['hints'] as List<dynamic>?,
        categories: json['categories'] as List<String>?,
        translations: json['translations'] as List<String>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hadeeth': hadeeth,
        'attribution': attribution,
        'grade': grade,
        'explanation': explanation,
        'hints': hints,
        'categories': categories,
        'translations': translations,
      };
}
