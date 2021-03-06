import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:inventorystar/src/product_information.dart';
import 'package:inventorystar/src/product_screen.dart';
import 'package:inventorystar/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:inventorystar/src/product_screen_add.dart';

class ListViewProduct extends StatefulWidget {

  final String emailUser;

  ListViewProduct({this.emailUser});
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProductState extends State<ListViewProduct> {
  Map data;
  List productData = new List();
  List productExpiredData = new List();

  Future<void> _getProducts() async {
    productData.clear();
    //print(widget.nameData);
    http.Response response = await http
        .get(Uri.parse('https://api-inventary.herokuapp.com/api/products'));
    data = json.decode(response.body);
    setState(() {
      productExpiredData = data['products'];
      for(var x = 0; x < productExpiredData.length; x++) {
        if(productExpiredData[x]['userEmail'] == widget.emailUser) {
          if (productExpiredData[x]['isExpiration'] == "false") {
            productData.add(productExpiredData[x]);
          }
        }
      }
    });
  }

  

  _deleteProduct(String id) async {
    //print(widget.nameData);
    http.Response response = await http.get(
        Uri.parse('https://api-inventary.herokuapp.com/api/products/${id}'));
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Productos'),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: RefreshIndicator(
          onRefresh: _getProducts,
          child: Center(
            child: ListView.builder(
                itemCount: productData.length,
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
                                    '${productData[position]['name']}',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${productData[position]['description']}',
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
                                                idProduct: productData[position]
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
                                    context, productData[position]['_id']),
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
                                              idProduct: productData[position]
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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            //print(productData[position]);
            var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductScreenAdd(idProduct: null, userEmail:widget.emailUser));
            Navigator.of(context).push(route);
          },
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('??Est??s seguro de que quieres eliminar este producto?'),
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

  void _onProductAdded(Event event) {
    setState(() {
      productData.add(new Product.fromSnapShot(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =
        productData.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      productData[productData.indexOf(oldProductValue)] =
          new Product.fromSnapShot(event.snapshot);
    });
  }

  /*
  void _navigateToProductInformation(
      BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductScreen(product)),
    );
  }
  */

  /*
  void _navigateToProduct(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductInformation(product)),
    );
  }
   */

  /*
  void _createNewProduct(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductScreen(Product(null, '', '', '', '', '', ''))),
    );
  }
  */

}
