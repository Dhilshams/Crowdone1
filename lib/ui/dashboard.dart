import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:ecommerce/ui/payment_page.dart';
import 'package:ecommerce/ui/home.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatefulWidget {
   Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  String name="";
  String mno="";
  String mtype="";
  String stdate="";
  String enddate="";
  String allotno="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    getProductOfferList();
  }
  List<Map<String,dynamic>>mpoffer=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        
        children: [
          
          Expanded(child: Padding(

          child:Container(

            decoration: BoxDecoration(
                color: Color(0xff464646),
                border: Border.all(color: Color(0xff464646)),
                borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?12:17),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Icon(Icons.person_outline,color: Colors.white,),
                    Text( '   '+name, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14))

      ],

    )
    ),


                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?12:14),


                    child:            QrImageView(
                      data: mno,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white70,
                      size: ResponsiveInfo.isMobile(context)?150:180,
                    ),


                ),


    Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?12:14),


    child:Text( 'Membership number: '+mno, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

    )),


                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:10),


                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text( 'Membership type', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        ),

                        Text( ''+mtype, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        )
                      ],
                    )

                   ),


                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:10),


                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text( 'Date of Membership', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        ),

                        Text( ''+stdate, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        )
                      ],
                    )

                ),

                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:10),


                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text( 'Investment allotment date', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        ),

                        Text( ''+enddate, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        )
                      ],
                    )

                ),


                Padding(padding:  EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:10),


                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text( 'Allotment number', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        ),

                        Text( ''+allotno, style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?12:14)

                        )
                      ],
                    )

                )




              ],
            ),


          ) ,
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?8:12),
      )

          ,flex: 3,),

          Expanded(child: Padding(
              padding: EdgeInsets.all(
                  ResponsiveInfo.isMobile(context) ? 3 : 7),
              child: (mpoffer.length>0)?CarouselSlider(
                options: CarouselOptions(),
                items: mpoffer.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),

                        child:Image.network(i['image']!.toString(),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width/1.7,
                          fit: BoxFit.fill,
                        ) ,

                      )

                      ;
                    },
                  );
                }).toList(),
              ) :Container()
          )
            ,flex: 1,)
          
          
        ],
      ),

    );
  }



  getProductOfferList()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection('salesoffer').get();

    List<dynamic>c=    productSnapshot.docs.toList();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      setState(() {

        mpoffer.add(m);
      });


    }



  }


  getUserDetails()async{

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? id=  preferenceDataStorage.getString(Constants.pref_userid);

    await FirebaseFirestore.instance.collection('registration').doc(id).get().then((value) {


  Map<String,dynamic> m= value.data()!;

  mtype=m['membertype'];
  preferenceDataStorage.setString(Constants.mtype, mtype);

  setState(() {



mno=m['membershipno'];
name=m['name'];
mtype=m['membertype'];
allotno=m['allotment_type'];
stdate=m['startDate'];
enddate=m['endDate'];



  });





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
