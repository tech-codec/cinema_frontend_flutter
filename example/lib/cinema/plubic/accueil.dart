import 'package:example/cinema/plubic/setting-page.dart';
import 'package:example/cinema/plubic/ville-page.dart';
import 'package:example/cinema/service/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'menu-item.dart';
class CinemaApp extends StatefulWidget {
 
 String username;
 String password;
 String token;
 CinemaApp(this.username,this.password,this.token);

  @override
  _CinemaAppState createState() => _CinemaAppState();
}

class _CinemaAppState extends State<CinemaApp> {

  final menus = [ 
    {'title': 'Home', 'icon': Icon(Icons.home),'page':new VillePage()},
    {'title': 'Setting', 'icon': Icon(Icons.settings),'page':SettingPage()},
    {'title': 'Contact', 'icon': Icon(Icons.contact_mail),'page':SettingPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cineme Home"),backgroundColor: Colors.orange,),
      body: Center(
        child: Text("Home Cinema"),
        ),
        drawer: Drawer(
          child:ListView(
            children: [
              DrawerHeader(
                child:Center(
                  child: CircleAvatar( 
                    backgroundImage: AssetImage("./assets/profile.png"),
                    radius:40 ,),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.white,Colors.orange])
                ),
              ),
              ...this.menus.map((item){
                return new Column(
                  children:<Widget> [
                     Divider(color: Colors.orange,),
                     MenuItem(item['title'].toString(), item['icon'] as Icon, (context){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>item['page'] as Widget));
                      })
                  ],
                );
              }),
            ],) ,
          ),
    );
  }
}