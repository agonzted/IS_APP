import 'dart:convert';

import 'package:inventorystar/src/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inventorystar/src/tabs.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

var bandera;
Map data;
List usersData = new List();
List userData = new List();

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 50,
        child: TextField(
          controller: passwordController,
          obscureText: true,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.lock, color: Color(0xFF003823)),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

Widget buildUsuario() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 50,
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.person, color: Color(0xFF003823)),
              hintText: 'Correo',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ],
  );
}

Widget buildSignUpBtn(BuildContext context) {
  return GestureDetector(
    onTap: () => {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Registro()),
      ),
    },
    child: RichText(
        text: TextSpan(children: [
      TextSpan(
        text: 'No tienes una cuenta?',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      TextSpan(
          text: ' Registraste',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
    ])),
  );
}

class _Login extends State<Login> {
  Future<bool> _getUsers() async {
    userData.clear();
    bandera = false;
    http.Response response =
        await http.get(Uri.parse('https://api-inventary.herokuapp.com/api/users'));
    data = json.decode(response.body);
    setState(() {
      usersData = data['users'];
    });
    var contador = 0;
    for (var i = 0; i < usersData.length; i++) {
      if (emailController.text == usersData[i]['email']) {
        if (passwordController.text == usersData[i]['password']) {
          userData.add(usersData[i]);
          bandera = true;
          return bandera;
        } else {
          return bandera;
        }
      } else {
        contador++;
        if (contador == usersData.length) {
          return bandera;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
              child: Stack(
            children: <Widget>[
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0xFF00A868),
                        Color(0xFF00A868),
                        Color(0xFF016840),
                        Color(0xFF003823),
                      ])),
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/inventoryStar.png",
                              width: 100.0,
                              height: 100.0,
                            ),
                            Text(
                              'Inventory⭐Star',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            buildUsuario(),
                            SizedBox(
                              height: 20,
                            ),
                            buildPassword(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5,
                                onPressed: () async {
                                  if (await _getUsers()) {
                                    var route = new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Tabs(emailUserData: userData[0]['email']),
                                    );

                                    Navigator.of(context).push(route);
                                  } else {
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('ERROR'),
                                          content: Text(
                                              'usuario y/o contraseña incorrecto'),
                                          actions: <Widget>[
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: new Text('ok'))
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: Colors.white,
                                child: Text('LOGIN',
                                    style: TextStyle(
                                        color: Color(0xFF003823),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            buildSignUpBtn(context),
                          ])))
            ],
          ))),
    );
  }
}
