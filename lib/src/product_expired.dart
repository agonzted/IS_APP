import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:inventorystar/src/product_information.dart';
import 'package:inventorystar/src/product_screen.dart';
import 'package:inventorystar/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:inventorystar/src/product_screen_add.dart';

class ListViewProductExpired extends StatefulWidget {
  final String emailUser;

  ListViewProductExpired({this.emailUser});
  @override
  _ListViewProductExpiredState createState() => _ListViewProductExpiredState();
}

class _ListViewProductExpiredState extends State<ListViewProductExpired> {

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Map data;
  List productData = new List();
  List productExpiredData = new List();

  Future<void> _getProducts() async {
    productExpiredData.clear();
    //print(widget.nameData);
    http.Response response = await http
        .get(Uri.parse('https://api-inventary.herokuapp.com/api/products'));
    data = json.decode(response.body);
    setState(() {
      productData = data['products'];
      print(productData);
      for (var x = 0; x < productData.length; x++) {
        if(productData[x]['userEmail'] == widget.emailUser) {
          if (productData[x]['isExpiration'] == "true") {
            productExpiredData.add(productData[x]);
          }
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Productos caducados'),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: RefreshIndicator(
          onRefresh: _getProducts,
          child: Center(
            child: ListView.builder(
                itemCount: productExpiredData.length,
                padding: EdgeInsets.only(top: 3.0),
                itemBuilder: (context, position) {
                  return Column(
                    children: <Widget>[
                      Divider(
                        height: 1.0,
                      ),
                      Container(
                        padding: new EdgeInsets.all(3.0),
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              //nuevo imagen
                              new Container(
                                padding: new EdgeInsets.all(5.0),
                                child: Image.network(
                                  'https://png.pngitem.com/pimgs/s/325-3256246_fa-fa-product-icon-transparent-cartoons-fa-fa.png',
                                  fit: BoxFit.fill,
                                  height: 57.0,
                                  width: 57.0,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    '${productExpiredData[position]['name']}',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${productExpiredData[position]['description']}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () {
                                    //print(productData[position]);
                                    var route = new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProductScreen(
                                                idProduct: productExpiredData[position]
                                                ['_id']));
                                    Navigator.of(context).push(route);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _showDialog(
                                    context, productExpiredData[position]['_id']),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  var route = new MaterialPageRoute(

                                      builder: (BuildContext context) =>
                                          ProductInformation(
                                              idProduct: productExpiredData[position]
                                              ['_id']));
                                  Navigator.of(context).push(route);
                                },
                              )
                            ],
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }


  void _showDialog(context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('¿Estás seguro de que quieres eliminar este producto?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await _deleteProduct(id);
                  Navigator.pop(context);
                  print("Ok");
                }),
            new FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  _deleteProduct(String id) async {
    //print(widget.nameData);
    http.Response response = await http.get(
        Uri.parse('https://api-inventary.herokuapp.com/api/products/${id}'));
  }

}