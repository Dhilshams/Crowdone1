import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';

class UomPage extends StatefulWidget {
   UomPage() ;

  @override
  _UomPageState createState() => _UomPageState();
}

class _UomPageState extends State<UomPage> {

  TextEditingController userController=new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUomList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("Unit of Measurements",style: TextStyle(color: Colors.white,fontSize: 12),),
        centerTitle: false,
        actions: [

          Padding(padding: EdgeInsets.all(15),

            child: GestureDetector(
              child: Icon(Icons.add,color: Colors.white,size: ResponsiveInfo.isMobile(context)?30:40),

              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory()));
                Widget okButton1 = TextButton(
                  child: Text("ok"),
                  onPressed: () async{

                    if(!userController.text.isEmpty) {
                      final productRef = FirebaseFirestore.instance.collection(
                          'units').doc();
                      await productRef.set({
                        'name': userController.text,
                      }).then((value) {
                        userController.clear();
                        Navigator.pop(context);

                      });
                    }
                    else{


                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text('Enter unit'),
                      // ));

                      ResponsiveInfo.showAlertDialog(context, "", "Enter  unit");

                    }


                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title:Container(),
                  content:         Padding(
                    padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Unit of Measurement',
                        hintText: 'Unit of Measurement',
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

            ),
          )




        ],


      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('units').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child:Center(
                child: CircularProgressIndicator(),
              ) ,
            )

            ;
          }

          List<CategoryData>list=[];

          snapshot.data!.docs.forEach((DocumentSnapshot document)async {
            Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

            if (data != null) {
              String id = document.id;
              String name = data['name'] ?? '';


              list.add(new CategoryData(id,name,""));



            }
          });



          return Stack(

            children: [

              Align(
                alignment: FractionalOffset.topCenter,
                child:ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(

                      child:ListTile(
                          leading: Icon(Icons.scale,size: 25,),
                          trailing: TextButton(

                            child:Text(
                              "Delete",
                              style: TextStyle(color: Colors.green, fontSize: 15),
                            ) ,
                            onPressed: (){

                              Widget okButton = TextButton(
                                child: Text("yes"),
                                onPressed: () {

                                  FirebaseFirestore.instance.collection('units').doc(list[index].id).delete();

                                  setState(() {

                                    list.removeAt(index);
                                  });

                                  Navigator.pop(context);






                                },
                              );

                              Widget okButton1 = TextButton(
                                child: Text("no"),
                                onPressed: () { },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("Delete Unit of measurements"),
                                content: Text("Do you want to delete this Unit of measurements ?"),
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
                          )

                          ,
                          title: Text(list[index].name,style: TextStyle(color: Colors.black, fontSize: 15),)) ,
                      elevation: 8,
                    )


                    ;
                  },
                ) ,
              ),




            ],
          )


          ;
        },
      ),


    );
  }



  getUomList()async
  {




  }


}
