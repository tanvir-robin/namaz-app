import 'package:challenge/screens/utils/surahjson.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'FullSurah.dart';

import '../models/quran_data/quran_data.dart';
import '../models/namaz_times/namaz_times.dart';
import '../models/quran_data/datum.dart';
import '../provider/mainprovider.dart';

// ignore: must_be_immutable
class QuranSc extends StatefulWidget {
  QuranSc({super.key, required this.namazTimes});
  NamazTimes? namazTimes;
  @override
  State<QuranSc> createState() => _QuranScState();
}

class _QuranScState extends State<QuranSc> {
  List<Map<String, String>> surah = [];
  var isLoading;
  int ind = int.parse(DateFormat.d().format(DateTime.now()).toString()) - 1;
  bool isReady = false;
  bool isError = false;
  int isPlaying = -1;
  bool playing = false;
  double barHeight = 0;
  double containerHeight = 0;
  final player = AudioPlayer();
  QuranData rawData = QuranData.fromJson(surahResponse.jsonResponse);
  late List<Datum> listOfSurah;

  void playAudio(int ii) async {
    if (playing) {
      print('Working on if');
      await player.pause();
      setState(() {
        // isPlaying = ii;
        playing = false;
      });
      return;
    }
    playing = true;
    String index = (ii + 1).toString();
    String i;
    if (index.length == 1) {
      i = '00$index';
    } else if (index.length == 2) {
      i = '0$index';
    } else {
      i = index;
    }
    print('Playing');

    // ignore: unused_local_variable
    final duration =
        await player.setUrl('https://server6.mp3quran.net/thubti/$i.mp3');
    // player.play();
    await player.play();
    setState(() {
      // isPlaying = ii;
    });
  }

  void serachQuery(String query) {
    final suggestion = rawData.data!.where((element) {
      final title = element.englishName!.toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      listOfSurah = suggestion;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //isLoading = fetchAllData();
    listOfSurah = rawData.data!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toppadding = MediaQuery.of(context).viewPadding.top;
    final dwidth = MediaQuery.of(context).size.width;
    final arabicDateData = widget.namazTimes?.data?[ind].date!.hijri!;
    final arabicDate =
        '${arabicDateData?.day} ${arabicDateData?.month!.en}, ${arabicDateData?.year} AD';
    return Padding(
      padding: EdgeInsets.only(top: toppadding),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(children: [
          Visibility(
            visible: containerHeight > 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: containerHeight,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Quran'),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 200,
                    // height: 0,
                    child: TextField(
                      autofocus: containerHeight > 0 ? true : false,
                      decoration:
                          const InputDecoration(labelText: 'Enter a keyword'),
                      onChanged: (value) => serachQuery(value),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          containerHeight = 0;
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 270, //270
            child: Row(children: [
              Container(
                width: dwidth * .48,
                padding: const EdgeInsets.only(left: 20, top: 15),
                // height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Quran',
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color.fromARGB(255, 58, 48, 240)),
                    ),
                    const Text(
                      'In the name of God, the merciful and compassionate',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.black),
                    ),
                    Text(
                      arabicDate,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 58, 48, 240))),
                        onPressed: () {},
                        child: const Text('Subah 12:40'))
                  ],
                ),
              ),
              Image.asset(
                'assets/quranbg.png',
                fit: BoxFit.contain,
              )
            ]),
          ),
          //

          GestureDetector(
            onTap: () {
              print('object');
              setState(() {
                if (containerHeight == 25) {
                  containerHeight = 0;
                } else {
                  containerHeight = 25;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.search),
                  Text(' Search'),
                ],
              ),
            ),
          ),
          ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listOfSurah.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    print('Working');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FullSurah(
                              name: listOfSurah[index].englishName,
                              surahNo: listOfSurah[index].number,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SurahTile(data: listOfSurah[index]),
                  ))),
        ]),
      ),
    );
  }
}

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    final dw = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(255, 58, 48, 240),
          ),
          width: 8,
          height: 70,
        ),
        const SizedBox(
          width: 7,
        ),
        SizedBox(
          // height: 50,
          width: dw - 40,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              minLeadingWidth: 0,
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/avatar.png',
                    // height: 44,
                    // fit: BoxFit.fill,
                  ),
                  Text(
                    data.number.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11.7,
                    ),
                  )
                ],
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${data.revelationType.toString().toUpperCase()} ',
                    style: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        letterSpacing: 1,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.grey.shade300,
                  ),
                  Text(
                    ' ${data.numberOfAyahs.toString().toUpperCase()} AYAHS',
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        letterSpacing: 1,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
              title: Text(
                data.englishName.toString(),
                style: const TextStyle(
                    fontFamily: 'Poppins-Regular', fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                data.name.toString(),
                style: const TextStyle(
                    fontFamily: 'ReadexPro-Bold',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 58, 48, 240)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
