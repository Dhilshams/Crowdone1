import 'dart:math';

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
import 'package:mailer/mailer.dart' as mailAddress;
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:badges/badges.dart' as badge;
import 'package:ecommerce/domain/CartData.dart';
import 'package:ecommerce/domain/Address.dart';
import 'package:ecommerce/ui/address_list.dart';
import 'package:ecommerce/ui/home.dart';

class CartPage extends StatefulWidget {
   CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {


  List<CartData>cartdata=[];
  double totalamount=0;
  List<Address>adr=[];

int selectedindex=0;

double walletsavepercentage=0,walletsaveamount=0;
String currency="",membershiptype="",walletmessage="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCartCount();
    getAddressList();

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // You can do some work here.
      // Returning true allows the pop to happen, returning false prevents it.
      return true;
    },
    child:


      Scaffold(
backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,

        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("My Cart",style: TextStyle(color: Colors.black,fontSize: 15),),
        centerTitle: false,




      ),

      body: Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?5:7 ),

      child: Stack(

        children: [

          Align(
            child:
            Container(
              width: double.infinity,
              height: ResponsiveInfo.isMobile(context)?100:130 ,
              color: Color(0xffe8e8e8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Padding(padding: EdgeInsets.all(6),
                  child:    Text( "Address" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center
                    ,

                    children: [
                      Expanded(child: Padding(padding: EdgeInsets.all(5),
                        child: (adr.length>0)?Text( adr[selectedindex].addressdata ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),maxLines: 2,) :
                        Text( "No Address Found" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),)
                        ,



                      ),flex: 2,)
                      ,

                      Expanded(child:  Padding(padding: EdgeInsets.all(5),
                          child: TextButton(

                            child: Text( (adr.length>0)?"Change" : "Add" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.blue ),),
                            onPressed: ()async{

                              Map results =
                              await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) {
                                  return new AddressList();
                                },
                              ));

                              if (results != null && results.containsKey('added')) {
                                var acc_selected = results['added'];

                                int code = acc_selected as int;
                                if (code !=-1) {

                                  setState(() {
                                    // is_studentclicked = false;
                                    // isstaffclicked = false;
                                    // isvisitorclicked = false;
                                    selectedindex=code;

                                    print("selected index : "+selectedindex.toString());

                                    getAddressList();
                                  });
                                }
                              }

                            },
                          )

                      ),flex: 1,)





                    ],
                  ),
                ],
              )





            ),
