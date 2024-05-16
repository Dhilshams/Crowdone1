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

class PaymentQRcode extends StatefulWidget {
   PaymentQRcode() ;

  @override
  _PaymentQRcodeState createState() => _PaymentQRcodeState();
}

class _PaymentQRcodeState extends State<PaymentQRcode> {


  String imagedata="";

  String id="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaymentQrcode();
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
        title: Text("Payment QR Code",style: TextStyle(color: Colors.black,fontSize: 15),),
        centerTitle: false,




      ),

      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),

child: (!imagedata.isEmpty)? Image.network(imagedata,
  width: double.infinity,
  height: ResponsiveInfo.isMobile(context)?190:230,
) : Container(
  width: double.infinity,
  height: ResponsiveInfo.isMobile(context)?190:230,
  child: Stack(
    children: [

      Align(
    alignment: FractionalOffset.center,
    child: Text("No QR code found",style: TextStyle(color: Colors.black,fontSize: 15),) ,
    )

    ],
    )


  ,


),

),



          Padding(
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
                  'Add New',
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                ),
                onPressed: () async {

                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {

                    showLoaderDialog(context);

                    String  filepath=pickedFile.path;

                    final ref = FirebaseStorage.instance.ref().child('qrcode').child('${DateTime.now()}.jpg');
                    await ref.putFile(new File(filepath));
                    final imageUrl = await ref.getDownloadURL();

                    FirebaseFirestore.instance.collection('paymentqrcode').doc(id).update({'image':imageUrl}).then((value){

                      Navigator.pop(context);
                      getPaymentQrcode();

                    });



                  }



                },
              ),
            ),
          ),



    ],
      ) ,


    );
  }



  getPaymentQrcode()async
  {


    final productSnapshot = await FirebaseFirestore.instance.collection('paymentqrcode').get();

    List<dynamic>c=    productSnapshot.docs.toList();
    bool a=false;
    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      setState(() {

        id=ab.id;
        imagedata=m['image'];
      });








    }

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



}
