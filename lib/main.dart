import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:conversor_monetario/pages/conversor_list_page.dart';

const request = "http://api.hgbrasil.com/finance?key=dfcbe0eb";

void main() async{

  print(await getData());

  runApp(const Conversor());
}
class Conversor extends StatefulWidget {
  const Conversor({Key? key}) : super(key: key);

  @override
  State<Conversor> createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConversorListPage(),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}