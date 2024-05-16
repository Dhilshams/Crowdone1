import 'package:flutter/material.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';

class WalletRequest extends StatefulWidget {
   WalletRequest() ;

  @override
  _WalletRequestState createState() => _WalletRequestState();
}

class _WalletRequestState extends State<WalletRequest> {


TextEditingController amountcontroller=new TextEditingController();

TextEditingController accountcontroller=new TextEditingController();
TextEditingController bankcontroller=new TextEditingController();
TextEditingController ifsccontroller=new TextEditingController();
TextEditingController bankaddresscontroller=new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f5f9),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {

Navigator.pop(context);

            }, icon: Icon(Icons.clear,color: Colors.black,)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "Withdraw request",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),


      ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(4),
                      child: Text( 'Request form', style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?20:25,fontWeight: FontWeight.bold),


                      )),
                  Padding(padding: EdgeInsets.all(4),
                      child: Text( 'Fill the form and send request', style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?10:13,fontWeight: FontWeight.normal),


                      ))
                ],
              ),

            ),



            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: ResponsiveInfo.isMobile(context)?12:16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Amount'),
                          new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                    Container(
                      padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: amountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: 'Amount',
                            hintStyle: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black26 )
                        ),


                        style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black87 ),

                      ),
                    ),

                    Padding(padding: EdgeInsets.all(4),
                        child: Text( 'Minimum withdrawal amount: ₹1000', style: TextStyle(
                            color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?8:11,fontWeight: FontWeight.normal),


                        ))
                  ],
                )

            ),



            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: ResponsiveInfo.isMobile(context)?12:16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Account number'),
                          new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                    Container(
                      padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),

                      // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: accountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,

                            hintStyle: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black26 ),
                            hintText: 'Enter bank account number'),
                        style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black87 ),

                      ),
                    )


                  ],
                )

            ),




            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: ResponsiveInfo.isMobile(context)?12:16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Bank name'),
                          new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                    Container(
                      padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),

                      // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: bankcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,

                            hintStyle: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black26 ),
                            hintText: 'Enter bank name'),
                        style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14 ,color: Colors.black87),

                      ),
                    )


                  ],
                )

            ),



            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: ResponsiveInfo.isMobile(context)?12:16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'IFSC Code'),
                          new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                    Container(
                      padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),

                      // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: ifsccontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            // labelText: 'Enter Password',
                            hintStyle: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black26 ),
                            hintText: 'Enter IFSC code'),
                        style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14 ,color: Colors.black87),

                      ),
                    )


                  ],
                )

            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: ResponsiveInfo.isMobile(context)?12:16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Bank Address'),
                          new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                    Container(
                      padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)? 120 : 150 ,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),

                      // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: bankaddresscontroller,

                        decoration: InputDecoration(
                            border: InputBorder.none,
                            // labelText: 'Enter Password',
                            hintStyle: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14,color: Colors.black26 ),
                            hintText: 'Enter Bank Address'),
                        style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 12 : 14 ,color: Colors.black87),

                      ),
                    )


                  ],
                )

            ),



            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
              child: Row(
    children: [
      
      Expanded(child: GestureDetector(

      child: Padding(
        child:Container(
          width: double.infinity,

          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

          ),


          child:  TextButton(
            child: Text( 'Cancel', style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.bold),
            ),
            onPressed: ()async{







            },

          ),

        ) ,
        padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
      ),
        onTap: (){

        Navigator.pop(context);

        },
      )




      ,flex: 1,),
      Expanded(child:GestureDetector(

    child: Padding(
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
            color: Color(0xff255eab),
            border: Border.all(color: Color(0xff255eab)),
            borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

        ),


        child:  TextButton(
          child: Text( 'Send Request', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.bold),
          ),
          onPressed: ()async{


            if(amountcontroller.text.isNotEmpty)
            {
              if(accountcontroller.text.isNotEmpty)
              {
                if(bankcontroller.text.isNotEmpty)
                {
                  if(ifsccontroller.text.isNotEmpty)
                  {

                    if(bankaddresscontroller.text.isNotEmpty)
                    {

                      double d=double.parse(amountcontroller.text);

                      if(d<=1000) {
                        showLoaderDialog(context);
                        final preferenceDataStorage = await SharedPreferences
                            .getInstance();
                        String? id = preferenceDataStorage.getString(
                            Constants.pref_userid);

                        await FirebaseFirestore.instance.collection(
                            'wallet_requests').add({
                          'amount': amountcontroller.text,
                          'account_number': accountcontroller.text,
                          'bank': bankcontroller.text,
                          'ifsc': ifsccontroller.text,
                          'bankaddress': bankaddresscontroller.text,
                          'user_id': id.toString(),
                          'approval_status':'pending'
                        }).whenComplete(() {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text('Amount Request send Successfully'),
                          // ));

                          Navigator.pop(context);
                          Navigator.pop(context);

                          ResponsiveInfo.showAlertDialog(context, "", "Amount Request send Successfully");
                        });
                      }
                      else{

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Enter amount below 1000 Rs'),
                        //   ),
                        // );

                        ResponsiveInfo.showAlertDialog(context, "", "Enter amount below 1000 Rs");


                      }


                    }
                    else{

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Enter Bank Address'),
                      //   ),
                      // );

                      ResponsiveInfo.showAlertDialog(context, "", "Enter bank address");

                    }
                  }
                  else{

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Enter IFSC'),
                    //   ),
                    // );

                    ResponsiveInfo.showAlertDialog(context, "", "Enter IFSC");

                  }

                }
                else{

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Enter bank name'),
                  //   ),
                  // );

                  ResponsiveInfo.showAlertDialog(context, "", "Enter bank name");


                }

              }
              else{

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Enter Account no.'),
                //   ),
                // );

                ResponsiveInfo.showAlertDialog(context, "", "Enter Account no.");

              }

            }
            else{

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Enter amount'),
              //   ),
              // );

              ResponsiveInfo.showAlertDialog(context, "", "Enter Amount");

            }




          },

        ),

      ),
      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
    ) ,
        onTap: ()async{




        },
    )


     ,flex: 1,)
      
      
    ],
    
    )



            ),













          ],



        ),

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
}
