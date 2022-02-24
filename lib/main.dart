import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SharedPrefScreen extends StatelessWidget {
  const SharedPrefScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сохранение значений счетчиков',
      home: MyHomePage(
        title: 'Сохранение значений счетчиков',
        storage: CounterStorage(),),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory =await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/counter.txt');
  }
  Future<int> readCounter() async{
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    }
    catch (e) {
      return 0;
    }
  }
  Future<File> writeCounter(int counter1) async {
    final file = await _localFile;
    return file.writeAsString('$counter1',);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title,
    required this.storage,}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; //счетчик в sharedPref
  int _counter1 = 0; //счетчик в файле

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter1 =value;
      });
    });
    _loadCounter();
  }
  Future<File> _incrementCounter1() {
    setState(() {
      _counter1++;
    });
    return widget.storage.writeCounter(_counter1);
  }
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
  }
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) +1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Счетчик нажатий в памяти SharedPref',
              style: TextStyle(fontSize: 25),),
            const Text('Вы нажали кнопку столько раз:',
              style: TextStyle(fontSize: 20),),
            Text('$_counter',
              style: Theme.of(context).textTheme.headline4,),
            ElevatedButton(onPressed: _incrementCounter,
              child: const Text('Тык'),),
            TextButton(onPressed: _incrementCounter,
              child: const Icon(Icons.add),),
            const Text('Счетчик нажатий в файле counter.txt',
              style: TextStyle(fontSize: 25,),),
            const Text('Вы нажали кнопку столько раз:',
              style: TextStyle(fontSize: 20,),),
            Text('$_counter1',
              style: Theme.of(context).textTheme.headline4,),
            ElevatedButton(onPressed: _incrementCounter1,
              child: const Text('Тык'),),
            TextButton(onPressed: _incrementCounter1,
              child: const Icon(Icons.add),),

          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const SharedPrefScreen());
}