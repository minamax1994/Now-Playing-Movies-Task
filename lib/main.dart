import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> result;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _fetchData() async {
    http.Response response = await http.post(
        'http://api.themoviedb.org/3/movie/now_playing?api_key=31521ab741626851b73c684539c33b5a');
    setState(() {
      result = json.decode(response.body);
    });
    print(result);
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget _builder() {
    if (result == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: result['results'].length,
        itemBuilder: (BuildContext context, int movieIndex) {
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Card(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w300_and_h300_bestv2${result['results'][movieIndex]['poster_path']}',
                  alignment: AlignmentDirectional.topCenter,
                ),
              ),
              Container(
                height: 50.0,
                width: 170.0,
                color: Colors.red.withOpacity(.3),
                child: Center(
                  child: Text(
                    result['results'][movieIndex]['title'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Now Playing Movies',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Now Playing Movies')),
        ),
        backgroundColor: Colors.red[50],
        body: _builder(),
      ),
    );
  }
}
