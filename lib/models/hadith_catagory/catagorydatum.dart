class Catagorydatum {
  String? id;
  String? title;
  String? hadeethsCount;
  dynamic parentId;

  Catagorydatum({this.id, this.title, this.hadeethsCount, this.parentId});

  factory Catagorydatum.fromJson(Map<String, dynamic> json) => Catagorydatum(
        id: json['id'] as String?,
        title: json['title'] as String?,
        hadeethsCount: json['hadeeths_count'] as String?,
        parentId: json['parent_id'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hadeeths_count': hadeethsCount,
        'parent_id': parentId,
      };
}
