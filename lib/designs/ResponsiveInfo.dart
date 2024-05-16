import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponsiveInfo{


 static bool isMobile(BuildContext context)
{

  bool a=false;
  double width = MediaQuery.of(context).size.shortestSide;

  if(width<600)
    {
      a=true;
    }
  else{
    a=false;
  }

  return a;

}


 static showAlertDialog(BuildContext context,String title,String message) {

   // set up the button
   Widget okButton = TextButton(
     child: Text("OK"),
     onPressed: () {

       Navigator.pop(context);

     },
   );

   // set up the AlertDialog
   AlertDialog alert = AlertDialog(
     title: Text(title),
     content: Text(message),
     actions: [
       okButton,
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

 // static bool isTab(BuildContext context)
 // {
 //
 //   bool a=false;
 //   double width = MediaQuery.of(context).size.width;
 //
 //   if(width<1024)
 //   {
 //     a=true;
 //   }
 //   else{
 //     a=false;
 //   }
 //
 //   return a;
 //
 // }
 //
 //
 // static bool isSmallMobile(BuildContext context)
 // {
 //
 //   bool a=false;
 //   double width = MediaQuery.of(context).size.width;
 //
 //   if(width<=380)
 //   {
 //     a=true;
 //   }
 //   else{
 //     a=false;
 //   }
 //
 //   return a;
 //
 // }



static Future<String> getPriceByCountry(String countrycode,String priceparam)
async {
  String price="0";

  final productSnapshot1 = await FirebaseFirestore.instance.collection(
      'countryList').get();

  List<dynamic>c = productSnapshot1.docs.toList();
  bool a = false;

  for (int i = 0; i < c.length; i++) {
    QueryDocumentSnapshot ab = c[i];

    var m = ab.data() as Map<String, dynamic>;


    String name = m['name'];
    String code = m['countrycode'];
    String id = ab.id;
    String conversionfactor=m['ConversionFactor'];

    if(code.compareTo(countrycode)==0)
      {

        double p=double.parse(priceparam.trim());
        double c=double.parse(conversionfactor);

        double convertedprice=p*c;
        price=convertedprice.toStringAsFixed(3);

        break;

      }


  }



  return price;

}


 static Future<String> getCurrencyByCountry(String countrycode)
 async {
   String currency_symbol="";

   final productSnapshot1 = await FirebaseFirestore.instance.collection(
       'countryList').get();

   List<dynamic>c = productSnapshot1.docs.toList();
   bool a = false;

   for (int i = 0; i < c.length; i++) {
     QueryDocumentSnapshot ab = c[i];

     var m = ab.data() as Map<String, dynamic>;


     String name = m['name'];
     String code = m['countrycode'];
     String id = ab.id;
     String conversionfactor=m['ConversionFactor'];

     if(code.compareTo(countrycode)==0)
     {



       if(m.containsKey("currency_symbol"))
       {
         currency_symbol=m['currency_symbol'];
       }

       break;

     }


   }



   return currency_symbol;

 }




}