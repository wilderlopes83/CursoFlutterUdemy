import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  //controler para gerenciar o input de entrada de tarefas
  final _toDoController = TextEditingController();
  //inicia a lista de tarefas
  List _toDoList = [];

  //armazena ultima remoção, permitindo desfazer...
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  //método "onload" para iniciar a aplicação
  @override
  void initState(){
    super.initState();

    //chama o _readData(), que é uma future (similar ao promise) e processa o resultado
    this._readData().then((data){
      //utiliza o setState() já que vai atualizar a tela 
      setState(() {
        //atualiza a lista, convertendo o json para objeto
        this._toDoList = json.decode(data);  
      });      
    });
  }


  void _addToDo(){
    
    setState(() {
      Map<String, dynamic> newToDo = Map(); 
      newToDo["title"] = _toDoController.text;
      //limpa o text para um novo preenchimento
      _toDoController.text = "";
      newToDo["ok"] = false;

      this._toDoList.add(newToDo);      
      this._saveData();
    });
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: 'Nova Tarefa',
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text('ADD'),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: buildItem,
            ),
          )
        ],
      )
      
    );
  }

  Widget buildItem(BuildContext context, int index){
    return Dismissible(
      //exige uma chave obrigatória. Professor resolveu utilizar a hora atual em ms
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()), 
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
      title: Text(_toDoList[index]["title"]),    
      value: _toDoList[index]["ok"],
      secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (newValue){
          setState(() {
            this._toDoList[index]["ok"] = newValue;  
            this._saveData();
          });
        },
      ),
      onDismissed: (direction){
        setState(() {
          this._lastRemoved = Map.from(this._toDoList[index]);
          this._lastRemovedPos = index;
          this._toDoList.removeAt(index);

          this._saveData();          

          final snack = SnackBar(
            content: Text("Tarefa \"${this._lastRemoved['title']}\" removida"),    
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: (){
                setState(() {
                  this._toDoList.insert(this._lastRemovedPos, this._lastRemoved);
                  this._saveData();  
                });                
              },
            ),
          );

          Scaffold.of(context).showSnackBar(snack);
          
        });
      },
    );
  }


  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    //File("${directory.path}/data.json").delete();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async{
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      return null;      
    }
  }
}

