import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgtes/Loading.dart';

import './Error_Screen.dart';

import '../models/full_surah_model/full_surah_model.dart';

import '../models/full_surah_arabic/full_surah_arabic.dart';

class FullSurah extends StatefulWidget {
  final surahNo;
  final name;
  const FullSurah({required this.surahNo, required this.name});

  @override
  State<FullSurah> createState() => _FullSurahState();
}

class _FullSurahState extends State<FullSurah> {
  List<Map<String, String>> ayah = [];
  List<Map<String, String>> ayahArabic = [];
  var isLoad;
  bool isReady = false;
  bool isError = false;
  late FullSurahModel fullSurah;
  late FullSurahArabic fullSurahArabic;
  bool isPlayingfull = false;
  // ignore: prefer_typing_uninitialized_variables
  final audioPlayer = AudioPlayer();
  bool cnt = true;
  int nowPlaying = -1;
  bool playFullicon = false;
  bool isCacheLoading = false;

  Future<bool> getSurah(BuildContext context) async {
    final urlEnglish = Uri.parse(
        'http://api.alquran.cloud/v1/surah/${widget.surahNo}/en.asad');
    final urlArabic =
        Uri.parse('http://api.alquran.cloud/v1/surah/${widget.surahNo}');

    try {
      var responseEnglish;
      var responseArabic;
      var English;
      var Arabic;
      final db = await SharedPreferences.getInstance();
      final dbs = db.getString('${widget.name.toString()}English');
      if (dbs == '1') {
        print('Read surah from cache');

        // await Future.delayed(Duration(microseconds: 1));
        responseEnglish = dbs;
        responseArabic = db.getString('${widget.name.toString()}Arabic');
        English = jsonDecode(responseEnglish);
        Arabic = jsonDecode(responseArabic);
      } else {
        print('Read surah from API');
        responseEnglish = await http.get(urlEnglish);
        responseArabic = await http.get(urlArabic);
        // await db.setString(
        //     '${widget.name.toString()}English', responseEnglish.body);
        // await db.setString(
        //     '${widget.name.toString()}Arabic', responseArabic.body);
        English = jsonDecode(responseEnglish.body);
        Arabic = jsonDecode(responseArabic.body);
      }

      fullSurah = FullSurahModel.fromJson(English);
      fullSurahArabic = FullSurahArabic.fromJson(Arabic);
    } catch (e) {
      print('Error');
      print(e.toString());
      // isError = true;
    }
    print(ayah[2].values);

    return true;
  }

  void openDetails(BuildContext context, Map<String, String> datas) {
    print(datas);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
          content: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Ayah Number in Quran: ${datas['numberInQuran']}'),
                Text('Juz: ${datas['juz']}'),
                Text('Manzil: ${datas['manzil']}'),
                Text('Page Number: ${datas['page']}'),
                Text('Ruku: ${datas['ruku']}'),
                Text('Hizb Quarter: ${datas['hizbQuarter']}'),
                Text('Sajda: ${datas['sajda']}'),
              ],
            ),
          )),
    );
  }

  String format3(String num) {
    if (num.length == 1) {
      return '00$num';
    } else if (num.length == 2) {
      return '0$num';
    } else {
      return num;
    }
  }

  void playAyhay(String url) async {
    print('Playing $url');
    await audioPlayer.play(UrlSource(url));
  }

  void pause() {
    if (isPlayingfull) {
      setState(() {
        playFullicon = false;
        audioPlayer.stop();
        nowPlaying = -1;
        cnt = false;
      });
    }
  }

  void playFull() async {
    isPlayingfull = true;
    cnt = true;
    String surahIndex = format3(fullSurah.data!.number.toString());
    final int numberOfAyah =
        int.parse(fullSurah.data!.numberOfAyahs.toString());
    for (int i = 1; i <= numberOfAyah && cnt; i++) {
      String ayahInd = format3(i.toString());
      final url =
          'https://audio.recitequran.com/vbv/arabic/mishary_al-afasy/$surahIndex$ayahInd.mp3';
      print('Playing $url');
      setState(() {
        nowPlaying = i;
        playFullicon = true;
      });
      Scrollable.ensureVisible(
          GlobalObjectKey(i.toString()).currentContext as BuildContext,
          duration: Duration(seconds: 1), // duration for scrolling time
          alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
          curve: Curves.easeInOutCubic);
      await audioPlayer.play(UrlSource(url));
      Duration? duration = await audioPlayer.getDuration();
      print(duration.toString());

      await Future.delayed(duration as Duration).then((value) {
        print('End of recite');
      });
    }
    setState(() {
      nowPlaying = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 230, 230),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 58, 48, 240)),
        title: Text(
          widget.name,
          style: const TextStyle(
              fontFamily: 'Poppins-Regular',
              color: Color.fromARGB(255, 58, 48, 240),
              fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(onPressed: playFull, icon: const Icon(Icons.play_arrow)),
        //   IconButton(
        //       onPressed: () {
        //         audioPlayer.stop();
        //         cnt = false;
        //       },
        //       icon: const Icon(Icons.pause)),
        // ],
      ),
      body: FutureBuilder(
          future: getSurah(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting ||
                  isCacheLoading
              ? const Loading()
              : isError
                  ? const Error()
                  : Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(children: [
                          Stack(alignment: Alignment.centerLeft, children: [
                            Image.asset(
                              'assets/f3.png',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                        fontFamily: 'ReadexPro-Bold',
                                        letterSpacing: 1,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    fullSurah.data!.englishNameTranslation
                                        .toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        letterSpacing: 1.5,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton.icon(
                                      onPressed:
                                          playFullicon ? pause : playFull,
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0))),
                                      icon: playFullicon
                                          ? const Icon(
                                              Icons.pause,
                                              color: Colors.black,
                                              size: 10,
                                            )
                                          : const Icon(
                                              Icons.play_arrow,
                                              color: Colors.black,
                                              size: 12,
                                            ),
                                      label: playFullicon
                                          ? const Text('Pause',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ))
                                          : const Text('Play',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              )))
                                ],
                              ),
                            )
                          ]),
                          const Divider(),
                          ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: fullSurahArabic.data!.ayahs!.length,
                              itemBuilder: (context, index) =>
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    key:
                                        GlobalObjectKey((index + 1).toString()),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: AyahTiles(
                                      fullSurah: fullSurah,
                                      fullSurahArabic: fullSurahArabic,
                                      index: index,
                                      isMarked: nowPlaying == (index + 1),
                                    ),
                                  )),
                        ]),
                      ),
                    )),
    );
  }
}

