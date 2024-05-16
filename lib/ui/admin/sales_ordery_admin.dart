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

import '../../domain/CountryData.dart';
import '../../domain/SalesOrderItems.dart';

class SalesOrderyAdmin extends StatefulWidget {
   SalesOrderyAdmin() ;

  @override
  _SalesOrderyAdminState createState() => _SalesOrderyAdminState();
}

class _SalesOrderyAdminState extends State<SalesOrderyAdmin> {


  List<SalesOrderData>sdata = [];
  List<String>countrylist = [];

  String selectedcountry = "";
  String selecteddate = "";
  double totalamount = 0;
  List<CountryData>countrycodelist = [];

  List<String>OrderIddata = ["Order ID"];

  var selectedDate = DateTime.now();

  late CountryData cdata;
  String dropdownvalue = 'pending',
      address = "";

  String name = "";
  String email = "";
  String image = "";

  // List of items in our dropdown menu
  var items = [
    'pending',
    'ordered',
    'Delivered'

  ];
  List<SalesOrderItems>cartdata = [];

  String select_orderid = "Order ID",membertype="";

  getCountryList() async {
    final productSnapshot1 = await FirebaseFirestore.instance.collection(
        'countryList').get();

    List<dynamic>c = productSnapshot1.docs.toList();
    bool a = false;
    countrylist.clear();
    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;


      String name = m['name'];
      String code = m['countrycode'];
      String id = ab.id;
      String conversionfactor=m['ConversionFactor'];
      String currency_symbol="";

      if(m.containsKey("currency_symbol"))
      {
        currency_symbol=m['currency_symbol'];
      }

      CountryData data = new CountryData(id, name, code,conversionfactor,currency_symbol);

      setState(() {
        countrycodelist.add(data);
        countrylist.add(code);
        if (i == 0) {
          cdata = countrycodelist[i];
          selectedcountry = code;
        }
      });
    }


