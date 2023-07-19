import 'package:challenge/widgtes/Loading.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/full_hadith.dart';

class DetailsHadith extends StatefulWidget {
  const DetailsHadith({super.key, required this.id, required this.lan});
  final String lan;
  final String id;

  @override
  State<DetailsHadith> createState() => _DetailsHadithState();
}

class _DetailsHadithState extends State<DetailsHadith> {
  List idOfHadith = [];
  List<FullHadith?> full_hadith = [];
  Future<bool> getFullhadith() async {
    //Getting the ids
    final url = Uri.parse(
        'https://hadeethenc.com/api/v1/hadeeths/list/?language=${widget.lan}&category_id=${widget.id}&page=1&per_page=20000');
    final response = await http.get(url);
    final idData = json.decode(response.body);
    print('Response done');
    for (var element in (idData['data'] as List)) {
      idOfHadith.add(element['id']);
      final urlh = Uri.parse(
          'https://hadeethenc.com/api/v1/hadeeths/one/?language=${widget.lan}&id=${element['id'].toString()}');
      final responsee = await http.get(urlh);
      print(responsee.body);
      full_hadith.add(FullHadith.fromJson(json.decode(responsee.body)));
    }

    print(idOfHadith);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 30, 7, 7)),
        title: const Text(
          'Al-Hadith',
          style: TextStyle(
              fontFamily: 'Poppins-Regular',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: getFullhadith(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return ListView.builder(
            itemCount: full_hadith.length,
            itemBuilder: (context, i) {
              return Text(full_hadith[i]!.title.toString());
            },
          );
        },
      ),
    );
  }
}
