import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/Constants.dart';
import '../designs/ResponsiveInfo.dart';

class SalesPaymentPage extends StatefulWidget {

  String salesid;
  String totalamount;


   SalesPaymentPage(this.salesid,this.totalamount) ;

  @override
  _SalesPaymentPageState createState() => _SalesPaymentPageState(this.salesid,this.totalamount);
}

class _SalesPaymentPageState extends State<SalesPaymentPage> {
  TextEditingController userController = TextEditingController();
  String salesid;

  String totalamount;

  String imagedata="";

String currency="";

  _SalesPaymentPageState(this.salesid,this.totalamount);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPaymentQrcode();

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

  getPaymentQrcode()async
  {
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? countrycode=   preferenceDataStorage.getString(Constants.pref_countrycode);
    String a= await ResponsiveInfo.getCurrencyByCountry(countrycode.toString());

    setState(() {
      currency=a;
    });
    final productSnapshot = await FirebaseFirestore.instance.collection('paymentqrcode').get();

    List<dynamic>c=    productSnapshot.docs.toList();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      setState(() {


        imagedata=m['image'];
      });








    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Payment",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),



      ),


      body: Column(

        children: [


          Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: (!imagedata.isEmpty)? Image.network(imagedata,
                width: double.infinity,
                height: ResponsiveInfo.isMobile(context)?190:230,
              ) : Container(
                width: double.infinity,
                height: ResponsiveInfo.isMobile(context)?190:230,
                child: Text("No QR code found",style: TextStyle(color: Colors.black,fontSize: 15),)


                ,


              )
          ),
          Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: Text( 'Amount to pay : '+totalamount.toString() +" "+currency, style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?12:14)

              )
          ),

          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Transaction ID',
                hintText: 'Transaction ID',
              ),
              controller: userController,
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
                  'Payment Completed',
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                ),
                onPressed: () async {
                  // Call a function to authenticate user

                  if(userController.text.isNotEmpty) {
                    Navigator.pop(context);
                    showLoaderDialog(context);
                    final productRef = FirebaseFirestore.instance
                        .collection(
                        'sales_order').doc(salesid);
                    await productRef.set({
                      'order_status': 'Success',
                      'payment_status': 'Success',
                      'payment_type': 'online',
                      'transaction_id' : userController.text
                    }).then((value) {
                      Navigator.pop(context);
                    });
                  }
                  else{

                    ResponsiveInfo.showAlertDialog(context, "", "Please Enter Transaction ID");
                  }



                },
              ),
            ),
          ),

        ],
      ),

    );
  }
}
