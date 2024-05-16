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
import 'package:ecommerce/domain/SalesOffer.dart';
import 'package:ecommerce/ui/admin/add_sales_offers.dart';
import 'package:ecommerce/ui/admin/member_ship_details.dart';
import 'package:ecommerce/domain/MembershipDetails.dart';
import 'package:ecommerce/ui/admin/add_member_ship_types.dart';

class MemberShipDetails extends StatefulWidget {
   MemberShipDetails() ;

  @override
  _MemberShipDetailsState createState() => _MemberShipDetailsState();
}

class _MemberShipDetailsState extends State<MemberShipDetails> {


  List<MembershipDetails>salesoffer=[];




  @override
  void initState() {
    super.initState();
    getSalesOffersList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Stack(

        children: [

          (salesoffer.length>0)?    Align(
            alignment: FractionalOffset.topCenter,
            child: ListView.builder(
                itemCount: salesoffer.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return Card(

                    child:        Container(
                      width: double.infinity,
                      height: ResponsiveInfo.isMobile(context)?150:200,

                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(child: Padding(padding: EdgeInsets.all(5),

                                child: Text(salesoffer[index].name,style: TextStyle(color: Colors.black, fontSize: 15)),
                              ),flex: 1,)

                              ,

                              Expanded(child:  Padding(padding: EdgeInsets.all(5),

                                child: Text(salesoffer[index].description,style: TextStyle(color: Colors.black, fontSize: 13,overflow: TextOverflow.ellipsis),maxLines: 5,),
                              ),flex: 2,)




                            ],



                          ),flex: 2,),

                          Expanded(child: ListTile(

                            trailing: TextButton(
                              child:Text(
                                "Edit",
                                style: TextStyle(color: Colors.green, fontSize: 15),
                              ),
                              onPressed: ()async{

                                Map results =
                                await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) {
                                    return new AddMemberShipTypes(1,salesoffer[index]);
                                  },
                                ));

                                if (results != null && results.containsKey('added')) {
                                  var acc_selected = results['added'];

                                  int code = acc_selected as int;
                                  if (code == 1) {
                                    getSalesOffersList();
                                  }
                                }


                              },

                            )



                            ,



                          ),flex: 1,)




                        ],

                      ) ,

                    ) ,
                    elevation: 5,

                  )






                  ;
                }),
          ) : Align(
            alignment: FractionalOffset.center,

            child:Text(
              "No data found",
              style: TextStyle(color: Colors.black, fontSize: 15),) ,

          )
        ],
      ) ,
      appBar:   AppBar(
      elevation: 0,
      backgroundColor: Colors.white70,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      title: Text(
        "Membership Details",
        style: TextStyle(color: Colors.black, fontSize: 15),),
      centerTitle: false,
      actions: [


        Padding(padding: EdgeInsets.all(15),

            child: GestureDetector(

              child: Icon(Icons.add, size: 25, color: Colors.black,),

              onTap: () async{
                // AddCountryData();

                Map results =
                await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) {
                    return new AddMemberShipTypes(0,new MembershipDetails("","","",""));
                  },
                ));

                if (results != null && results.containsKey('added')) {
                  var acc_selected = results['added'];

                  int code = acc_selected as int;
                  if (code == 1) {
                    getSalesOffersList();
                  }
                }



              },
            )


        )
      ],


    ),
    )


      ;
  }



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
        salesoffer.add(data);
      });
    }


    // countryList
  }
}
