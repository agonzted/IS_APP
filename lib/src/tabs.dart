import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventorystar/src/product_expired.dart';
import 'package:http/http.dart' as http;
import 'listview_product.dart';
import 'dart:convert';

class Tabs extends StatefulWidget{


  final String emailUserData;

  Tabs({this.emailUserData});

  @override
  _Tabs createState() => _Tabs();

}



Widget products(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      
      Container(
        alignment: Alignment.centerLeft,
        height: 50,
        child: TextField(
          obscureText: true,
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.fastfood,
              color: Color(0xFF003823)
            ),
           hintText: 'Productos',
           hintStyle: TextStyle(
             color: Colors.black
           )
          ),
        ),
      )
    ],
  );
}

Widget noti(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      
      Container(
        alignment: Alignment.centerLeft,
        height: 50,
        child: TextField(
          obscureText: true,
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.notifications_active,
              color: Color(0xFF003823)
            ),
           hintText: 'Notificaciones',
           hintStyle: TextStyle(
             color: Colors.black
           )
          ),
        ),
      )
    ],
  );
}

Widget caducado(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      
      Container(
        alignment: Alignment.centerLeft,
        height: 50,
        child: TextField(
          obscureText: true,
          style: TextStyle(
            color: Colors.black87
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.date_range,
              color: Color(0xFF003823)
            ),
           hintText: 'Caducados',
           hintStyle: TextStyle(
             color: Colors.black
           )
          ),
        ),
      )
    ],
  );
}



class _Tabs extends State<Tabs>{


  Map data;
  List productData = new List();
  List productExpiredData = new List();

  Future<void> _updateProducts() async {
    productExpiredData.clear();
    var date = DateTime.now();
    http.Response response = await http
        .get(Uri.parse('https://api-inventary.herokuapp.com/api/products'));
    data = json.decode(response.body);
    setState(() async {
      productData = data['products'];
      print(productData);
      for (var x = 0; x < productData.length; x++) {
        if(productData[x]['userEmail'] == widget.emailUserData) {
          if(date.isAfter(DateTime.tryParse(productData[x]['expiration']))){
            print("expirado");
            data = {
              'name': productData[x]['name'],
              'code': productData[x]['code'],
              'description': productData[x]['description'],
              'price': productData[x]['price'],
              'stock': productData[x]['stock'],
              'expiration': productData[x]['expiration'],
              'isExpiration': 'true'
            };
            var body = json.encode(data);
            var response = await http.post(
                Uri.parse('https://api-inventary.herokuapp.com/api/products/${productData[x]['_id']}'),
                headers: {"Content-Type": "application/json"},
                body: body);
          }
        }
      }
    });
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      _updateProducts();
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
             backgroundColor: Color(0xFF00A868),
             
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.fastfood)),
                Tab(icon: Icon(Icons.date_range)),
                Tab(icon: Icon(Icons.notifications_active)),
              ],
            ),
            title: Text('Inventory⭐Star'),
          ),
          body: TabBarView(
            children: [
              ListViewProduct(emailUser: widget.emailUserData),
              ListViewProductExpired(emailUser: widget.emailUserData),
              noti(),
            ],
          ),
        ),
      ),
    );
  }
}