import 'package:challenge/screens/detailsHadith.dart';
import 'package:challenge/widgtes/Loading.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../models/hadith_catagory/catagorydatum.dart';
import '../models/hadith_catagory/hadith_catagory.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  int activeLan = 0;
  HadithCatagory? hadithCatagory;
  bool gridView = false;
  final List langcode = [
    'en',
    'bn',
    'fr',
    'es',
    'tr',
    'ur',
    'id',
    'bs',
    'ru',
    'zh',
    'fa',
    'tl',
    'hi',
    'vi',
    'si',
    'ug'
  ];

  Future<bool> loadCatagory() async {
    print('Working on async');
    final url = Uri.parse(
        'https://hadeethenc.com/api/v1/categories/list/?language=${langcode[activeLan]}');
    try {
      final response = await http.get(url);

      final data = json.decode(response.body);

      hadithCatagory = HadithCatagory.fromJson(data);
    } catch (e) {
      print(e.toString());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 58, 48, 240),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Al-Hadith',
          style: TextStyle(
              fontFamily: 'Poppins-Regular',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 100,
              child: GridView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisSpacing: 0, mainAxisExtent: 60),
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 0;
                      });
                    },
                    child: LanguageIcon(
                      title: 'English',
                      url: 'EN',
                      isSelected: activeLan == 0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 1;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Bangla',
                      url: 'BN',
                      isSelected: activeLan == 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 2;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Français',
                      url: 'FR',
                      isSelected: activeLan == 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 3;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Español',
                      url: 'ES',
                      isSelected: activeLan == 3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 4;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Türkçe',
                      url: 'TR',
                      isSelected: activeLan == 4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 5;
                      });
                    },
                    child: LanguageIcon(
                      title: 'اردو',
                      url: 'UR',
                      isSelected: activeLan == 5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 6;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Indonesia',
                      url: 'ID',
                      isSelected: activeLan == 6,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 7;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Bosanski',
                      url: 'BS',
                      isSelected: activeLan == 7,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 8;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Русский',
                      url: 'RU',
                      isSelected: activeLan == 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 9;
                      });
                    },
                    child: LanguageIcon(
                      title: '中文',
                      url: 'ZH',
                      isSelected: activeLan == 9,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 10;
                      });
                    },
                    child: LanguageIcon(
                      title: 'فارسی',
                      url: 'FA',
                      isSelected: activeLan == 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 11;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Tagalog',
                      url: 'TL',
                      isSelected: activeLan == 11,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 12;
                      });
                    },
                    child: LanguageIcon(
                      title: 'हिन्दी',
                      url: 'HI',
                      isSelected: activeLan == 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 13;
                      });
                    },
                    child: LanguageIcon(
                      title: 'Tiếng Việt',
                      url: 'VI',
                      isSelected: activeLan == 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 14;
                      });
                    },
                    child: LanguageIcon(
                      title: 'සිංහල',
                      url: 'SI',
                      isSelected: activeLan == 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeLan = 15;
                      });
                    },
                    child: LanguageIcon(
                      title: 'ئۇيغۇرچە',
                      url: 'UG',
                      isSelected: activeLan == 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 500,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 233, 233),
                  borderRadius: BorderRadius.circular(12)),
              child: FutureBuilder(
                  future: loadCatagory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    }
                    final datas = hadithCatagory!.catagorydata!;
                    if (!gridView) {
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: datas.length,
                          itemBuilder: (context, i) => Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: GridTiles(
                                datas: datas,
                                i: i,
                                lan: langcode[activeLan],
                              )));
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: datas.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(datas[i].title.toString()),
                        subtitle: Text(datas[i].hadeethsCount.toString()),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({
    super.key,
    required this.title,
    required this.url,
    required this.isSelected,
  });

  final url;
  final title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.center,
            height: 40,
            width: 40,
            decoration: isSelected
                ? BoxDecoration(
                    color: const Color.fromARGB(255, 71, 58, 58),
                    borderRadius: BorderRadius.circular(10))
                : BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
            child: Text(
              url,
              style: isSelected
                  ? const TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20)
                  : const TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
            )),
        const SizedBox(
          height: 7,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class GridTiles extends StatelessWidget {
  const GridTiles(
      {super.key, required this.datas, required this.i, required this.lan});
  final List<Catagorydatum>? datas;
  final int i;
  final String lan;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsHadith(
                    id: datas![i].id.toString(),
                    lan: lan,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  datas![i].title.toString()[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Text(
                datas![i].title.toString(),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Text('Total Hadith: ${datas![i].hadeethsCount.toString()}'),
            ]),
      ),
    );
  }
}
