import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api.dart';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LatestNewsResponse(),
          ),
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _value = DateTime.now();

  @override
  void initState() {
    createLatestNewsResponseState(context);
    super.initState();
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2050));
    if (picked != null) setState(() => _value = picked);
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<LatestNewsResponse>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Planetary"),
        ),
        body: (data.data != null)
            ? ListView(
                children: [
                  IconButton(
                      icon: Icon(Icons.date_range), onPressed: _selectDate),
                  Row(
                    children: [
                      Text(
                        'Picked date: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_value.toIso8601String().split('T').first),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Sever date: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.data['date'].toString()),
                    ],
                  ),
                  if (_value.toIso8601String().split('T').first ==
                      data.data['date'])
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: Center(
                            child: Row(
                          children: [
                            Text(
                              "Title: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(data.data["title"].toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        )),
                      ),
                    ),
                  if (_value.toIso8601String().split('T').first ==
                      data.data['date'])
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Explanation: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(data.data["explanation"].toString()),
                      ],
                    ),
                  if (_value.toIso8601String().split('T').first ==
                      data.data['date'])
                    CachedNetworkImage(
                      imageUrl: data.data['url'],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
