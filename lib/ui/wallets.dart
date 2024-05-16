import 'package:flutter/material.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/wallet_request.dart';
import 'package:ecommerce/domain/WalletAmount.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:ecommerce/ui/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/ui/payment_page.dart';

class Wallets extends StatefulWidget {
   Wallets() ;

  @override
  _WalletsState createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {

  TextEditingController userController=new TextEditingController();


  List<WalletAmount>wam=[];

  double wb=0.0;
 String currency="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWalletAmount();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f5f9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          Expanded(child:
          Column(

            children: [
              Expanded(child:   Padding(

                child:Container(

                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff2663ae),
          Color(0xff7C64BC)
        ],
      ),
                      // border: Border.all(color: Color(0xffb98902)),
                      borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                  ),

                  child:             Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Expanded(child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [


                            Padding(padding: EdgeInsets.all(4),
                                child: Text( 'Wallet Balance', style: TextStyle(color: Colors.white,
                                    fontSize: ResponsiveInfo.isMobile(context)?15:18,fontWeight: FontWeight.bold),


                                )),
                            Padding(padding: EdgeInsets.all(4),
                                child:

                                    Text( 'Total amount of money in your wallet', style: TextStyle(color: Colors.white,
                                        fontSize: ResponsiveInfo.isMobile(context)?13:16,fontWeight: FontWeight.normal),

                                    ),


                            ),

                            Padding(padding: EdgeInsets.all(4),
                                child: Text( ''+wb.toString()+" "+currency, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?20:25,fontWeight: FontWeight.bold),


                                ))
                          ],
                        )


                          ,flex: 3,),


