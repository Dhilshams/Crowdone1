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
import 'package:ecommerce/domain/CartData.dart';
import 'package:ecommerce/domain/Address.dart';
import 'package:ecommerce/ui/address_list.dart';

import 'add_new_address.dart';

class AddressList extends StatefulWidget {
   AddressList();

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  List<Address>adr=[];

  TextEditingController namecontroller=new TextEditingController();
  TextEditingController housenamecontroller=new TextEditingController();
  TextEditingController streetcontroller=new TextEditingController();
  TextEditingController placecontroller=new TextEditingController();
  TextEditingController phonecontroller=new TextEditingController();
  TextEditingController zipcodecontroller=new TextEditingController();

  late Address selected_address;

  int selectedindex=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getAddressList();

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({'added': selectedindex});
      return true;
    },
    child:


      Scaffold(


      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,

        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop({'added': selectedindex});
            }
        ),
        title: Text("My Address",style: TextStyle(color: Colors.black,fontSize: 15),),
        centerTitle: false,




      ),

      body: Stack(

        children: [

          (adr.length>0)?  Align(
            alignment: FractionalOffset.topCenter,
            child: ListView.builder(
                itemCount: adr.length,
                padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
                itemBuilder: (BuildContext context, int index) {
                  return Card(

                    child:ListTile(
                        leading: (adr[index].selected==1)? Icon(Icons.check_circle,color: Colors.green,size: ResponsiveInfo.isMobile(context)?18:23,) :

                       GestureDetector(

                         child:Icon(Icons.radio_button_off_outlined,color: Colors.black54,size: ResponsiveInfo.isMobile(context)?18:23,) ,
                         onTap: (){

                           setState(() {

                             for(int k=0;k<adr.length;k++)
                             {

                               adr[k].selected=0;


                             }
                             adr[index].selected=1;
                             selectedindex=index;

                           });




                         },
                       )

                        ,
                        trailing: TextButton(

                          child:Text(
                            "Edit",
                            style: TextStyle(color: Colors.green, fontSize: ResponsiveInfo.isMobile(context)? 13 : 15),
                          ) ,
                          onPressed: (){
                            selected_address=adr[index];

                            // List<String>addressdata1=selected_address.addressdata.split(",");
                            // if(addressdata1.length>0)
                            //   {
                            //
                            //     namecontroller.text=addressdata1[0];
                            //     housenamecontroller.text=addressdata1[1];
                            //     streetcontroller.text=addressdata1[2];
                            //     placecontroller.text=addressdata1[3];
                            //     phonecontroller.text=addressdata1[4];
                            //     zipcodecontroller.text=addressdata1[5];
                            //
                            //   }

                            showAddress(1);
                          },
                        )


                        ,
                        title: Text( adr[index].addressdata,maxLines: 3 ,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 : 15,color: Colors.black ),)

                    ) ,
                    elevation: 5,
                  )


                    ;
                })  ,
          ) : Align(
            alignment: FractionalOffset.center,
            child: Text("No delivery address found"),
          ),



          Align(

            alignment: FractionalOffset.bottomRight,
            child: Padding(

              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),

              child: FloatingActionButton(
                child: Icon(Icons.add,color: Colors.white,size: ResponsiveInfo.isMobile(context)?18:23,),
                backgroundColor: Colors.blue,

                onPressed: ()async{




                    namecontroller.text="";
                    housenamecontroller.text="";
                    streetcontroller.text="";
                    placecontroller.text="";
                    phonecontroller.text="";
                    zipcodecontroller.text="";

selected_address=new Address("0", "", 0);

                  showAddress(0);

                },
              ),
            )



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

  showAddress(int code)async
  {
//     Widget okButton1 = TextButton(
//       child: (code==1)?Text("update") : Text("Add"),
//       onPressed: () async{
//
//         // TextEditingController namecontroller=new TextEditingController();
//         // TextEditingController housenamecontroller=new TextEditingController();
//         // TextEditingController streetcontroller=new TextEditingController();
//         // TextEditingController placecontroller=new TextEditingController();
//         // TextEditingController phonecontroller=new TextEditingController();
//         // TextEditingController zipcodecontroller=new TextEditingController();
//
//
//         if(!namecontroller.text.isEmpty) {
//           if(!housenamecontroller.text.isEmpty) {
//             if(!streetcontroller.text.isEmpty) {
//
//               if(!placecontroller.text.isEmpty) {
//
//                 if(!phonecontroller.text.isEmpty) {
//
//                   if(!zipcodecontroller.text.isEmpty) {
//
//
//
//                     showLoaderDialog(context);
//
//                     final preferenceDataStorage = await SharedPreferences
//                         .getInstance();
//                     String? uid=  preferenceDataStorage.getString(Constants.pref_userid);
//                     String addrressfull=namecontroller.text+","+housenamecontroller.text+","+streetcontroller.text+","+placecontroller.text+","+phonecontroller.text+","+zipcodecontroller.text;
//
//                     if(code==0) {
//                       final productRef = FirebaseFirestore.instance.collection(
//                           'addresslist').doc();
//                       await productRef.set({
//                         'address': addrressfull,
//                         'userid': uid.toString()
//                       }).then((value) {
//                         Navigator.pop(context);
//                       });
//                     }
//                     else{
//
//                       final productRef = FirebaseFirestore.instance.collection(
//                           'addresslist').doc(selected_address.id);
//                       await productRef.update({
//                         'address': addrressfull,
//                         'userid': uid.toString()
//                       }).then((value) {
//                         Navigator.pop(context);
//                       });
//                     }
//
//                   }
//                   else{
//
//
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Enter zip code'),
//                     ));
//                   }
//
//                 }
//                 else{
//
//
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Enter phone number'),
//                   ));
//                 }
//
//               }
//               else{
//
//
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Enter place'),
//                 ));
//               }
//
//             }
//             else{
//
//
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text('Enter street'),
//               ));
//             }
//
//
//
//           }
//           else{
//
//
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('Enter house name'),
//             ));
//           }
//
//
//
//
//         }
//         else{
//
//
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Enter name'),
//           ));
//         }
//
//
//       },
//     );
//
//     Widget okButton2 = TextButton(
//       child: Text("Delete"),
//       onPressed: () async{
// Navigator.pop(context);
// if(code==1)
//   {
//     showLoaderDialog(context);
//
//     final productRef = FirebaseFirestore.instance.collection(
//         'addresslist').doc(selected_address.id);
//
//     productRef.delete().then((value) {
//       Navigator.pop(context);
//       getAddressList();
//
//     });
//   }
//
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title:Container(),
//       content:  Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: SingleChildScrollView(
//
//           child: Column(
//
//             children: [
//
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Name',
//                     hintText: 'Name',
//                   ),
//                   controller: namecontroller,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'House name',
//                     hintText: 'House name',
//                   ),
//                   controller: housenamecontroller,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Street',
//                     hintText: 'Street',
//                   ),
//                   controller: streetcontroller,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Place',
//                     hintText: 'Place',
//                   ),
//                   controller: placecontroller,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Phone',
//                     hintText: 'Phone',
//                   ),
//                   controller: phonecontroller,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Zip code',
//                     hintText: 'Zip code',
//                   ),
//                   controller: zipcodecontroller,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//       ),
//
//
//
//
//       actions: [
//
//         okButton1,
//         (code==1)?okButton2 :Container()
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );

    Map results =
    await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return new AddNewAddress(selected_address);
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

          getAddressList();
        });
      }
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
int k=0;
    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];


      var m = ab.data() as Map<String, dynamic>;
      String userid=m['userid'];
      String address=m['address'];
      if(userid.trim().compareTo(uid.toString())==0)
      {
        k++;

        setState(() {

          if(k==1)
          {
            adr.add(new Address(ab.id, address,1));
          }
          else{

            adr.add(new Address(ab.id, address,0));
          }

        });

      }



    }


  }
}
