import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flag/flag.dart';
import 'package:country_icons/country_icons.dart';

const request = "https://api.hgbrasil.com/finance?key=773d3b0d";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _clearAll() {
    setState(() {
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    });
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: <Widget>[
          //criação do botão de refresh para resetar os dados da tela
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: _clearAll,
          )
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar dados :(",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(50.0),
                                          bottomRight: Radius.circular(50.0))),
                                ),
                                Positioned(
                                  top: 0.0,
                                  left: 20.0,
                                  child: Text(
                                    "Cotação",
                                    style: TextStyle(fontSize: 20.0, fontFamily: "Quicksand", fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    padding:
                                        EdgeInsets.fromLTRB(50, 30, 50, 30),
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: Colors.green[300],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "USD",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "${dolar.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    padding:
                                        EdgeInsets.fromLTRB(50, 30, 50, 30),
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: Colors.amberAccent[400],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "EUR",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Quicksand",
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          "${euro.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 10.0),
                            child: Text(
                              "Conversor",
                              style: TextStyle(fontSize: 20.0, fontFamily: "Quicksand", fontWeight: FontWeight.bold),
                            ),
                            width: MediaQuery.of(context).size.width * 1,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.grey[100],
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: buildTextField("Reais", "BRL ",
                                      realController, _realChanged, 'BR'),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.grey[100],
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  child: buildTextField("Dolar", "USD ",
                                      dolarController, _dolarChanged, 'US'),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.grey[100],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    child: buildTextField("Euro", "EUR ",
                                        euroController, _euroChanged, 'EU')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}

buildTextField(String label, String prefix, TextEditingController txtC,
    Function f, String flag) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: txtC,
    textAlign: TextAlign.end,
    decoration: InputDecoration(
      icon: Flag(flag, height: 30, width: 50, fit: BoxFit.fill),
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      border: InputBorder.none,
      prefixText: prefix,
    ),
    onChanged: f,
  );
}