                        Expanded(child:    Padding(padding: EdgeInsets.all(8),
                          child: Stack(
                            children: [

                              Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Image.asset("assets/images/walletbg.png",width: ResponsiveInfo.isMobile(context)? 100 : 130,
                                  height: ResponsiveInfo.isMobile(context)? 100 : 130,),
                              )

                            ],

                          )

                          ,


                        ),flex: 1,),





                      ],


                    ),

                  ),

                )  ,
                padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
              ),flex: 1)

            ,
              Expanded(child: SingleChildScrollView(

                child: Column(
                  children: [

                    Padding(

                      child:Container(
                        height: ResponsiveInfo.isMobile(context)? 80 : 120,

                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border.all(color: Color(0xffffffff)),
                            borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                        ),
                        child: ListTile(
                          trailing:   GestureDetector(
    child:Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
        child:Container(
            padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 6 : 9),

            decoration: BoxDecoration(
                color: Color(0xff2453a4),

                border: Border.all(color: Color(0xff2453a4)),
                borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

            ),


            child:  Text( "Invest now   > ",
              style: TextStyle(color: Colors.white,
                  fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
              maxLines: 2,



            ))

    ),
                            onTap: (){

                              Widget okButton1 = TextButton(
                                child: Text("ok"),
                                onPressed: () async{

                                  if(!userController.text.isEmpty) {

                                    final preferenceDataStorage = await SharedPreferences
                                        .getInstance();
                                    String? id=  preferenceDataStorage.getString(Constants.pref_userid);

                                      Navigator.pop(context);


                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentPage(userController.text, "Wallet Amount",id.toString()),
                                        ),
                                      );


                                  }
                                  else{


                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Enter unit'),
                                    ));
                                  }


                                },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title:Container(),
                                content:         Padding(
                                  padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Amount to Invest',
                                      hintText: 'Enter Amount to Wallet',
                                    ),
                                    controller: userController,
                                  ),
                                ),
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


                            },

    )   ,
                            title: Text("Invest more",style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?17:20,fontWeight: FontWeight.bold),),
                        subtitle:Text("Add funds to your wallet",style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?12:15),) ,

                        ),

                      )  ,
                      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                    ),



                    Padding(

                      child:Container(
                        height: ResponsiveInfo.isMobile(context)? 90 : 120,

                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border.all(color: Color(0xffffffff)),
                            borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                        ),

                        child: ListTile(


                          trailing:      Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                              child: GestureDetector(
    child: Container(
        padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 6 : 9),

        decoration: BoxDecoration(
            color: Color(0xff2453a4),

            border: Border.all(color: Color(0xff2453a4)),
            borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

        ),


        child:  Text( " Request   > ",
          style: TextStyle(color: Colors.white,
              fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
          maxLines: 2,



        )),
                                onTap: (){

                                  Navigator.push(context,
                                      MaterialPageRoute(builder:
                                          (context) =>
                                          WalletRequest()
                                      )
                                  );


                                },

    )



                          ),
                          title: Text("Withdraw request",style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?17:20,fontWeight: FontWeight.bold),),
                          subtitle:Text("Withdraw money from your wallet",style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?12:15),) ,

                        ),

                      )  ,
                      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                    )



                  ],


                ),
              ),flex: 1,)





            ],

          ),flex: 2,),


          Expanded(child: Padding(

    child: Container(

      color: Colors.white,

      child: SingleChildScrollView(

        child: Column(

          children: [

            Padding(

              child:Container(
                height: ResponsiveInfo.isMobile(context)? 80 : 120,

                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(color: Color(0xffffffff)),
                    borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                ),

                child: ListTile(


                  // trailing:Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                  //     child:Container(
                  //         padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 6 : 9),
                  //
                  //         decoration: BoxDecoration(
                  //             color: Color(0xff2453a4),
                  //
                  //             border: Border.all(color: Color(0xff2453a4)),
                  //             borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))
                  //
                  //         ),
                  //
                  //
                  //         child:  Text( " View all > ",
                  //           style: TextStyle(color: Colors.white,
                  //               fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
                  //           maxLines: 2,
                  //
                  //
                  //
                  //         ))
                  //
                  // ),
                  title: Text("Transaction History",style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?17:20,fontWeight: FontWeight.bold),),
                  subtitle:Text("All transactions",style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?12:15),) ,

                ),

              )  ,
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
            ),

            ListView.builder(
                itemCount: wam.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading:  Icon(Icons.credit_card_sharp),
                      subtitle:Text(wam[index].t_date,
                        style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?12:15),) ,

                      trailing:  Text(
                        ""+wam[index].amount+" "+currency,

                        style: TextStyle(color: Colors.black,  fontSize: ResponsiveInfo.isMobile(context)?13:15),
                      ),
                      title: Text(wam[index].type,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: ResponsiveInfo.isMobile(context)?15:17),));
                }) ,




          ],


        ),
        scrollDirection: Axis.vertical,
      )




    ),
            padding: EdgeInsets.fromLTRB(ResponsiveInfo.isMobile(context)? 10 : 15,  ResponsiveInfo.isMobile(context)? 10 : 15, ResponsiveInfo.isMobile(context)? 10 : 15, 0),
    )



          ,


            flex: 2,)





        ],



      ),


    );
  }



  getWalletAmount()async{

    // showLoaderDialog(context);
    double e=0;
    final productSnapshot = await FirebaseFirestore.instance.collection('wallet_balance').get();
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? id=  preferenceDataStorage.getString(Constants.pref_userid);
    String? countrycode=   preferenceDataStorage.getString(Constants.pref_countrycode);
    String a= await ResponsiveInfo.getCurrencyByCountry(countrycode.toString());
    currency=a;


    List<dynamic>c=    productSnapshot.docs.toList();

    // Navigator.pop(context);
    for(int i=0;i<c.length;i++)
    {

      QueryDocumentSnapshot ab=c[i];

      var m = ab.data() as Map<String,dynamic>;


      String  user_id = m['user_id'];
      if(user_id.compareTo(id.toString())==0)
      {

        WalletAmount wa=new WalletAmount();
        wa.type=m['type'];
        wa.amount=m['amount'].toString();
        wa.t_date=m['date'];

        String am=m['amount'].toString();
        if(am.isNotEmpty)
          {
            double d=double.parse(am);
            if(m['type'].toString().compareTo("withdraw")==0) {
              e = e - d;
            }
            else{

              e = e + d;
            }

          }




        setState(() {

          wam.add(wa);
        });

      }

    }

    setState(() {

      wb=e;
    });






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



