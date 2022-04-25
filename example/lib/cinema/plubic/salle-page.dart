import 'package:example/cinema/cinemaconfing/globalevariable.dart';
import 'package:example/cinema/service/auth_Service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class SallePage extends StatefulWidget {
  dynamic cinema;
  SallePage(this.cinema);

  @override
  _SallePageState createState() => _SallePageState();
}

class _SallePageState extends State<SallePage> {

  Map<String, String> headers = new Map();

  final TextEditingController _codePayement = new TextEditingController();
  final TextEditingController _nameClient = new TextEditingController();

  String nameClient = '';
  String codePayement = '';

  List selectTiket = [];
  List ticketresv = [];
  List<dynamic> listSalles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('les salles du cinema ${widget.cinema['name']}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: this.listSalles == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: (this.listSalles == null) ? 0 : listSalles.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Colors.deepOrange,
                                child: Text(
                                  this.listSalles[index]['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  loadProjection(this.listSalles[index]);
                                },
                              ),
                            ),
                          ),
                          if (this.listSalles[index]['projections'] != null)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    GlobaleData.host +
                                        "/imageFilm/${this.listSalles[index]['currentprojection']['film']['id']}",
                                    width: 150,headers:{'Authservice.token':Authservice.token} ,
                                  ),
                                  Column(
                                    children: [
                                      ...(this.listSalles[index]['projections']
                                              as List<dynamic>)
                                          .map((projection) {
                                        return RaisedButton(
                                            color: (this.listSalles[index][
                                                            'currentprojection']
                                                        ['id'] ==
                                                    projection['id']
                                                ? Colors.deepOrange
                                                : Colors.green),
                                            child: Text(
                                              "${projection['seance']['heureDebut']}(${projection['film']['duree']}), prix=${projection['prix']}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            onPressed: () {
                                              loadTickets(projection,
                                                  this.listSalles[index]);
                                            });
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          if (this.listSalles[index]['currentprojection'] !=
                                  null &&
                              this.listSalles[index]['currentprojection']
                                      ['listTickets'] !=
                                  null &&
                              this
                                      .listSalles[index]['currentprojection']
                                          ['listTickets']
                                      .length >
                                  0)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        'le nombre de place disponible:${this.listSalles[index]['currentprojection']['nombrePlaceDisponible']}')
                                  ],
                                ),
                                Wrap(
                                  children: <Widget>[
                                    ...this
                                        .listSalles[index]['currentprojection']
                                            ['listTickets']
                                        .map((ticket) {
                                      if (ticket['reservee'] == false )
                                        return Container(
                                          width: 50,
                                          padding: EdgeInsets.all(2),
                                          child: RaisedButton(
                                              color: (ticket['selected'] == true
                                                  ? Colors.deepOrange
                                                  : Colors.green),
                                              child: Text(
                                                "${ticket['place']['numero']}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              onPressed: () {
                                                selecTicket(ticket,
                                                    this.listSalles[index]);
                                              }),
                                        );
                                      else
                                        return Container();
                                    }),
                                  ],
                                ),
                                if (this.selectTiket.length > 0 &&
                                    this.listSalles[index]['currentTicket'] !=
                                        null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(6, 0, 6, 2),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText: 'your name'),
                                            controller: _nameClient,
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(6, 0, 6, 2),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText: 'your code payement'),
                                            controller: _codePayement,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(6, 0, 6, 2),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                hintText: 'nombre Tickets'),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color: Colors.deepOrange,
                                            child: Text(
                                              "Réserver les places",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              reserverTickets(
                                                  this._nameClient,
                                                  this._codePayement,
                                                  this.selectTiket);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalle();
  }

  void loadSalle() {
    headers["Authorization"] = Authservice.token;
    var url = Uri.parse(this.widget.cinema['_links']['salles']['href']
        .toString()
        .replaceAll('{?projection}',''));
    http.get(url,headers: headers).then((resp) {
      setState(() {
        this.listSalles = json.decode(resp.body)['_embedded']['salles'];
        print(this.listSalles);
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjection(salle) {
    headers["Authorization"] = Authservice.token;
    var url = Uri.parse(salle['_links']['projections']['href']
        .toString()
        .replaceAll('{?projection}', '?projection=p1'));
    http.get(url,headers: headers).then((resp) {
      setState(() {
        salle['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        salle['currentprojection'] = salle['projections'][0];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTickets(projection, salle) {
    headers["Authorization"] = Authservice.token;
    var url = Uri.parse(projection['_links']['tickets']['href']
        .toString()
        .replaceAll('{?projection}', '?projection=ticketProjection'));
    http.get(url,headers: headers).then((resp) {
      setState(() {
        projection['listTickets'] =
            json.decode(resp.body)['_embedded']['tickets'];
        salle['currentprojection'] = projection;
        projection['nombrePlaceDisponible'] = nombrePlaceDisponible(projection);
      });
    }).catchError((err) {
      print(err);
    });
  }

  nombrePlaceDisponible(projection) {
    int nombre = 0;
    for (int i = 0; i < projection['tickets'].length; i++) {
      if (projection['tickets'][i]['reservee'] == false) ++nombre;
    }
    return nombre;
  }

  void selecTicket(ticket, salle) {
    salle['currentTicket'] = ticket;
    if (ticket['selected'] == null) {
      setState(() {
        ticket['selected'] = true;
        this.selectTiket.add(ticket);
      });
      print('selectionner/n');
      print(this.selectTiket.length);
    } else {
      setState(() {
        ticket['selected'] = false;
        this.selectTiket.remove(ticket);
        ticket['selected'] = null;
      });
      print('deselectionner');
    }
  }

  reserverTickets(TextEditingController nameClient,
      TextEditingController codePayement, List selectTiket) {
    List tickets = [];
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("réservation"),
            content: Text('valider votre réservation'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FlatButton(
                  child: Text('Confirmer'),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      this.nameClient = nameClient.text;
                      this.codePayement = codePayement.text;
                      selectTiket.forEach((t) {
                        tickets.add(t['id']);
                      });
                      final info = jsonEncode({
                        'nameClient': this.nameClient,
                        'codePayement': this.codePayement,
                        'tickets': tickets
                      });
                      var url = Uri.parse(GlobaleData.host + '/payerTickets');
                      http.post(url, body: info, headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': Authservice.token
                      }).then((resp) {
                        this.ticketresv = json.decode(resp.body);
                        print(this.ticketresv);
                        print('ticket reserve avec succes');
                      }).catchError((err) {
                        print(err);
                      });
                    });
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0),
              child: FlatButton(
                child: Text('annuler'),
                color: Colors.deepOrange,
                onPressed:  (){
                  Navigator.pop(context);
                  print('reservation annuler 12');
                }),)
            ],
          );
        });
  }

  void snacb(){
    SnackBar snackbar = new SnackBar(
      content: Text('faite vos réservations',
            textScaleFactor: 1.2,), 
      duration: new Duration(seconds: 3),);
      Scaffold.of(context).showSnackBar(snackbar);
  }
  
}
