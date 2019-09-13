import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json-cors&key=b46bd995';

void main() async{
  
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    )
  ));
} 

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    if (text.isEmpty){
      this._clearAll();
    }else{
      double real = double.parse(text.replaceAll(',', '.'));
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text){
    if (text.isEmpty){
      this._clearAll();
    }else{
      double dolarInput = double.parse(text.replaceAll(',', '.'));
      realController.text = (dolarInput*this.dolar).toStringAsFixed(2);
      euroController.text = (dolarInput*this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text){
    if (text.isEmpty){
      this._clearAll();
    }else{    
      double euroInput = double.parse(text.replaceAll(',', '.'));
      realController.text = (euroInput*this.euro).toStringAsFixed(2);
      dolarController.text = (euroInput*this.euro / dolar).toStringAsFixed(2);
    }
  }    

  void _clearAll(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: 
                  Text('Carregando dados..',
                    style: TextStyle(
                        color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )
              );
            default:
              if (snapshot.hasError){
                return Center(
                  child: 
                    Text('Carregando dados..',
                      style: TextStyle(
                          color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    )
                  );
              }
              else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextField('Reais', 'R\$ ', realController, _realChanged),                                     
                      Divider(),
                      buildTextField('Dólares', 'US\$ ', dolarController, _dolarChanged),                                     
                      Divider(),   
                      buildTextField('Euros', '€ ', euroController, _euroChanged),                                     
                    ],
                  ),
                );
              }
          }
        }
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.amber),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide( color:Colors.amber)),
            border: OutlineInputBorder(borderSide: BorderSide( color:Colors.amber)) ,   
            prefixText: prefix, prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0)
          ),
          style: TextStyle(color: Colors.amber, fontSize: 25.0),
          onChanged: f,
          keyboardType: TextInputType.numberWithOptions(decimal: true) //TextInputType.number, //.number funciona com casas decimais apenas no android
        );
}