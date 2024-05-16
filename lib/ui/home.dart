import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ecommerce/designs/ResponsiveInfo.dart';

import 'package:flutter/material.dart';
import 'package:ecommerce/ui/dashboard.dart';
import 'package:ecommerce/ui/wallets.dart';
import 'package:ecommerce/ui/profile.dart';
import 'package:ecommerce/ui/pre_orders.dart';
import 'package:ecommerce/ui/sales_order.dart';
import 'package:badges/badges.dart' as badge;
import 'package:ecommerce/ui/cart_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';
import 'package:ecommerce/domain/ProductVariants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';






  class MyDashboardPage extends StatefulWidget {
  MyDashboardPage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  _MyDashboardPage createState() => _MyDashboardPage();
  }

  class _MyDashboardPage extends State<MyDashboardPage> {
  int _counter = 0;
  int _selectedIndex=0;
  int a=0;

  bool _fromTop=true;

  // final dbHelper = new DatabaseHelper();

  static  List<Widget> _pages = <Widget>[


    Dashboard(),
    Wallets(),
PreOrders()


  ];



  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  getCartCount();
  }




  @override
  void dispose() {

    super.dispose();
  }



  void _incrementCounter() {
  setState(() {
  // This call to setState tells the Flutter framework that something has
  // changed in this State, which causes it to rerun the build method below
  // so that the display can reflect the updated values. If we changed
  // _counter without calling setState(), then the build method would not be
  // called again, and so nothing would appear to happen.
  // _counter++;
  });
  }

  @override
  Widget build(BuildContext context) {
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.

  //252c45
  return Scaffold(

      backgroundColor: Color(0xfff1f5f9),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SalesOrder()),
              );

            }, icon: Icon(Icons.menu,color: Colors.black,)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          (_selectedIndex==0)? "Dashboard" : (_selectedIndex==1)?"Wallet" : "Pre-Order",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),
        actions: [

          Padding(padding: EdgeInsets.all(15),

              child: GestureDetector(

                child:   badge.Badge(
                  child: Icon(Icons.shopping_cart,size: 25,color: Colors.black54,),
                  badgeContent: Text(a.toString(),style: TextStyle(fontSize: 12),),
                ) ,
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));


                },
              )




          ),

          Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 8 :16),

            child: GestureDetector(

              child: Icon(Icons.person_outline,size:ResponsiveInfo.isMobile(context)? 25 :30,color: Colors.black, ),

              onTap: (){


                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                        Profile()
                    )
                );

              },
            ),

          )


        ],

      ),

      body: Container(

          height: double.infinity,
          width: double.infinity,


          child:Stack(  alignment: Alignment.topLeft,  children: <Widget>[


            Align(
                child:Column(

              children: [
                Expanded(child: Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),

        // padding: const EdgeInsets.all(20),

        child:_pages.elementAt(_selectedIndex),),flex: 8,
  ),


                Expanded(child:
                    Container(










    )


                ,flex: 1,)
                
                
            ],
              
              
          )
            ),

            Align(

              alignment: Alignment.bottomCenter,child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.white,
                showUnselectedLabels: true,


                onTap:_onItemTap ,

                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(


                    icon: ImageIcon(AssetImage('assets/images/barlinechart.png')),
                    label: 'Dashboard',

                  ),

                  // BottomNavigationBarItem(
                  //   icon: ImageIcon(AssetImage('images/network.png')),
                  //   label: 'Network',
                  //   backgroundColor: Color(0xff096c6c),
                  //
                  //
                  // ),

                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/wallet.png')),
                    label: 'Wallet',
                    backgroundColor: Color(0xff096c6c),

                  ),

                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/images/shoppingcart.png')),
                    label: 'Pre-Order',
                    backgroundColor: Color(0xff096c6c),


                  ),




                ]

            ),)



          ],







          )


      )

  );

  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getCartCount()async{

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? uid=  preferenceDataStorage.getString(Constants.pref_userid);

    final productSnapshot = await FirebaseFirestore.instance.collection('cart').get();


    List<dynamic>c=    productSnapshot.docs.toList();

    a=0;

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String userid=m['userid'];
      if(userid.compareTo(uid.toString())==0)
      {

        setState(() {
          a=a+1;

        });
      }


    }


  }


}



