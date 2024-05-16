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

class AddMemberShipTypes extends StatefulWidget {
  int code;
  MembershipDetails sl;


   AddMemberShipTypes(this.code,this.sl) ;

  @override
  _AddMemberShipTypesState createState() => _AddMemberShipTypesState(this.code,this.sl);
}

class _AddMemberShipTypesState extends State<AddMemberShipTypes> {


  int code;
  MembershipDetails sl;

  _AddMemberShipTypesState(this.code,this.sl);

  TextEditingController nameController = new TextEditingController();

  TextEditingController descriptionController = new TextEditingController();

  TextEditingController amountcontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if(code==1)
    {
      setState(() {
        nameController.text=sl.name;
        descriptionController.text=sl.description;
        amountcontroller.text=sl.amount;

      });

    }


  }

  Future<bool> _onBackPressed() {
    bool a=true;

    if(a) {
      Navigator.of(context).pop({'added': 1});
      return Future.value(true);
    }
    return Future.value(false);
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
              Navigator.of(context).pop({'added': 1});
            }
        ),
        title: Text(
          (code==0)? "Add Membership Type" : "Update Membership Type",
          style: TextStyle(color: Colors.black, fontSize: 15),),
        centerTitle: false,
      ),

      body:   Stack(

    children: [

    Align(
    alignment: FractionalOffset.topCenter,
      child:Column(
        children: [





          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
                hintText: 'Title',
              ),
              controller: nameController,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                hintText: 'Amount',
              ),
              controller: amountcontroller,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.text,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                hintText: 'Description',
              ),
              controller: descriptionController,
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
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                ),
                onPressed: () async {

                  if(nameController.text.isNotEmpty)
                  {
                    if(amountcontroller.text.isNotEmpty)
                    {

                      if(descriptionController.text.isNotEmpty) {
                        showLoaderDialog(context);


                        if (code == 1) {
                          final productRef = FirebaseFirestore.instance
                              .collection('membership_data').doc(sl.id);
                          await productRef.update({
                            'name': nameController.text,
                           'description':descriptionController.text,
                            'amount': amountcontroller.text,
                          }).then((value) {
                            Navigator.pop(context);
                            ResponsiveInfo.showAlertDialog(context, "", "Membership type updated successfully");

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text(
                            //       'Membership type updated successfully')),
                            // );
                            setState(() {
                              nameController.clear();
                              descriptionController.clear();
                              amountcontroller.clear();

                            });
                          });
                        }
                        else {
                          final productRef = FirebaseFirestore.instance
                              .collection('membership_data').doc();
                          await productRef.set({
                            'name': nameController.text,
                            'description':descriptionController.text,
                            'amount': amountcontroller.text,
                          }).then((value) {
                            Navigator.pop(context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text(
                            //       'Membership type added successfully')),
                            // );

                            ResponsiveInfo.showAlertDialog(context, "", "Membership type added successfully");


                            setState(() {
                              nameController.clear();
                              descriptionController.clear();
                              amountcontroller.clear();

                            });
                          });
                        }
                      }
                      else{

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Enter Description')),
                        // );

                        ResponsiveInfo.showAlertDialog(context, "", "Enter Description");


                      }



                    }
                    else{

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Enter amount')),
                      // );

                      ResponsiveInfo.showAlertDialog(context, "", "Enter amount");

                    }

                  }
                  else{

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Enter name')),
                    // );

                    ResponsiveInfo.showAlertDialog(context, "", "Enter name");

                  }




                },
              ),
            ),
          ),




        ],

      ) ,

    )


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