    // countryList
  }

  getCartCount() async {
    // final preferenceDataStorage = await SharedPreferences
    //     .getInstance();
    // String? uid=  preferenceDataStorage.getString(Constants.pref_userid);
    //
    // String? countryid=  preferenceDataStorage.getString(Constants.pref_countrycode);

    showLoaderDialog(context);


    final productSnapshot = await FirebaseFirestore.instance.collection(
        'sales_orders').get();

    Navigator.pop(context);
    List<dynamic>c = productSnapshot.docs.toList();
    String countryid = "";
    cartdata.clear();

    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String userid = m['user_id'];
      String product_id = m['product_id'];
      String productmaster_id = m['product_master_id'];
      String qty = m['qty'];
      String order_id = m['order_id'];
      String order_number = m['order_number'].toString();
      String cartid = ab.id;
      String date = m['date'];

      countryid = m['country_code'];

      if (select_orderid.trim().compareTo(order_number) == 0) {
       // if (selectedcountry.compareTo(countryid) == 0) {
          if (date.compareTo(selecteddate) == 0) {
            SalesOrderItems c1 = SalesOrderItems(
                cartid,
                userid.trim(),
                qty,
                "",
                "",
                "",
                "",
                product_id,
                productmaster_id,
                order_id,"","");
            setState(() {
              cartdata.add(c1);
            });
          }
       // }
      }
    }

    if(cartdata.length>0)
      {
        getUserDetails();
      }


    for (int j = 0; j < cartdata.length; j++) {
      String product_id = cartdata[j].product_id;
      String productmaster_id = cartdata[j].productmaster_id;

      FirebaseFirestore.instance.collection('products').doc(product_id)
          .get()
          .then((value) {
        var m1 = value.data()!;
        String unitprice = "";
        if (countryid.toString().trim().compareTo("+91") == 0) {
          unitprice = m1['actual_amount_domestic'];
        }
        else {
          unitprice = m1['international_actual_price'];
        }


        // String unitprice=m1['Amount'];
        String units = m1['units'];

        for (int k = 0; k < cartdata.length; k++) {
          if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
              0) {
            setState(() {
              cartdata[k].unitprice = unitprice;
            });

            calculateTotal();
          }
        }

        FirebaseFirestore.instance.collection('units').doc(units.trim())
            .get()
            .then((value1) {
          var m3 = value1.data()!;
          String unitname = m3['name'];

          for (int k = 0; k < cartdata.length; k++) {
            if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
                0) {
              setState(() {
                cartdata[k].unitname = unitname;
              });

              calculateTotal();
            }
          }

          FirebaseFirestore.instance.collection('product_master').doc(
              productmaster_id).get().then((value2) {
            var m2 = value2.data()!;
            String name = m2['name'];
            String image = m2['image'];

            for (int k = 0; k < cartdata.length; k++) {
              if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
                  0) {
                setState(() {
                  cartdata[k].name = name;
                  cartdata[k].image = image;
                });

                calculateTotal();
              }
            }
          });
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selecteddate =
        selectedDate.day.toString() + "-" + selectedDate.month.toString() +
            "-" + selectedDate.year.toString();
    // getCartCount();
    // getOrderIds();
    // getCartCount();
    getCountryList();
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
          "Orders",
          style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveInfo.isMobile(context) ? 15 : 18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),


      ),

      body: Stack(

        children: [

          Align(
              alignment: FractionalOffset.topCenter,
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(

                      children: [

                        Expanded(child: Padding(padding: EdgeInsets.all(10),

                          child: Container(
                            width: double.infinity,
                            height: ResponsiveInfo.isMobile(context) ? 55 : 65,
                            padding: EdgeInsets.all(
                                ResponsiveInfo.isMobile(context) ? 3 : 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  ResponsiveInfo.isMobile(context) ? 10 : 15)),
                            ),

                            child: GestureDetector(

                              child: Row(

                                children: [

                                  Expanded(
                                    child: Text(selecteddate, style: TextStyle(
                                        fontSize: ResponsiveInfo.isMobile(
                                            context) ? 13 : 17),), flex: 2,)
                                  ,
                                  Expanded(child: IconButton(onPressed: () {

                                  },
                                      icon: Icon(
                                        Icons.date_range, color: Colors.black87,
                                        size: ResponsiveInfo.isMobile(context)
                                            ? 15
                                            : 18,)), flex: 1,)


                                ],
                              ),

                              onTap: () {
                                _selectDate(context);
                              },
                            ),


                          ),


                        ), flex: 1,)

                        ,

                        Expanded(child: Padding(padding: EdgeInsets.all(10),

                          child: Container(
                              width: double.infinity,
                              height: ResponsiveInfo.isMobile(context)
                                  ? 55
                                  : 65,
                              padding: EdgeInsets.all(
                                  ResponsiveInfo.isMobile(context) ? 3 : 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ResponsiveInfo.isMobile(context)
                                        ? 10
                                        : 15)),
                              ),

                              child: DropdownButton<String>(
                                value: select_orderid,
                                onChanged: (value) {
                                  setState(() {
                                    select_orderid = value!;

                                    // for(int j=0;j<countrycodelist.length;j++)
                                    // {
                                    //
                                    //   if(selectedcountry.trim().compareTo(countrycodelist[j].code.trim())==0)
                                    //   {
                                    //
                                    //     cdata=countrycodelist[j];
                                    //
                                    //     break;
                                    //   }
                                    //
                                    //
                                    // }


                                  });
                                },
                                items: OrderIddata.map((String hsnCode) {
                                  return DropdownMenuItem<String>(
                                    value: hsnCode,
                                    child: Text(hsnCode),
                                  );
                                }).toList(),
                                disabledHint: Text(""),
                              )

                          ),


                        ), flex: 1,)


                      ],
                    ),

                    // Padding(padding: EdgeInsets.all(
                    //     ResponsiveInfo.isMobile(context) ? 10 : 15),
                    //
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: ResponsiveInfo.isMobile(context) ? 55 : 65,
                    //     padding: EdgeInsets.all(
                    //         ResponsiveInfo.isMobile(context) ? 3 : 7),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.black54),
                    //       borderRadius: BorderRadius.all(
                    //           Radius.circular(ResponsiveInfo.isMobile(context)
                    //               ? 10
                    //               : 15)),
                    //     ),
                    //     child: DropdownButton<String>(
                    //       value: selectedcountry,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedcountry = value!;
                    //
                    //           for (int j = 0; j < countrycodelist.length; j++) {
                    //             if (selectedcountry.trim().compareTo(
                    //                 countrycodelist[j].code.trim()) == 0) {
                    //               cdata = countrycodelist[j];
                    //
                    //               break;
                    //             }
                    //           }
                    //         });
                    //       },
                    //       items: countrylist.map((String hsnCode) {
                    //         return DropdownMenuItem<String>(
                    //           value: hsnCode,
                    //           child: Text(hsnCode),
                    //         );
                    //       }).toList(),
                    //       disabledHint: Text(""),
                    //     ),
                    //   ),
                    //
                    // ),


                    Padding(
                      padding: EdgeInsets.all(
                          ResponsiveInfo.isMobile(context) ? 10 : 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff255eab),
                          border: Border.all(color: Color(0xff255eab)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(ResponsiveInfo.isMobile(context)
                                  ? 10
                                  : 15)),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            // Save user details to Firestore

                            if (select_orderid.compareTo("Order ID") != 0) {
                              getCartCount();
                            }
                            else {
                              ResponsiveInfo.showAlertDialog(
                                  context, "", "Please Select Order Id");
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white,
                                fontSize: ResponsiveInfo.isMobile(context)
                                    ? 12
                                    : 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    (cartdata.length > 0)?   Padding(
                      padding: EdgeInsets.all(
                          ResponsiveInfo.isMobile(context) ? 10 : 15),
                      child: Text("Delivery Address : \n\n"+address,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:15),),
                    ) : Container(),

                    (cartdata.length > 0)?   Padding(
                      padding: EdgeInsets.all(
                          ResponsiveInfo.isMobile(context) ? 10 : 15),
                      child: Text("Ordered User : \n\n"+name+"\n"+email+"\n"+membertype,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:15),),
                    ) : Container(),

                    Padding(
                        padding: EdgeInsets.all(
                            ResponsiveInfo.isMobile(context) ? 10 : 15),
                        child: (cartdata.length > 0) ? ListView.builder(
                            itemCount: cartdata.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                width: double.infinity,
                                height: ResponsiveInfo.isMobile(context)
                                    ? 150
                                    : 180,

                                child: Card(
                                    elevation: 8,
                                    child: Row(

                                      children: [

                                        Expanded(
                                          child: (cartdata[i].image.isNotEmpty)
                                              ?
                                          Padding(padding: EdgeInsets.all(10),

                                            child: Image.network(
                                              cartdata[i].image,),
                                          )

                                              : Container(), flex: 1,),

                                        Expanded(child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,

                                          children: [
                                            (cartdata[i].name.isNotEmpty &&
                                                cartdata[i].unitname.isNotEmpty)
                                                ? Text(cartdata[i].name + " " +
                                                cartdata[i].unitname,
                                              style: TextStyle(
                                                  fontSize: ResponsiveInfo
                                                      .isMobile(context)
                                                      ? 13
                                                      : 15,
                                                  color: Colors.black),)
                                                :

                                            Text("", style: TextStyle(
                                                fontSize: ResponsiveInfo
                                                    .isMobile(context)
                                                    ? 13
                                                    : 15,
                                                color: Colors.black),),

                                            (cartdata[i].unitprice.isNotEmpty)
                                                ? Text("Unit Price : " +
                                                cartdata[i].unitprice,
                                              style: TextStyle(
                                                  fontSize: ResponsiveInfo
                                                      .isMobile(context)
                                                      ? 13
                                                      : 15,
                                                  color: Colors.black),)
                                                :
                                            Text("", style: TextStyle(
                                                fontSize: ResponsiveInfo
                                                    .isMobile(context)
                                                    ? 13
                                                    : 15,
                                                color: Colors.black),),

                                            Text(
                                              "\n Quantity : " +
                                                  cartdata[i].qty,
                                              style: TextStyle(
                                                  fontSize: ResponsiveInfo
                                                      .isMobile(context)
                                                      ? 13
                                                      : 15),
                                            ),


                                          ],
                                        )


                                        )


                                      ],
                                    )


                                ),
                              );
                            }) : Align(
                          alignment: FractionalOffset.center,
                          child: Padding(padding: EdgeInsets.all(5),
                            child: Text("No data found", style: TextStyle(
                                fontSize: ResponsiveInfo.isMobile(context)
                                    ? 13
                                    : 15, color: Colors.black),),


                          ),
                        )

                    )


                  ],
                )
                ,
              )


          )


        ],
      ),

    );
  }


  getOrderIds() async {
    // final preferenceDataStorage = await SharedPreferences
    //     .getInstance();
    // String? uid=  preferenceDataStorage.getString(Constants.pref_userid);

    showLoaderDialog(context);

    final productSnapshot = await FirebaseFirestore.instance.collection(
        'sales_order').get();

    Navigator.pop(context);

    List<dynamic>c = productSnapshot.docs.toList();

    OrderIddata.clear();
    OrderIddata.add(select_orderid);

    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String date = m['date'];
      // String total_amount=m['total_amount'];
      // String order_status=m['order_status'];
      //
      // String address_id=m['address_id'];
      // String user_id=m['userid'];


      String order_number = m['order_number'].toString();
      String id = ab.id;


      if (date.compareTo(selecteddate) == 0) {
        setState(() {
          OrderIddata.add(order_number);
        });
      }
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;

        selecteddate =
            selectedDate.day.toString() + "-" + selectedDate.month.toString() +
                "-" + selectedDate.year.toString();
        getOrderIds();
      });
  }

  calculateTotal() {
    double t = 0;

    for (int k = 0; k < cartdata.length; k++) {
      int q = 0;

      if (cartdata[k].qty.isNotEmpty) {
        q = int.parse(cartdata[k].qty);

        if (cartdata[k].unitprice.isNotEmpty) {
          double p = double.parse(cartdata[k].unitprice);
          t = t + (p * q);
        }
      }
    }

    setState(() {
      totalamount = t;
    });
  }


  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  getUserDetails() async {
    showLoaderDialog(context);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance.collection('sales_order').get();
    Navigator.pop(context);

    // If query returns a document, check if it's an admin

    List<dynamic>c=    querySnapshot.docs.toList();

    for(int i=0;i<c.length;i++) {

      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      String ordid = m['order_number'].toString();
      if(ordid.trim().compareTo(select_orderid)==0) {
        // String userType = querySnapshot.docs.first.data()['usertype'];
        String userid = m['userid'];

        String address_id = m['address_id'];
        String total_amount = m['total_amount'];
        setState(() {
          totalamount = double.parse(total_amount.trim());
        });

        getAddressList(address_id);
        getOrderedUserID(userid);

      break;

      }
    }

  }

  getAddressList(String address_id) async
  {

    showLoaderDialog(context);
    final productSnapshot = await FirebaseFirestore.instance.collection(
        'addresslist').doc(address_id).get().then((value) {
      Navigator.pop(context);
      Map<String, dynamic> m = value.data()!;

      // String userid = m['userid'];
      String address1 = m['address'];

      setState(() {
        address = address1;
      });
    });
  }

  getOrderedUserID(String userid) async {
    // final preferenceDataStorage = await SharedPreferences
    //     .getInstance();
    // String? id = preferenceDataStorage.getString(Constants.pref_userid);
    showLoaderDialog(context);

    await FirebaseFirestore.instance.collection('registration').doc(userid)
        .get()
        .then((value) {

          Navigator.pop(context);
      Map<String, dynamic> m = value.data()!;

      setState(() {
        name = m['name'];
        email = m['email'];
        membertype=m['membertype'];
        image = m['image'];
      });
    });
  }
}
