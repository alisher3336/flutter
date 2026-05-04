import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'main.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("loading")),
        appBar: AppBar(
          title: Align(alignment: Alignment.centerLeft, child: Text("Wikipedia")),
        ),
      ),
    );
  }
}


class ArticleModel{
  
}