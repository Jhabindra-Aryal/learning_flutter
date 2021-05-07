import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'Reading and Writing Files',
    home: FlutterDemo(storage: CounterStorage()),
  ));
}

class CounterStorage {
  //Finding the correct local path.
  Future<String> get _localPath async {
    final direcotry = await getApplicationDocumentsDirectory();
    return direcotry.path;
  }

//Creating a reference to the file location.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

//Reading data from file.
  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  //Writing data to file.
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  FlutterDemo({Key key, @required this.storage}) : super(key: key);
  final CounterStorage storage;
  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter;
  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) => setState(() {
          _counter = value;
        }));
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Button tapped $_counter time${_counter == 1 ? '' : 's'}.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
