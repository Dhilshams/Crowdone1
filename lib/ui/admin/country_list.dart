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
import 'package:ecommerce/ui/cart_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/domain/CountryData.dart';

class CountryList extends StatefulWidget {
   CountryList() ;

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {


  List<CountryData>countrylist = [];

  TextEditingController countryController = new TextEditingController();

  TextEditingController codeController = new TextEditingController();

  TextEditingController conversionController = new TextEditingController();

  TextEditingController currencysymbolController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCountryList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text(
          "Country List", style: TextStyle(color: Colors.black, fontSize: 15),),
        centerTitle: false,
        actions: [


          Padding(padding: EdgeInsets.all(15),

              child: GestureDetector(

                child: Icon(Icons.add, size: 25, color: Colors.black,),

                onTap: () {
                  AddCountryData();
                },
              )


          )
        ],


      ),

      body: Stack(

        children: [

          Align(
            alignment: FractionalOffset.topCenter,

            child: ListView.builder(
                itemCount: countrylist.length,
                padding: EdgeInsets.all(
                    ResponsiveInfo.isMobile(context) ? 5 : 10),
                itemBuilder: (BuildContext context, int index) {
                  return Card(

                    child: ListTile(
                      leading: Icon(Icons.flag, color: Colors.black54,
                        size: ResponsiveInfo.isMobile(context) ? 20 : 25,),
                      trailing:TextButton(

                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.green,
                              fontSize: ResponsiveInfo.isMobile(context)
                                  ? 13
                                  : 17),
                        ),
                        onPressed: (){

                          EditCountryData(countrylist[index].id,countrylist[index].name,countrylist[index].code,countrylist[index].conversionfactor,countrylist[index].currency_symbol);

                        },
                      )

                      ,
                      title: Text(countrylist[index].name, style: TextStyle(
                          color: Colors.black87,
                          fontSize: ResponsiveInfo.isMobile(context)
                              ? 13
                              : 17)),

                      subtitle: Text(countrylist[index].code, style: TextStyle(
                          color: Colors.black87,
                          fontSize: ResponsiveInfo.isMobile(context)
                              ? 11
                              : 14)),


                    ),
                  )


                  ;
                }),
          )


        ],
      ),

    );
  }


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
        countrylist.add(data);
      });
    }


    // countryList
  }

  AddCountryData() async
  {
    Widget okButton1 = TextButton(
      child: Text("ok"),
      onPressed: () async {
        if (!countryController.text.isEmpty) {
          if (!codeController.text.isEmpty) {
            if (!conversionController.text.isEmpty) {
              if(!currencysymbolController.text.isEmpty) {
                final productRef = FirebaseFirestore.instance.collection(
                    'countryList').doc();
                await productRef.set({
                  'name': countryController.text,
                  'countrycode': codeController.text,
                  'ConversionFactor': conversionController.text,
                  'currency_symbol': currencysymbolController.text
                }).then((value) {
                  codeController.clear();
                  countryController.clear();
                  conversionController.clear();
                  currencysymbolController.clear();

                  Navigator.pop(context);


                  getCountryList();
                });
              }
              else{
                ResponsiveInfo.showAlertDialog(context, "", "Enter currency symbol");

              }
            }
            else{

              ResponsiveInfo.showAlertDialog(context, "", "Enter currency conversion factor");
            }
          }
          else {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('Enter country code'),
            // ));

            ResponsiveInfo.showAlertDialog(context, "", "Enter country code");

          }
        }
        else {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Enter country name'),
          // ));

          ResponsiveInfo.showAlertDialog(context, "", "Enter country name");

        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(),
      content: SingleChildScrollView(

        child:Column(

          children: [

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country name',
                  hintText: 'Country name',
                ),
                controller: countryController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country Code',
                  hintText: 'Country Code',
                ),
                controller: codeController,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 2 : 5),
              child: Text(
                "Base Currecncy is INR", style: TextStyle(color: Colors.black, fontSize: 10),),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Conversion Factor',
                  hintText: 'Conversion Factor',
                ),
                controller: conversionController,
              ),
            ),


            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Symbol',
                  hintText: 'Currency Symbol',
                ),
                controller: currencysymbolController,
              ),
            ),

          ],
        ) ,
      )


,

      actions: [

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
  }


  EditCountryData(String id,String name,String countrycode,String conversionfactor,String currencysymbol) async
  {
    countryController.text=name;
    codeController.text=countrycode;
    conversionController.text=conversionfactor;
    currencysymbolController.text=currencysymbol;

    Widget okButton1 = TextButton(
      child: Text("Update"),
      onPressed: () async {
        if (!countryController.text.isEmpty) {
          if (!codeController.text.isEmpty) {

            if(!conversionController.text.isEmpty) {

              if(!currencysymbolController.text.isEmpty) {
                final productRef = FirebaseFirestore.instance.collection(
                    'countryList').doc(id);
                await productRef.update({
                  'name': countryController.text,
                  'countrycode': codeController.text,
                  'ConversionFactor': conversionController.text,
                  'currency_symbol': currencysymbolController.text
                }).then((value) {
                  codeController.clear();
                  countryController.clear();
                  conversionController.clear();
                  currencysymbolController.clear();

                  Navigator.pop(context);


                  getCountryList();
                });
              }
              else{
                ResponsiveInfo.showAlertDialog(context, "", "Enter currency symbol");
              }
            }
            else{

              ResponsiveInfo.showAlertDialog(context, "", "Enter currency conversion factor");
            }
          }
          else {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('Enter country code'),
            // ));

            ResponsiveInfo.showAlertDialog(context, "", "Enter country code");

          }
        }
        else {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Enter country name'),
          // ));

          ResponsiveInfo.showAlertDialog(context, "", "Enter country name");

        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(),
      content: SingleChildScrollView(

        child: Column(

          children: [

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country name',
                  hintText: 'Country name',
                ),
                controller: countryController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country Code',
                  hintText: 'Country Code',
                ),
                controller: codeController,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 2 : 5),
              child: Text(
                "Base Currecncy is INR", style: TextStyle(color: Colors.black, fontSize: 10),),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Conversion Factor',
                  hintText: 'Conversion Factor',
                ),
                controller: conversionController,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 5 : 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Currency Symbol',
                  hintText: 'Currency Symbol',
                ),
                controller: currencysymbolController,
              ),
            ),

          ],
        ),
      )

      ,

      actions: [

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
  }

}