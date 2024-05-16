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
import 'package:image_picker/image_picker.dart';

class AddProductOffers extends StatefulWidget {

  int code;
  SalesOffer sl;


  AddProductOffers(this.code,this.sl) ;




  @override
  _AddProductOffersState createState() => _AddProductOffersState(this.code,this.sl);
}

class _AddProductOffersState extends State<AddProductOffers> {

  int code;
  SalesOffer sl;

  _AddProductOffersState(this.code,this.sl);

  TextEditingController nameController = new TextEditingController();

  TextEditingController descriptionController = new TextEditingController();

  String filepath = "";




  @override
  void initState() {
    super.initState();
    if(code==1)
    {
      setState(() {
        nameController.text=sl.title;

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
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:


        Scaffold(
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
              (code==0)? "Add Product Offers" : "Update Product Offers",
              style: TextStyle(color: Colors.black, fontSize: 15),),
            centerTitle: false,



          ),
          body: Stack(

            children: [

              Align(
                alignment: FractionalOffset.topCenter,
                child:Column(
                  children: [

                    Padding(
                      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                      child:(code==0)?

                      Container(
                        width: double.infinity,
                        height: ResponsiveInfo.isMobile(context) ? 240 : 300,

                        child:(filepath.isNotEmpty)?  Image.file(File(filepath),width:double.infinity ,
                          height: ResponsiveInfo.isMobile(context) ? 220 : 280,

                          fit: BoxFit.fill,

                        ) : Icon(Icons.image,color: Colors.black26,size:ResponsiveInfo.isMobile(context) ? 200 : 250 , ),


                      ) : Container(
                        width: double.infinity,
                        height: ResponsiveInfo.isMobile(context) ? 240 : 300,

                        child:(filepath.isNotEmpty)?  Image.file(File(filepath),width:double.infinity ,
                          height: ResponsiveInfo.isMobile(context) ? 220 : 280,

                          fit: BoxFit.fill,

                        ) : Image.network(sl.image,width:double.infinity ,
                          height: ResponsiveInfo.isMobile(context) ? 220 : 280,

                          fit: BoxFit.fill,

                        ),


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
                            'Add Image',
                            style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                          ),
                          onPressed: () async {
                            // Call a function to authenticate user
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                filepath=pickedFile!.path;
                              });
                            }



                          },
                        ),
                      ),
                    ),

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
                            'Add Offer',
                            style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                          ),
                          onPressed: () async {

                            if(filepath.isNotEmpty)
                            {
                              if(nameController.text.isNotEmpty)
                              {
                                showLoaderDialog(context);
                                final ref = FirebaseStorage.instance.ref().child('productofferimages').child('${DateTime.now()}.jpg');
                                await ref.putFile(new File(filepath));
                                final imageUrl = await ref.getDownloadURL();

                                if(code==1)
                                {
                                  final productRef = FirebaseFirestore.instance
                                      .collection('productoffer').doc(sl.id);
                                  await productRef.update({
                                    'title': nameController.text,
                                    // Set the ID of the product as a field in the document
                                    'image': imageUrl,
                                  }).then((value) {
                                    Navigator.pop(context);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text('Product offer updated successfully')),
                                    // );

                                    ResponsiveInfo.showAlertDialog(context, "", "Product offer updated successfully");

                                    setState(() {
                                      nameController.clear();
                                      filepath = "";
                                    });
                                  });
                                }
                                else {
                                  final productRef = FirebaseFirestore.instance
                                      .collection('productoffer').doc();
                                  await productRef.set({
                                    'title': nameController.text,
                                    // Set the ID of the product as a field in the document
                                    'image': imageUrl,
                                  }).then((value) {
                                    Navigator.pop(context);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(content: Text('Product offer added successfully')),
                                    // );

                                    ResponsiveInfo.showAlertDialog(context, "", "Product offer added successfully");

                                    setState(() {
                                      nameController.clear();
                                      filepath = "";
                                    });
                                  });
                                }



                              }
                              else{

                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text('Please enter title')),
                                // );
                                ResponsiveInfo.showAlertDialog(context, "", "Please enter title");


                              }

                            }
                            else{

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Please Select image')),
                              // );

                              ResponsiveInfo.showAlertDialog(context, "", "Please Select image");


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


        ) );
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
