import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
//nuevo para imagenes
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:inventorystar/models/product.dart';
import 'package:http/http.dart' as http;

File image;
String filename;

class ProductScreen extends StatefulWidget {
  final String idProduct;
  final String emailUser;

  const ProductScreen({this.idProduct, this.emailUser});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductScreenState extends State<ProductScreen> {
  List<Product> items;
  String auxId;

  Map data;
  List productData = new List();
  List productDataOne = new List();
  String name;
  String code;
  String description;
  String price;
  String stock;

  _getProduct() async {
    //print('hola/${_auxController.text}');
    http.Response response = await http
        .get(Uri.parse('https://api-inventary.herokuapp.com/api/products'));
    data = json.decode(response.body);
    setState(() {
      productData = data['products'];
      for (var x = 0; x < productData.length; x++) {
        if (productData[x]['_id'] == _auxController.text) {
          productDataOne.add(productData[x]);
        }
      }
    });
  }

  _updateProduct() async {
    auxId = _auxController.text;
    Map data = {
      'name': _nameController.text,
      'code': _codebarController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'stock': _stockController.text,
      'expiration': _expiredController.text,
      'isExpiration': 'false'
    };
    print("OK1");
    var body = json.encode(data);
      var response = await http.post(
          Uri.parse('https://api-inventary.herokuapp.com/api/products/${auxId}'),
          headers: {"Content-Type": "application/json"},
          body: body);
      print("OK");
  }


  TextEditingController _auxController;
  TextEditingController _nameController;
  TextEditingController _codebarController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _stockController;
  TextEditingController _expiredController;

  //nuevo imagen
  String productImage;

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
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
    _auxController = new TextEditingController(text: widget.idProduct);
    Future.delayed(Duration.zero, () async {
      //your async 'await' codes goes here
      await _getProduct();
      _nameController = new TextEditingController(text: productDataOne[0]['name']);
      _codebarController = new TextEditingController(text: productDataOne[0]['code']);
      _descriptionController = new TextEditingController(text: productDataOne[0]['description']);
      _priceController = new TextEditingController(text: productDataOne[0]['price']);
      _stockController = new TextEditingController(text: productDataOne[0]['stock']);
      _expiredController = new TextEditingController(text: productDataOne[0]['expiration']);
      productImage =
          'https://png.pngitem.com/pimgs/s/325-3256246_fa-fa-product-icon-transparent-cartoons-fa-fa.png';
    });
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
                TextField(
                  controller: _expiredController,
                  style:
                  TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.access_time), labelText: 'Expiration'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () async {
                      await _updateProduct();
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
