import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/dashboard.dart';
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
import 'package:ecommerce/ui/payment_page.dart';
import 'package:ecommerce/ui/home.dart';

import '../domain/MembershipDetails.dart';

class Membership extends StatefulWidget {



   Membership() ;

  @override
  _MembershipState createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {


List<String>arr=["Enterpreneur Membership","Distributor Membership","Investor Membership","Producer Membership"];
List<int>arrcolor=[0xff1f5796,0xff956e01,0xff5b918c,0xffb84060,0xff956e02,0xff956e45,0xff956e33,0xff956e01,0xff956562];

List<String>amounts=["10000","5000","3000","15000"];
List<MembershipDetails>salesoffer=[];

String customermembership="";






getSalesOffersList() async {
  final productSnapshot1 = await FirebaseFirestore.instance.collection(
      'membership_data').get();

  List<dynamic>c = productSnapshot1.docs.toList();
  bool a = false;
  salesoffer.clear();
  for (int i = 0; i < c.length; i++) {
    QueryDocumentSnapshot ab = c[i];

    var m = ab.data() as Map<String, dynamic>;


    String name = m['name'];
    String description = m['description'];
    String amount = m['amount'];
    String id = ab.id;

    MembershipDetails data = new MembershipDetails(id, name, description,amount);

    setState(() {
      if(amount.compareTo("0")==0)
        {
          customermembership=name;
        }

      salesoffer.add(data);
    });
  }


  // countryList
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSalesOffersList();
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
          "Membership",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),

        actions: [

          TextButton(

            child:Text(
              "Skip",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ) ,
            onPressed: () async {

              DateTime dtnow = new DateTime.now();
              String stdate = dtnow.day.toString() + "-" +
                  dtnow.month.toString() + "-" + dtnow.year.toString();

              String enddate = dtnow.day.toString() + "-" +
                  (dtnow.month + 1).toString() + "-" +
                  dtnow.year.toString();

              Random random = new Random();
              int randomNumber = random.nextInt(1000000);

              String alotno = random.nextInt(900).toString() + "/" +
                  random.nextInt(100).toString() + "/" +
                  random.nextInt(500).toString();

              showLoaderDialog(context);
              final preferenceDataStorage = await SharedPreferences
                  .getInstance();
              String? id=  preferenceDataStorage.getString(Constants.pref_userid);

              await FirebaseFirestore.instance.collection('registration')
                  .doc(
                  id).update({'isverified': true,
                'membertype': customermembership,
                'amount': "0",
                'startDate': stdate,
                'membershipno': randomNumber.toString(),
                'allotment_type': alotno,
                'endDate': enddate})
                  .whenComplete(() {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyDashboardPage()),
                );
              });


            },
          )
        ],

      ),

      body:  Stack(

        children: <Widget>[

          Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:14),

            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Padding(padding: EdgeInsets.all(4),
    child: Text( 'Choose membership plan', style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?20:25,fontWeight: FontWeight.bold),


    )),
    Padding(padding: EdgeInsets.all(4),
    child: Text( 'Choose a membership plan .Otherwise you can skip this', style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context)?10:13,fontWeight: FontWeight.normal),


    ))
    ],
    )

          ),

          Padding(padding: EdgeInsets.fromLTRB( ResponsiveInfo.isMobile(context)?10:14,ResponsiveInfo.isMobile(context)?90:110,ResponsiveInfo.isMobile(context)?10:14,ResponsiveInfo.isMobile(context)?10:14),

              child: ListView.builder(
                  itemCount: salesoffer.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(

                      child:Container(
                        width: double.infinity,
                        height: ResponsiveInfo.isMobile(context)?175:215,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                                    child: Text( salesoffer[index].name,
                                      style: TextStyle(color: Colors.white,
                                          fontSize: ResponsiveInfo.isMobile(context)?20:25,fontWeight: FontWeight.bold),


                                    )),

                                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                                    child: Text( "choose "+salesoffer[index].name+" plan ",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
                                      maxLines: 2,



                                    ))
                              ],
                            ),flex: 2,),

                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                                    child: Text( "Membership Fee \n "+salesoffer[index].amount+" Rs",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
                                      maxLines: 2,



                                    )),

                                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
                                    child: GestureDetector(

                                    child:Container(
                                        padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)? 3 : 6),

                                        decoration: BoxDecoration(

                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                                        ),


                                        child:  Text( "Choose   > ",
                                          style: TextStyle(color: Colors.white,
                                              fontSize: ResponsiveInfo.isMobile(context)?12:14,fontWeight: FontWeight.normal),
                                          maxLines: 2,



                                        )),
                                      onTap: ()async{

                                        final preferenceDataStorage = await SharedPreferences
                                            .getInstance();
                                      String? id=  preferenceDataStorage.getString(Constants.pref_userid);
                                        // preferenceDataStorage.setString(Constants.pref_usertype, Constants.normal_usertype);


                                        if(salesoffer[index].amount.compareTo("0")==0)
                                          {
                                            DateTime dtnow = new DateTime.now();
                                            String stdate = dtnow.day.toString() + "-" +
                                                dtnow.month.toString() + "-" + dtnow.year.toString();

                                            String enddate = dtnow.day.toString() + "-" +
                                                (dtnow.month + 1).toString() + "-" +
                                                dtnow.year.toString();

                                            Random random = new Random();
                                            int randomNumber = random.nextInt(1000000);

                                            String alotno = random.nextInt(900).toString() + "/" +
                                                random.nextInt(100).toString() + "/" +
                                                random.nextInt(500).toString();

                                            showLoaderDialog(context);
                                            final preferenceDataStorage = await SharedPreferences
                                                .getInstance();
                                            String? id=  preferenceDataStorage.getString(Constants.pref_userid);

                                            await FirebaseFirestore.instance.collection('registration')
                                                .doc(
                                                id).update({'isverified': true,
                                              'membertype': customermembership,
                                              'amount': "0",
                                              'startDate': stdate,
                                              'membershipno': randomNumber.toString(),
                                              'allotment_type': alotno,
                                              'allocated_distributor': "",
                                              'endDate': enddate})
                                                .whenComplete(() {
                                              Navigator.pop(context);

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MyDashboardPage()),
                                              );
                                            });
                                          }
                                        else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentPage(
                                                      salesoffer[index].amount,
                                                      salesoffer[index].name,
                                                      id.toString()),
                                            ),
                                          );
                                        }



                                      },
                                    )




                                )

                              ],
                            ),flex: 1,)


                            
                          ],
                        ),

                      )


                      ,
                      elevation: 10,
                      color: Color(arrcolor[index]),
                    )


                      ;
                  })

          ),

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

}
