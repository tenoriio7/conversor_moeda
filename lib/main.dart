import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

  const request = "https://api.hgbrasil.com/finance/?format=json&key=9d623900";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(response.body);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  double dolar;
  double euro;
  double libra;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();


  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
  }

  void _euroChanged(String text) {}

  void _libraChanged(String text) {}

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor do Felipe \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,
                        ),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dolares", "US\$", dolarController,_dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController,_euroChanged),
                        Divider(),
                        buildTextField("Libra", "", libraController, _libraChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }

  Widget buildTextField(
      String label, String prefix, TextEditingController c, Function f) {
    return TextField(
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: f,
      controller: c,
      keyboardType: TextInputType.number,
    );
  }
}
