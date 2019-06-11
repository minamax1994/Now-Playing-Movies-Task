import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> result;
List<Map<String, dynamic>> resultList = List<Map<String, dynamic>>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Now Playing Movies',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _resultList() {
    for (int i = 0; i < result['results'].length; i++) {
      String title;
      String posterLink;
      result['results'][i].forEach((String key, dynamic property) {
        if (key == 'title') {
          title = property;
        } else if (key == 'poster_path') {
          posterLink =
              'https://image.tmdb.org/t/p/w300_and_h450_bestv2$property';
        }
      });
      resultList.add({'title': title, 'posterLink': posterLink});
    }
    print(resultList);
  }

  void _fetchData() async {
    http.Response response = await http.post(
        'http://api.themoviedb.org/3/movie/now_playing?api_key=31521ab741626851b73c684539c33b5a');
    result = json.decode(response.body);
    print(result);
    setState(() {
      _resultList();
    });
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
        padding: EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: resultList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(),
            child: Column(
              children: <Widget>[
                Image.network(resultList[index]['posterLink']),
                SizedBox(height: 5.0),
                Text(
                  resultList[index]['title'],
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Now Playing Movies',
          textAlign: TextAlign.center,
        ),
      ),
      //backgroundColor: Colors.red[50],
      body: _builder(),
    );
  }
}
