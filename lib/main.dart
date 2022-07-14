import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

const String apiUrl = "https://jsonplaceholder.typicode.com/photos";

class GstModel {
  int? albumId;
  String? title;
  String? url;

  GstModel({this.albumId, this.title, this.url});
  GstModel.fromJson(Map<String, dynamic> m) {
    albumId = m["albumId"];
    title = m["title"];
    url = m["url"];
  }
}

class GstController {
  Future<List<GstModel>> getGstDetails() async {
    http.Response response = await http.get(Uri.parse(apiUrl));
    // ignore: avoid_print
    print(response.body);
    List<GstModel> gstModel = (jsonDecode(response.body) as List<dynamic>)
        .map((e) => GstModel.fromJson(e))
        .toList();
    return gstModel;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Api Fetch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: unused_field
  int _counter = 0;
  List<GstModel>? gstModel;
  GstController gstController = GstController();
  void _incrementCounter() async {
    List<GstModel> gstM = await gstController.getGstDetails();
    setState(() {
      gstModel = gstM;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: gstModel == null ? 0 : gstModel!.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(gstModel![i].title!),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(gstModel![i].url.toString()),
            child: Text(
              gstModel![i].albumId.toString(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
    );
  }
}