alignment: FractionalOffset.topCenter,
          ),

          (cartdata.length>0)?  Align(
            child:  Padding(
              padding: EdgeInsets.only(left: 0,right: 0,bottom:ResponsiveInfo.isMobile(context)?75:100,top: ResponsiveInfo.isMobile(context)?110:140 ),
              child: ListView.builder(
                  itemCount: cartdata.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      width: double.infinity,
                      height:ResponsiveInfo.isMobile(context)?190:230 ,

                      child: Card(
                        elevation: 8,
                        child:Row(

                          children: [

                            Expanded(child:(cartdata[i].image.isNotEmpty)?
                            Padding(padding: EdgeInsets.all(10),

                            child: Image.network(cartdata[i].image,),
                            )

                             : Container(),flex: 1,),

                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                (cartdata[i].name.isNotEmpty && cartdata[i].unitname.isNotEmpty)? Text(cartdata[i].name+" "+cartdata[i].unitname ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),) :

                                Text("" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),

                                (cartdata[i].domestic_price.isNotEmpty)? Text("Unit Price : "+  cartdata[i].domestic_price+" "+currency ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),) :
                                Text("" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),

                                (cartdata[i].tax.isNotEmpty)? Text((currency.compareTo("INR")==0)?"GST : "+  cartdata[i].tax+" %" : "Tax : "+  cartdata[i].tax+" %" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),) :
                                Text((currency.compareTo("INR")==0)?"GST : 0 %" : "Tax : 0 %" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),

                                  (cartdata[i].unitprice.isNotEmpty)? Text("Total : "+  cartdata[i].unitprice+" "+currency ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),) :
                                Text("" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black,fontWeight: FontWeight.bold ),),

                                Card(
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[

                                        GestureDetector(

                                          child: Icon(Icons.remove, color: Colors.black87,size:ResponsiveInfo.isMobile(context)? 20 : 25 ,),

                                    onTap: ()async{
                                            
                                            String qty=cartdata[i].qty;
                                            int p=int.parse(qty);
                                            
                                            if(p>1)
                                              {
                                                p=p-1;
                                                setState(() {
                                                  cartdata[i].qty=p.toString();
                                                });

                                                showLoaderDialog(context);

                                                FirebaseFirestore.instance.collection('cart').doc(cartdata[i].id).update({"qty":p.toString()}).then((value) {
                                                  Navigator.pop(context);
                                                  calculateTotal();
                                                });
                                              
                                              }


                                    },
                                        ),
                                        Text(
                                          cartdata[i].qty,
                                          style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)? 13 : 15),
                                        ),
                                        GestureDetector(
                                          child: Icon(Icons.add, color: Colors.black87,size: ResponsiveInfo.isMobile(context)? 20 : 25,),

                                          onTap: ()async{

                                            String qty=cartdata[i].qty;
                                            int p=int.parse(qty);

                                              p=p+1;
                                              setState(() {
                                                cartdata[i].qty=p.toString();
                                              });

                                              showLoaderDialog(context);

                                            FirebaseFirestore.instance.collection('cart').doc(cartdata[i].id).update({"qty":p.toString()}).then((value) {
                                              Navigator.pop(context);
                                              calculateTotal();
                                            });

                                            
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Stack(

                                  children: [

                                    Align(
                                      alignment: FractionalOffset.topRight,
                                      child: TextButton(
                                        onPressed: ()async{


                                          Widget okButton = TextButton(
                                            child: Text("yes"),
                                            onPressed: ()async {

                                              showLoaderDialog(context);
                                              FirebaseFirestore.instance.collection('cart').doc(cartdata[i].id).delete().then((value) {

                                                setState(() {
                                                  cartdata.removeAt(i);

                                                });
                                                calculateTotal();
                                                Navigator.pop(context);
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
                                            title: Text(""),
                                            content: Text("Do you want to delete this product from cart ?"),
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

                                        child:  Text("Delete" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),
                                      ),
                                    )


                                  ],
                                )







                              ],
                            ),






                            )


                          ],
                        )





                      ),
                    );
                  })

            ),
            alignment: FractionalOffset.topCenter,
          ) : Align(
            alignment: FractionalOffset.center,
            child: Padding(padding: EdgeInsets.all(5),
              child:     Text( "No data found" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),),



            ) ,
          ),

          Align(
            child:
            (cartdata.length>0)? Container(
              width: double.infinity,
              height: ResponsiveInfo.isMobile(context)?100:140 ,
              color: Color(0xffe8e8e8),
              child: Column(

                children: [

                  (membershiptype.contains("Entrepreneur") || membershiptype.contains("Distributor") )?    Padding(padding: EdgeInsets.all(5),
                    child:     Text( walletmessage+" : "+ walletsaveamount.toString()+" "+currency,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black,fontWeight: FontWeight.bold ),),



                  ) : Container(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:     Text( "Total Amount : "+ totalamount.toString() +" "+currency ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black,fontWeight: FontWeight.bold ),),



                      ),

                      Padding(padding: EdgeInsets.all(5),
                          child: TextButton(

                            child: Text( "Confirm Order" ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.blue ),),
                            onPressed: (){

                              if(adr.length>0){

                                Widget okButton = TextButton(
                                  child: Text("yes"),
                                  onPressed: ()async {

                                    Navigator.pop(context);



                                    final preferenceDataStorage = await SharedPreferences
                                        .getInstance();
                                    String? uid= preferenceDataStorage.getString(Constants.pref_userid);
                                    String? countrycode=   preferenceDataStorage.getString(Constants.pref_countrycode);

                                    Random random=new Random();
                                    int randomNumber = random.nextInt(9661651) + 10;

                                    showLoaderDialog(context);

                                    DateTime dt=new DateTime.now();

                                    final productRef = FirebaseFirestore.instance.collection(
                                        'sales_order').doc();
                                    await productRef.set({
                                      'address_id': adr[selectedindex].id,
                                      'userid': uid.toString(),
                                      'date':dt.day.toString()+"-"+dt.month.toString()+"-"+dt.year.toString(),
                                      'total_amount':totalamount.toString(),
                                      'country_code':countrycode.toString(),
                                      'order_number':randomNumber,
                                      'order_status':'pending',
                                      'payment_status':'pending',
                                      'payment_type':'none'
                                    }).then((value) {
                                      Navigator.pop(context);

                                      String salesorder_id=productRef.id;

                                      String pdetails="";

                                      for(int i=0;i<cartdata.length;i++) {

                                        showLoaderDialog(context);

                                        pdetails=pdetails+"Name : "+cartdata[i].name+" "+cartdata[i].unitname+"\nQuantity : "+cartdata[i].qty+"\nUnit Price : "+cartdata[i].unitprice+" "+currency + ((currency.compareTo("INR")==0)?"\nGST : "+cartdata[i].tax+" %" :"\nTax : "+cartdata[i].tax+" %" )+"\nPrice(inclusive tax) : "+cartdata[i].domestic_price+" "+currency+"\nTotal : "+(double.parse(cartdata[i].qty)*double.parse(cartdata[i].unitprice)).toString()+" "+currency+"\n\n\n";

                                        FirebaseFirestore.instance
                                            .collection(
                                            'sales_orders').doc().set({
                                          'product_id':cartdata[i].product_id,
                                          'product_master_id':cartdata[i].productmaster_id,
                                          'qty':cartdata[i].qty,
                                          'order_number':randomNumber,
                                          'date':dt.day.toString()+"-"+dt.month.toString()+"-"+dt.year.toString(),
                                          'userid': uid.toString(),
                                          'country_code':countrycode.toString(),
                                          'order_id':salesorder_id,
                                          'unit_price':cartdata[i].unitprice,
                                          'user_id':uid.toString()
                                        }).then((value) {

                                          Navigator.pop(context);
                                          showLoaderDialog(context);
                                          FirebaseFirestore.instance
                                              .collection(
                                              'cart').doc(cartdata[i].id).delete().then((value) async {
                                            Navigator.pop(context);

                                            if(i==cartdata.length-1)
                                            {

                                              pdetails=pdetails+"Total Amount : "+totalamount.toString();
                                              pdetails=pdetails+"\n GST : "+"27AASFC6698L1ZD";

                                              showLoaderDialog(context);
                                              await FirebaseFirestore.instance.collection('registration').doc(uid.toString()).get().then((value)async {


                                                Map<String,dynamic> m= value.data()!;

                                                String  name=m['name'];
                                                String email=m['email'];
                                                String  image=m['image'];


                                                final smtpServer = SmtpServer('mail.privateemail.com',
                                                  username: 'support@crowdone.in', password: 'Dubai@1234',port: 465,ssl: true,);





                                                // Create our message.
                                                final message =mailAddress. Message()
                                                  ..from = mailAddress.Address("support@crowdone.in", 'support@crowdone.in')
                                                  ..recipients.add(email.trim())
                                                  ..ccRecipients.addAll(['support@crowdone.in', email.trim()])
                                                // ..bccRecipients.add( mailAddress.Address('support@crowdone.in'))
                                                  ..subject = 'New Order Received :: 😀 :: ${DateTime.now()}'
                                                  ..text = 'A new order received with id '+randomNumber.toString()+" from "+name+"\n Delivery Address : "+adr[selectedindex].addressdata+" \n\n\n\n"+
                                                      "Items : "+"\n"+pdetails

                                                ;

                                                try {
                                                  final sendReport = await mailAddress.send(message, smtpServer);
                                                  print('Message sent: ' + sendReport.toString());
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => MyDashboardPage()),
                                                  );

                                                } on mailAddress.MailerException catch (e) {
                                                  print('Message not sent.'+e.message);
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => MyDashboardPage()),
                                                  );

                                                  for (var p in e.problems) {
                                                    print('Problem: ${p.code}: ${p.msg}');
                                                  }
                                                }





                                              });




                                            }

                                          });


                                        });
                                      }


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
                                  title: Text("Profile"),
                                  content: Text("Do you want to confirm this order ?"),
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


                              }

                              else{


                                ResponsiveInfo.showAlertDialog(context, "", "Please add your delivery address");


                              }

                            },
                          )






                      )



                    ],
                  ),

                ],
              )



            ) : Container(),
            alignment: FractionalOffset.bottomCenter,
          )

        ],




      ),

      )



    ) );
  }


  getCartCount()async{

    getWalletOfferMessage();

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? uid=  preferenceDataStorage.getString(Constants.pref_userid);




    final productSnapshot = await FirebaseFirestore.instance.collection('cart').get();


    List<dynamic>c=    productSnapshot.docs.toList();

    cartdata.clear();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String userid=m['userid'];
      String product_id=m['product_id'];
      String productmaster_id=m['product_masterid'];
      String qty=m['qty'];
      String cartid=ab.id;

      if(userid.trim().compareTo(uid.toString())==0)
      {

        CartData c1=    CartData(cartid, userid.trim(), qty, "", "", "", "",product_id,productmaster_id,"","");
        setState(() {
          cartdata.add(c1);

        });

      }


    }

    String? countrycode=   preferenceDataStorage.getString(Constants.pref_countrycode);
    String a= await ResponsiveInfo.getCurrencyByCountry(countrycode.toString());

    setState(() {
      currency=a;
    });

    for(int j=0;j<cartdata.length;j++)
      {

        String product_id=cartdata[j].product_id;
        String productmaster_id=cartdata[j].productmaster_id;

        FirebaseFirestore.instance.collection('products').doc(product_id).get().then((value) async {
        var m1=value.data()!;
        String unitprice="",tax="",pricewithouttax="";
        // if(countrycode.toString().trim().compareTo("+91")==0)
        // {
        //   unitprice=m1['actual_amount_domestic'];
        // }
        // else{
        //
        //   unitprice=m1['international_actual_price'];
        // }

        if(countrycode.toString().trim().compareTo("+91")==0)
        {
          unitprice= await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['actual_amount_domestic']) ;
      tax=m1['domestic_gst'];
          // pricewithouttax=m1['domestic_price'];

          pricewithouttax=  await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['domestic_price']) ;

        }
        else{

          tax=m1['international_tax'];
          // pricewithouttax=m1['international_price'];

          pricewithouttax=  await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['international_price']) ;


          unitprice= await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['international_actual_price']) ;


        }

        String units=m1['units'];

        for(int k=0;k<cartdata.length;k++) {
          if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
              0) {

            setState(() {
              cartdata[k].unitprice=unitprice;
              cartdata[k].tax=tax;
              cartdata[k].domestic_price=pricewithouttax;
            });

            calculateTotal();
          }
        }

        FirebaseFirestore.instance.collection('units').doc(units.trim()).get().then((value1) {
          var m3=value1.data()!;
          String unitname=m3['name'];

          for(int k=0;k<cartdata.length;k++) {
            if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
                0) {

              setState(() {
                cartdata[k].unitname=unitname;
              });

              calculateTotal();
            }
          }

          FirebaseFirestore.instance.collection('product_master').doc(productmaster_id).get().then((value2) {
            var m2=value2.data()!;
            String name=m2['name'];
            String image=m2['image'];

            for(int k=0;k<cartdata.length;k++) {
              if (productmaster_id.compareTo(cartdata[k].productmaster_id) ==
                  0) {

                setState(() {
                  cartdata[k].name=name;
                  cartdata[k].image=image;

                });

                calculateTotal();
              }
            }



          });

        });




        });
      }




  }


  getWalletOfferMessage()async{

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? uid=  preferenceDataStorage.getString(Constants.pref_userid);

    membershiptype=preferenceDataStorage.getString(Constants.mtype).toString();


    final productSnapshot = await FirebaseFirestore.instance.collection('wallet_offer').get();


    List<dynamic>c=    productSnapshot.docs.toList();

    cartdata.clear();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      setState(() {
        walletmessage=m['message'].toString();
        walletsavepercentage= double.parse(m['percentage'].toString()) ;
      });







    }






  }



  getAddressList()async
  {
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? uid=  preferenceDataStorage.getString(Constants.pref_userid);

    final productSnapshot = await FirebaseFirestore.instance.collection('addresslist').get();


    List<dynamic>c=    productSnapshot.docs.toList();


    adr.clear();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      String userid=m['userid'];
      String address=m['address'];
      if(userid.trim().compareTo(uid.toString())==0)
        {

          setState(() {

                adr.add(new Address(ab.id, address,1));

          });

        }

    }

    print("address length : "+adr.length.toString());

    for(int i=0;i<adr.length;i++) {
      setState(() {

        adr[selectedindex].selected=1;
      });

    }


  }




  calculateTotal()
  {

    double t=0;

    for(int k=0;k<cartdata.length;k++) {

      int q=0;

      if(cartdata[k].qty.isNotEmpty)
        {
          q=int.parse(cartdata[k].qty);

          if(cartdata[k].unitprice.isNotEmpty)
            {

              double p=double.parse(cartdata[k].unitprice);
              t=t+(p*q);


            }

        }

    }

setState(() {

  totalamount=t;

  double w=totalamount*walletsavepercentage/100;

 walletsaveamount=double.parse(w.toStringAsFixed(3));

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
