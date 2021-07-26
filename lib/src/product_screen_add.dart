import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:inventorystar/models/product.dart';
import 'package:http/http.dart' as http;

class ProductScreenAdd extends StatefulWidget {
  final String idProduct;
  final String userEmail;

  const ProductScreenAdd({this.idProduct, this.userEmail});
  @override
  _ProductScreenAddState createState() => _ProductScreenAddState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductScreenAddState extends State<ProductScreenAdd> {
  List<Product> items;
  String auxId;

  Map data;
  List productData = new List();
  List productDataOne = new List();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _codebarController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  final TextEditingController _stockController= new TextEditingController();

  _createProduct() async {
    print("xd/${_nameController.text}");
    print(_nameController.text);
    Map data = {
      'name': _nameController.text,
      'code': _codebarController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'stock': _stockController.text,
      'expiration': 'exampleExpiration',
      'isExpiration': 'true',
      'userEmail': widget.userEmail
    };
    print("OK1");
    var body = json.encode(data);
    var response = await http.post(
        Uri.parse('https://api-inventary.herokuapp.com/api/products/'),
        headers: {"Content-Type": "application/json"},
        body: body);
    print("OK");
  }


  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
  //fin nuevo imagen

  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        //height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[

                    Divider(),
                    //nuevo para llamar imagen de la galeria o capturarla con la camara

                  ],
                ),
                TextField(
                  controller: _nameController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Name'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _codebarController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'CodeBar'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _descriptionController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.list), labelText: 'Description'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _priceController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on), labelText: 'Price'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                TextField(
                  controller: _stockController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.shop), labelText: 'Stock'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () async {
                      await _createProduct();
                      Navigator.pop(context);
                    },
                    child: (widget.idProduct != null)
                        ? Text('Update')
                        : Text('Add')

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
