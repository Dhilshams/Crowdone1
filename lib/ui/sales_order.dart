import 'package:ecommerce/ui/sales_order_itemsof_others.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
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
import 'package:badges/badges.dart' as badge;
import 'package:ecommerce/domain/CartData.dart';
import 'package:ecommerce/domain/Address.dart';
import 'package:ecommerce/ui/address_list.dart';
import 'package:ecommerce/ui/home.dart';
import 'package:ecommerce/domain/SalesOrderData.dart';
import 'package:ecommerce/ui/sales_order_items_page.dart';

class SalesOrder extends StatefulWidget {
   SalesOrder() ;

  @override
  _SalesOrderState createState() => _SalesOrderState();
}

class _SalesOrderState extends State<SalesOrder> {


  List<SalesOrderData>sdata=[];

  String membershiptype="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartCount();

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff1f5f9),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {

              Navigator.pop(context);

            }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "My Orders",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),

        actions: [

          (!membershiptype.contains("Customer"))? Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 8 :16),

            child: GestureDetector(

              child: Icon(Icons.list_alt,size:ResponsiveInfo.isMobile(context)? 25 :30,color: Colors.black, ),

              onTap: (){


                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                        SalesOrderItemsofOthers()
                    )
                );

              },
            ),

          ):Container()

        ],



      ),

      body: Stack(

        children: [

          Align(
          alignment: FractionalOffset.topCenter,
        child:      ListView.builder(
            itemCount: sdata.length,
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 5 : 8),
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return Card(

                child: ListTile(
                  leading:  Icon(Icons.list,size:ResponsiveInfo.isMobile(context)? 20 : 25,color: Colors.black54,),
                  trailing: TextButton(

                    child:Text(
                      "View",
                      style: TextStyle(color: Colors.blueAccent, fontSize: ResponsiveInfo.isMobile(context)? 13:16),
                    ) ,
                    onPressed: (){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SalesOrderItemsPage(sdata[index].address_id,sdata[index].id,sdata[index].order_status)),
                      );

                    },
                  )


                  ,
                  title: Text("Order ID : "+sdata[index].order_number+"\n" +sdata[index].date+"\nTotal Amount :"+sdata[index].amount,      style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)? 13:16)),
                  subtitle: Text(
                    sdata[index].order_status,
                    style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)? 13:16),
                  ),

                ),




              )


              ;
            }),
      )














        ],
      ),

    );
  }




  getCartCount()async{

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? uid=  preferenceDataStorage.getString(Constants.pref_userid);
    setState(() {
      membershiptype=preferenceDataStorage.getString(Constants.mtype).toString();
    });
    final productSnapshot = await FirebaseFirestore.instance.collection('sales_order').get();


    List<dynamic>c=    productSnapshot.docs.toList();



    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String date=m['date'];
      String total_amount=m['total_amount'];
      String order_status=m['order_status'];

      String address_id=m['address_id'];
      String user_id=m['userid'];
      String order_number=m['order_number'].toString();
      String id=ab.id;
      if(user_id.compareTo(uid.toString())==0) {
        SalesOrderData sd = new SalesOrderData(
            id, address_id, total_amount, order_status,
            user_id, date,order_number);

        setState(() {
          sdata.add(sd);
        });
      }

    }







  }
}
