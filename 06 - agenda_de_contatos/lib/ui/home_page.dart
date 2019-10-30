import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState(){
    super.initState();

    /* Contact c = Contact();
    c.name = "teste 2";
    c.email = "teste@gmail.com";
    c.phone = "14158242424847";
    c.img = "imgTest2";

    helper.saveContact(c);  */

    helper.getAllContacts().then((list){
      print(list);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}