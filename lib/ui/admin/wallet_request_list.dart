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
import 'package:ecommerce/domain/WalletRequest.dart';

class WalletRequestList extends StatefulWidget {
   WalletRequestList() ;

  @override
  _WalletRequestListState createState() => _WalletRequestListState();
}

class _WalletRequestListState extends State<WalletRequestList> {

  List<WalletRequest>list_products=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWalletREquestList();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,

        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("Wallet Requests",style: TextStyle(color: Colors.black,fontSize: 15),),
        centerTitle: false,




      ),
      body: Stack(

        children: [

          (list_products.length>0)?    Align(
            alignment: FractionalOffset.topCenter,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(
                list_products.length ,
                    (i) => GestureDetector(
                    onTap: (){

                     // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsAdminPage(list_products[i].id,"user")));


                    },

                    child:
                    Padding(
                        padding: EdgeInsets.all(
                            ResponsiveInfo.isMobile(context) ? 5 : 8),
                        child: SizedBox(
                            width: double.infinity,
                            height: ResponsiveInfo.isMobile(context)
                                ? 230
                                : 260,
                            child: Card(
                              elevation:
                              ResponsiveInfo.isMobile(context) ? 5 : 8,
                              color: Colors.white,
                              child: Column(

                                children: [

                                  Expanded(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child:  Padding(
                                            padding: EdgeInsets.all(
                                                ResponsiveInfo.isMobile(context) ? 5 : 8),

                                            child:  Icon(Icons.wallet,size: ResponsiveInfo.isMobile(context)?80:160,color: Colors.black54,)),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    ResponsiveInfo.isMobile(
                                                        context)
                                                        ? 3
                                                        : 6),
                                                child: Text("Name : "+list_products[i].user_name+
                                                    "\nAccount No. : "+  list_products[i].account_number+"\nAmount : "+list_products[i].amount+"\nBank : "+list_products[i].bank+"\nIFSC code : "+list_products[i].ifsc+"\nStatus : "+list_products[i].approval_status,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: ResponsiveInfo
                                                          .isMobile(context)
                                                          ? 14
                                                          : 17),
                                                )),

                                          ],
                                        ),
                                        flex: 3,
                                      )
                                    ],
                                  ),flex: 3,),
                                  Expanded(child: (list_products[i].approval_status.compareTo("pending")==0)? Padding(
                                    padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                                    child: Container(
                                      width: double.infinity,
                                      height: ResponsiveInfo.isMobile(context) ? 50 : 65,
                                      decoration: BoxDecoration(
                                        color: Color(0xff255eab),
                                        border: Border.all(color: Color(0xff255eab)),
                                        borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          'Approve',
                                          style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                                        ),
                                        onPressed: () async {
                                          // Call a function to authenticate user

                                          Widget okButton = TextButton(
                                            child: Text("yes"),
                                            onPressed: ()async {

                                              Navigator.pop(context);

                                              showLoaderDialog(context);

                                              DateTime dtnow = new DateTime.now();
                                              String stdate = dtnow.day.toString() + "-" +
                                                  dtnow.month.toString() + "-" + dtnow.year.toString()+" "+dtnow.hour.toString()+":"+dtnow.minute.toString();

                                              await FirebaseFirestore.instance.collection('wallet_requests').doc(list_products[i].id.toString()).update({'approval_status':'approved'}).then((value) async{

                                                await FirebaseFirestore.instance.collection('wallet_balance').add({'amount': list_products[i].amount,
                                                  'date': stdate,
                                                  'type': "withdraw",
                                                  'user_id': list_products[i].user_id}).then((value) {

                                                    getWalletREquestList();
                                                   Navigator.pop(context);




                                                });

                                              });


                                            },
                                          );

                                          Widget okButton1 = TextButton(
                                            child: Text("no"),
                                            onPressed: () {

                                              Navigator.pop(context);

                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            title: Text("Wallet Request Approval"),
                                            content: Text("Do you want to aprove this wallet withdrawal request ?"),
                                            actions: [
                                              okButton,
                                              okButton1
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );




                                        },
                                      ),
                                    ),
                                  ) : Padding(
                                    padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                                    child: Text(
                                      'Approved',
                                      style: TextStyle(color: Colors.green, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                                    ),
                                  ),flex: 1,)



                                ],
                              )



                              ,
                            ))) ),
              ),
            ),
          ) : Align(
            alignment: FractionalOffset.center,
            child: Text(
              "No data found",
              style: TextStyle(
                  color: Colors.black,
                  fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold),
            ),
          )



        ],
      ),

    );
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  getWalletREquestList()async{
    final productSnapshot = await FirebaseFirestore.instance.collection('wallet_requests').get();


    List<dynamic>c=    productSnapshot.docs.toList();

list_products.clear();
    int k=0;
    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];


      var m = ab.data() as Map<String, dynamic>;
      String account_number = m['account_number'];
      String amount = m['amount'];
      String approval_status = m['approval_status'];
      String bank = m['bank'];
      String ifsc = m['ifsc'];
      String bankaddress = m['bankaddress'];
      String user_id=m['user_id'];

      setState(() {

        list_products.add(new WalletRequest(ab.id,account_number,amount,approval_status,bank,ifsc,bankaddress,user_id,""));
      });
    }

    for(int i=0;i<list_products.length;i++) {

       FirebaseFirestore.instance.collection('registration').doc(list_products[i].user_id.trim()).get().then((value) {

      var m=   value.data()!;
      setState(() {
        list_products[i].user_name=m['name'];

      });
       });


    }

  }
}
