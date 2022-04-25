import 'package:example/cinema/cinemaconfing/globalevariable.dart';
import 'package:example/cinema/service/auth_Service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'cinema-page.dart';

class VillePage extends StatefulWidget {
  
  @override
  _VillePageState createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  Map<String, String> headers = new Map();
  List<dynamic> listVilles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('villes'),
              backgroundColor: Colors.orange,),
      body: Center(
        child:this.listVilles == null? CircularProgressIndicator():
            ListView.builder(
              itemCount: (this.listVilles==null)?0:listVilles.length,
              itemBuilder: (context,index){
                return Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.white,
                      child:Text(this.listVilles[index]['name'],
                      style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {  
                        Navigator.push(context,
                        MaterialPageRoute(builder:(context)=>new CinemaPage(listVilles[index])));
                      },
                ),
                ));
              })
        ),
    );
  }

  @override
  void initState() {
     loadVilles();
    super.initState();
  }

  void loadVilles(){
    var url =Uri.parse(GlobaleData.host+"/villes") ;
    headers["Authorization"] = Authservice.token;
    http.get(url,headers: headers)
    .then((resp){
      setState(() {
        this.listVilles= json.decode(resp.body)['_embedded']['villes'];
      });
    }).catchError((err){
      print(err);
    });
  }
}