import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'person.db'), onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE person(id INTEGER PRIMARY KEY,name TEXT,address TEXT)",
    );
  }, version: 1);
  Future<void> insertPerson(Person person) async {
    final Database db = await database;
    db.insert('person', person.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Person>> person() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('person');
    return List.generate(
        maps.length,
        (index) => Person(
            id: maps[index]['id'],
            name: maps[index]['name'],
            address: maps[index]['address']));
  }

  var per = Person(id: 4, name: 'Mith', address: 'Thailand');
  await insertPerson(per);
  print(await person());
  runApp(MyApp(listOfPerson: person()));
}

class MyApp extends StatelessWidget {
  MyApp({this.listOfPerson});
  final Future<List<Person>> listOfPerson;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.green.shade100,
      ),
      home: MyHomePage(
          title: 'Http Package Learning', listOfPerson: listOfPerson),
    );
  }
}

class Person {
  final int id;
  final String name;
  final String address;
  Person({this.id, this.name, this.address});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'address': address};
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.listOfPerson}) : super(key: key);
  final Future<List<Person>> listOfPerson;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Fetch'),
      ),
      body: FutureBuilder(
        future: widget.listOfPerson,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data[index].name);
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
