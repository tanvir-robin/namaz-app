import 'catagorydatum.dart';

class HadithCatagory {
  List<Catagorydatum>? catagorydata;

  HadithCatagory({this.catagorydata});

  factory HadithCatagory.fromJson(List<dynamic> json) {
    return HadithCatagory(
      catagorydata: (json)
          .map((e) => Catagorydatum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Catagorydata': catagorydata?.map((e) => e.toJson()).toList(),
      };
}
