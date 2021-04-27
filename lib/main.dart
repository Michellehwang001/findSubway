import 'package:find_subway/models/realtime_arrival_list.dart';
import 'package:find_subway/models/subway.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FindSubway(),
    );
  }
}

class FindSubway extends StatefulWidget {
  @override
  _FindSubwayState createState() => _FindSubwayState();
}

class _FindSubwayState extends State<FindSubway> {
  Subway subwayInfo = Subway();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();

  Future<Subway> fetchData(String name) async {
    var uri = Uri.parse(
        'http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/' +
            name);
    var response = await http.get(uri);
    //expect(response.statusCode, 200);
    Subway info = Subway.fromJson(json.decode(response.body));

    return info;
  }

  @override
  void initState() {
    super.initState();

    fetchData('대야미').then((info) {
      setState(() {
        subwayInfo = info;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지하철 실시간 정보'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '역이름 ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '역명을 입력하세요!',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return '역명을 입력하세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(onSurface: Colors.blue),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          fetchData(_textController.text.trim()).then((info) {
                            setState(() {
                              subwayInfo = info;
                            });
                          });
                        }
                      },
                      child: Text('조회')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                child: Container(
                  child: Text(
                    '도착정보',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              subwayInfo == null ? CircularProgressIndicator() : makeList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(RealtimeArrivalList item) {
    return Card(
      child: Column(
        children: [
          Image.network(
              'https://spnimage.edaily.co.kr/images/photo/files/NP/S/2020/10/PS20100800026.jpg'),
          Text(item.trainLineNm),
          Text(item.recptnDt),
        ],
      ),
    );
  }

  Widget makeList() {
    return (Expanded(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        childAspectRatio: 2 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children:
            subwayInfo.realtimeArrivalList.map((e) => _buildItem(e)).toList(),
      ),
    ));
  }
}
