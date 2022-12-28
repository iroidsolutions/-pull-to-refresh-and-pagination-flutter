import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pulldata/response.dart';

import 'model/model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 0;
  final fd = FetchData();
  PaginationResponse? fetchData;
  List<Data>? data = [];
  final ScrollController sc = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshData();
    sc.addListener(controller);
  }

  void controller() {
    if (sc.position.pixels == sc.position.maxScrollExtent) {
      print("load data");
      pagination();
    }
    print("can't load");
  }

  List name = [];
  Future<void> refreshData() async {
    name.clear();
    page = 0;
    var url = Uri.parse(
        'https://api.instantwebtools.net/v1/passenger?page=0&size=15');

    final response = await http.get(url);
    Map<String, dynamic> json = jsonDecode(response.body);

    PaginationResponse pagination = PaginationResponse.fromJson(json);

    data = pagination.data;

    pagination.data!.map((e) {
      setState(() {
        name.add(e.name);
      });
    }).toList();

    print(pagination.data!.length);
    print(page);
  }

  Future<void> pagination() async {
    page++;
    var url = Uri.parse(
        'https://api.instantwebtools.net/v1/passenger?page=$page&size=15');

    final response = await http.get(url);
    Map<String, dynamic> json = jsonDecode(response.body);

    PaginationResponse pagination = PaginationResponse.fromJson(json);

    data = pagination.data;

    pagination.data!.map((e) {
      setState(() {
        name.add(e.name);
      });
    }).toList();

    print(pagination.data!.length);
    print(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          controller: sc,
          itemCount: name.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Text('$index'),
                title: Text(name[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => refreshData(),
      ),
    );
  }
}
