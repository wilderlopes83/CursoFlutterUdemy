import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String _infoText = 'Informe seus dados';

  void _resetFields(){
    setState(() {
      weightController.text = '';
      heightController.text = '';

      _infoText = 'Informe seus dados';  
      _formKey = GlobalKey<FormState>(); //para resetar eventuais mensagens de erro do form
      //_formKey.currentState.reset();
    });     
  }

  void _calculate(){
    setState(() {      
    
        double weight = double.parse(weightController.text);
        double height = double.parse(heightController.text)/100;
        double imc = (weight/(height*height));

        String aux = '';
        
        if (imc < 18.6){
          aux = 'Abaixo do peso';
        }
        else if (imc >= 18.6 && imc < 24.9){
          aux = 'Peso ideal';
        }
        else if (imc >= 24.9 && imc < 29.9){
          aux = 'Levemente acima do peso';
        }
        else if (imc >= 29.9 && imc < 34.9){
          aux = 'Obesidade Grau I';
        }        
        else if (imc >= 34.9 && imc < 39.9){
          aux = 'Obesidade Grau II';
        }                
        else{
          aux = 'Obesidade Grau II';
        }                        
        
        _infoText = '$aux (${imc.toStringAsPrecision(4)})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _resetFields();
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120.0, color: Colors.green,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(color: Colors.green) 
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                controller: weightController,
                validator: (value){
                  if (value.isEmpty){
                    return "Insira seu peso!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  labelStyle: TextStyle(color: Colors.green) 
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                controller: heightController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Insira sua altura!';
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: (){
                      if (_formKey.currentState.validate()){
                        _calculate();

                        //sumir o teclado para maximizar a UI
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                    },
                    child: Text('Calcular', style: TextStyle(color: Colors.white, fontSize: 25.0),),
                    color: Colors.green,            
                  ),
                ),
              ),
              Text(_infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),              
              )            
            ],
          ),
        )
      ),
    );
  }
}