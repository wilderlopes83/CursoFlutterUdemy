import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String _search;
  int _offset = 0;

  final String _urlTrends = "https://api.giphy.com/v1/gifs/trending?api_key=nsXsOJ3NiuZITV4aPO05DSjs1Y7K3uTI&limit=20&rating=G";

  String _UrlSearch = "https://api.giphy.com/v1/gifs/search?api_key=nsXsOJ3NiuZITV4aPO05DSjs1Y7K3uTI&q=dogs&limit=25&offset=0, dy)&rating=G&lang=en";

  

  Future<Map> _getGifs() async{
    http.Response response;

    response = await http.get(this._search==null ? this._urlTrends : this._UrlSearch);

    return json.decode(response.body);
  }
  
  @override
  void initState(){
    super.initState();
    this._getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}