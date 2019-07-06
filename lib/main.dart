import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=119437a0";

void main() async {
  //assincrona
  //print(await getData());
  runApp(MaterialApp(
    home: TelaPrincipal(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}
//Função que vai converter a string vinda da API
Future<Map> getData() async {
  http.Response response = await http.get(
      request); //await , espera a requisição  responder e salva os dados em response
  return json.decode(response.body);
}

// Função pra carregar gerar os textFildes 
Widget textosParaTextField(
    String label, String prefix, TextEditingController c, Function f ) {
  return TextField(
      controller: c,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: f, 
      );

}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  double dolar, euro;
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _alterarReal(String texto){
    if(texto.isEmpty){
      _limparCampos();
      return;
    }
    double real = double.parse(texto);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _alterarDolar(String texto){
    if(texto.isEmpty){
      _limparCampos();
      return;
    }
    double dolar = double.parse(texto);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    print(this.dolar);
  }
  void _alterarEuro(String texto){
    if(texto.isEmpty){
      _limparCampos();
      return;
    }
    double euro = double.parse(texto);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    print(this.euro); // para debug
  }

  void _limparCampos(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor de Moedas \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none: //snapshot não conectado
                case ConnectionState.waiting: // ou esperando conexão
                  return Center(
                    child: Text(
                      "Carregando Dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao Carregar Dados...",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

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
                          textosParaTextField("Reais", "R\$ ", realController, _alterarReal),
                          Divider(),
                          textosParaTextField("Dólares", "US\$ ", dolarController, _alterarDolar),
                          Divider(),
                          textosParaTextField("Euro", "\€ ", euroController, _alterarEuro)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}


