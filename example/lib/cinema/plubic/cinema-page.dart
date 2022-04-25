import 'package:example/cinema/plubic/salle-page.dart';
import 'package:example/cinema/service/auth_Service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class CinemaPage extends StatefulWidget {
  dynamic ville;
  CinemaPage(this.ville);

  @override
  _CinemaPageState createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  Map<String, String> headers = new Map();
  List<dynamic> listCinema= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cinema de la ville ${widget.ville['name']}'),
              backgroundColor: Colors.orange,
      ),
      body: Center(
        child:this.listCinema == null? CircularProgressIndicator():
        ListView.builder(
          itemCount: (this.listCinema==null)?0:listCinema.length,
          itemBuilder:(context,index){
            return Card(
              color: Colors.orange,
              child: Padding(padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.white,
                child: Text(this.listCinema[index]['name'],
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                onPressed:(){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>new SallePage(this.listCinema[index])));
                } ,),),
            );
          }),
        ),
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCinema();
  }

  void loadCinema(){
    var url = Uri.parse(this.widget.ville['_links']['cinemas']['href']
        .toString().replaceAll("{?projection}", "?projection=cinema"));
    headers["Authorization"] = Authservice.token;
     http.get(url,headers: headers)
    .then((resp){
      setState((){
         this.listCinema =json.decode(resp.body)['_embedded']['cinemas'];
      });
    }).catchError((err){
      print(err);
    });
  }
}