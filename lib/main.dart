import 'package:flutter/foundation.dart';
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
        canvasColor: Colors.green.shade100,
      ),
      home: MyHomePage(title: 'Http Package Learning'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Album {
  final int userId;
  final int id;
  final String title;
  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String);
  }
}

List<Album> parseAlbums(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

Future<List<Album>> fetchAlbums(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
  return compute(parseAlbums, response.body);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Fetch'),
      ),
      body: Center(
        child: FutureBuilder<List<Album>>(
            future: fetchAlbums(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Card(
                          shadowColor: Colors.grey,
                          color: Colors.grey.shade200,
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.yellow.shade100,
                                foregroundColor: Colors.green.shade500,
                                child: Text('${snapshot.data[index].id}')),
                            title: Text('${snapshot.data[index].title}',
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ]);
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