class AyahTiles extends StatefulWidget {
  const AyahTiles(
      {super.key,
      required this.fullSurah,
      required this.fullSurahArabic,
      required this.index,
      required this.isMarked});
  final FullSurahModel fullSurah;
  final FullSurahArabic fullSurahArabic;
  final int index;
  final bool isMarked;

  @override
  State<AyahTiles> createState() => _AyahTilesState();
}

class _AyahTilesState extends State<AyahTiles> {
  final audioPlayer = AudioPlayer();

  bool isPlaying = false;

  void playAyhay(String url) async {
    if (isPlaying) {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      print('Playing $url');
      await audioPlayer.play(UrlSource(url));
      Duration? duration = await audioPlayer.getDuration();
      print(duration.toString());
      setState(() {
        isPlaying = true;
      });

      Future.delayed(duration as Duration).then((value) {
        print('End of recite');
        setState(() {
          isPlaying = false;
        });
      });
    }
  }

  String format3(String num) {
    if (num.length == 1) {
      return '00$num';
    } else if (num.length == 2) {
      return '0$num';
    } else {
      return num;
    }
  }

  @override
  Widget build(BuildContext context) {
    String surahIndex = format3(widget.fullSurah.data!.number.toString());
    String ayahIndex = format3((widget.index + 1).toString());
    return Column(
      // key: GlobalObjectKey(widget.index),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          onTap: () {
            // var datas = {
            //   'numberInQuran':
            //       ayah[index]['numberInQuran'].toString(),
            //   'juz': ayah[index]['juz'].toString(),
            //   'manzil': ayah[index]['manzil'].toString(),
            //   'page': ayah[index]['page'].toString(),
            //   'ruku': ayah[index]['ruku'].toString(),
            //   'hizbQuarter':
            //       ayah[index]['hizbQuarter'].toString(),
            //   'sajda': ayah[index]['sajda'].toString()
            // };
            // openDetails(context, datas);
          },
          subtitle: Text(
            widget.fullSurah.data!.ayahs![(widget.index)].text.toString(),
            style: const TextStyle(
              fontFamily: 'ReadexPro-Bold',
            ),
          ),
          title: Text(
            widget.fullSurahArabic.data!.ayahs![(widget.index)].text.toString(),
            textAlign: TextAlign.end,
            style: TextStyle(
                fontFamily: 'Amiri-Regular',
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: widget.isMarked
                    ? Colors.green
                    : const Color.fromARGB(255, 58, 48, 240)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 30,
              width: 80,
              child: ElevatedButton.icon(
                  onPressed: () {
                    playAyhay(
                        'https://audio.recitequran.com/vbv/arabic/mishary_al-afasy/$surahIndex$ayahIndex.mp3');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 197, 207, 215),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 21,
                  ),
                  label: const Text(
                    'Play',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
            ),
            SizedBox(
              height: 30,
              width: 85,
              child: ElevatedButton.icon(
                  onPressed: () {
                    // playAyhay(
                    //     'https://audio.recitequran.com/vbv/arabic/mahmoud_khalil_al-husari_teacher/${}000.mp3');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 197, 207, 215),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.black,
                    size: 20,
                  ),
                  label: const Text(
                    'Copy',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
            Text(widget.fullSurah.data!.ayahs![(widget.index)].numberInSurah
                .toString())
          ],
        ),
        const Divider()
      ],
    );
  }
}
