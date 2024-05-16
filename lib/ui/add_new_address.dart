import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/Constants.dart';
import '../designs/ResponsiveInfo.dart';
import '../domain/Address.dart';

class AddNewAddress extends StatefulWidget {

  Address selected_address;

   AddNewAddress(this.selected_address) ;

  @override
  _AddNewAddressState createState() => _AddNewAddressState(this.selected_address);
}

class _AddNewAddressState extends State<AddNewAddress> {



  Address selected_address;

  _AddNewAddressState(this.selected_address);

  TextEditingController namecontroller=new TextEditingController();
  TextEditingController housenamecontroller=new TextEditingController();
  TextEditingController streetcontroller=new TextEditingController();
  TextEditingController placecontroller=new TextEditingController();
  TextEditingController phonecontroller=new TextEditingController();
  TextEditingController zipcodecontroller=new TextEditingController();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



showAddress();


  }


  showAddress()
  {
    setState(() {

      if(selected_address.addressdata.isNotEmpty) {
        List<String>addressdata1 = selected_address.addressdata.split(",");
        if (addressdata1.length > 0) {
          namecontroller.text = addressdata1[0];
          housenamecontroller.text = addressdata1[1];
          streetcontroller.text = addressdata1[2];
          placecontroller.text = addressdata1[3];
          phonecontroller.text = addressdata1[4];
          zipcodecontroller.text = addressdata1[5];
        }
      }



    });
  }



  @override
  Widget build(BuildContext context) {

    return   WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop({'added': 0});
        return true;
      },
      child:

     Scaffold(
      appBar:   AppBar(
      elevation: 0,

      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop({'added': 1});
          }
      ),
      title: Text("Add Address",style: TextStyle(color: Colors.black,fontSize: 15),),
      centerTitle: false,
actions: [

  (selected_address.id.compareTo("0")!=0)?  Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
  child: IconButton(

    icon: Icon(Icons.delete,color: Colors.white,size: ResponsiveInfo.isMobile(context)?20:24,),
    onPressed: () {

      showLoaderDialog(context);

      final productRef = FirebaseFirestore.instance.collection(
          'addresslist').doc(selected_address.id);

      productRef.delete().then((value) {
        Navigator.pop(context);
        Navigator.of(context).pop({'added': 1});

      });



    },

  ),


  ) : Container()


],



    ),


      body:SingleChildScrollView(

        child: Column(

          children: [

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Name',
                ),
                controller: namecontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'House name',
                  hintText: 'House name',
                ),
                controller: housenamecontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Street',
                  hintText: 'Street',
                ),
                controller: streetcontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Place',
                  hintText: 'Place',
                ),
                controller: placecontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                  hintText: 'Phone',
                ),
                controller: phonecontroller,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Zip code',
                  hintText: 'Zip code',
                ),
                controller: zipcodecontroller,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: Container(
                width: ResponsiveInfo.isMobile(context)?150:180,
                height: ResponsiveInfo.isMobile(context)?60:80,
                color: Colors.blue,
                child: TextButton(

                  onPressed: () async {


                    if(!namecontroller.text.isEmpty) {
                      if(!housenamecontroller.text.isEmpty) {
                        if(!streetcontroller.text.isEmpty) {

                          if(!placecontroller.text.isEmpty) {

                            if(!phonecontroller.text.isEmpty) {

                              if(!zipcodecontroller.text.isEmpty) {



                                showLoaderDialog(context);

                                final preferenceDataStorage = await SharedPreferences
                                    .getInstance();
                                String? uid=  preferenceDataStorage.getString(Constants.pref_userid);
                                String addrressfull=namecontroller.text+","+housenamecontroller.text+","+streetcontroller.text+","+placecontroller.text+","+phonecontroller.text+","+zipcodecontroller.text;

                                if(selected_address.id.compareTo("0")==0){
                                  final productRef = FirebaseFirestore.instance.collection(
                                      'addresslist').doc();
                                  await productRef.set({
                                    'address': addrressfull,
                                    'userid': uid.toString()
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.of(context).pop({'added': 1});
                                  });
                                }
                                else{

                                  final productRef = FirebaseFirestore.instance.collection(
                                      'addresslist').doc(selected_address.id);
                                  await productRef.update({
                                    'address': addrressfull,
                                    'userid': uid.toString()
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.of(context).pop({'added': 1});
                                  });
                                }

                              }
                              else{


                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //   content: Text('Enter zip code'),
                                // ));

                                ResponsiveInfo.showAlertDialog(context, "", "Enter zip code");

                              }

                            }
                            else{





                              ResponsiveInfo.showAlertDialog(context, "", "Enter phone number");

                            }

                          }
                          else{


                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //   content: Text('Enter place'),
                            // ));

                            ResponsiveInfo.showAlertDialog(context, "", "Enter place");


                          }

                        }
                        else{


                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text('Enter street'),
                          // ));


                          ResponsiveInfo.showAlertDialog(context, "", "Enter street");


                        }



                      }
                      else{


                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text('Enter house name'),
                        // ));


                        ResponsiveInfo.showAlertDialog(context, "", "Enter house name");



                      }




                    }
                    else{


                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text('Enter name'),
                      // ));

                      ResponsiveInfo.showAlertDialog(context, "", "Enter name");

                    }





                  },
                  child: Text((selected_address.id.compareTo("0")==0)?"Add" : "Update",style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?13:16,color: Colors.white),),
                ),
              )



            ),



          ],
        ),
      ) ,
    ) );
  }
}
