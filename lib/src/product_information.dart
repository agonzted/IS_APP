import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inventorystar/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ProductInformation extends StatefulWidget {
  final String idProduct;

  const ProductInformation({this.idProduct});

  @override
  _ProductInformationState createState() => _ProductInformationState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductInformationState extends State<ProductInformation> {

  TextEditingController _nameController;
  TextEditingController _codebarController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _stockController;


  @override
  void initState() {   
    super.initState();
    Future.delayed(Duration.zero, () async {
      //your async 'await' codes goes here
      await _getProduct();
      _nameController = new TextEditingController(text: productDataOne[0]['name']);
      _codebarController = new TextEditingController(text: productDataOne[0]['code']);
      _descriptionController = new TextEditingController(text: productDataOne[0]['description']);
      _priceController = new TextEditingController(text: productDataOne[0]['price']);
      _stockController = new TextEditingController(text: productDataOne[0]['stock']);
    });
  }

  Map data;
  List productData = new List();
  List productDataOne = new List();

  _getProduct() async {
    print('hola/${widget.idProduct}');
    http.Response response = await http
        .get(Uri.parse('https://api-inventary.herokuapp.com/api/products'));
    data = json.decode(response.body);
    setState(() {
      productData = data['products'];
      for (var x = 0; x < productData.length; x++) {
        if (productData[x]['_id'] == widget.idProduct) {
          productDataOne.add(productData[x]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Information'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: Container(
          height: 800.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  new Text("Name : ${_nameController.text}", style: TextStyle(fontSize: 18.0),),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Divider(),
                  new Text("Codebar : ${_codebarController.text}", style: TextStyle(fontSize: 18.0),),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Divider(),
                  new Text("Description : ${_descriptionController.text}", style: TextStyle(fontSize: 18.0),),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Divider(),
                  new Text("Price : ${_priceController.text}", style: TextStyle(fontSize: 18.0),),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Divider(),
                  new Text("Stock : ${_stockController.text}", style: TextStyle(fontSize: 18.0),),
                  Padding(padding: EdgeInsets.only(top: 8.0),),
                  Divider(),
                  Container(
                    height: 300.0,
                    width: 300.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  }
}
