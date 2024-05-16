import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';

class AddCategory extends StatefulWidget {


String id="";

   AddCategory(this.id) ;

  @override
  _AddCategoryState createState() => _AddCategoryState(this.id);
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController userController = TextEditingController();

  String filepath="";


  int edit=0;
  String id="";

  String netimagepath="";
  String imgurl="";
  _AddCategoryState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

getProductDetails();


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
        title: Text((id.isNotEmpty)?"Edit Category" : "Add Category",style: TextStyle(color: Colors.white,fontSize: 12),),
        centerTitle: false,

        actions: [

          (id.isNotEmpty)?  Padding(padding: EdgeInsets.all(10),

          child: TextButton(

            child:Text(
              "Delete",
              style: TextStyle(color: Colors.green, fontSize: 15),
            ) ,
            onPressed: (){



              Widget okButton = TextButton(
                child: Text("yes"),
                onPressed: () {

                FirebaseFirestore.instance.collection('categories').doc(id).delete();



                Navigator.pop(context);






                },
              );

              Widget okButton1 = TextButton(
                child: Text("no"),
                onPressed: () { },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Delete Category"),
                content: Text("Do you want to delete category ?"),
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
          ),
          ) :Container()
        ],

      ),

      body: Column(

        children: [


          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 120,
              height: 120,
              child:      Stack(

                children: [

                  (id.isEmpty)?  Align(
                    alignment: FractionalOffset.center,
                    child:  (filepath.isEmpty)?Icon(Icons.image,size: 100,color: Colors.black26,):
                    Image.file(File(filepath),width: 100,height: 100,fit: BoxFit.fill,) ,

                  ) : Container(),

                  (id.isNotEmpty)?  Align(
                    alignment: FractionalOffset.center,
                    child:  (filepath.isEmpty)? ((netimagepath.isNotEmpty)?  Image.network(netimagepath,width: 100,height: 100): Container() ):
                    Image.file(File(filepath),width: 100,height: 100,fit: BoxFit.fill,) ,

                  ) : Container(),


                  Align(
                    alignment: FractionalOffset.bottomRight,

                    child:FloatingActionButton(
                      mini: true,
                      onPressed: () async{

                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            filepath=pickedFile.path;
                          });
                        }

                      },
                      child: Icon(Icons.add_a_photo),
                    ) ,
                  )






                ],
              ),

            )


          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Name',
              ),
              controller: userController,
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
    (id.isNotEmpty)?'Update': 'Add',
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                ),
                onPressed: () async {
                  // Call a function to authenticate user

                  if(id.isEmpty) {
                    if (!filepath.isEmpty) {
                      if (!userController.text.isEmpty) {
                        final ref = FirebaseStorage.instance.ref().child(
                            'categoryimages').child('${DateTime.now()}.jpg');
                        await ref.putFile(new File(filepath));
                        final imageUrl = await ref.getDownloadURL();

                        final productRef = FirebaseFirestore.instance
                            .collection('categories').doc();
                        await productRef.set({
                          'name': userController.text,
                          // Set the ID of the product as a field in the document
                          'image_path': imageUrl,


                        }).then((value) {

                          ResponsiveInfo.showAlertDialog(
                              context, "", "Category Added Successfully");
                          userController.clear();
                          setState(() {
                            filepath = "";
                          });
                        });
                      }
                      else {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text('Enter Category'),
                        // ));

                        ResponsiveInfo.showAlertDialog(
                            context, "", "Enter Category");
                      }
                    }
                    else {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text('Pick file'),
                      // ));

                      ResponsiveInfo.showAlertDialog(context, "", "Pick file");
                    }
                  }
                  else{

    if (!userController.text.isEmpty) {



    if (!filepath.isEmpty) {

      final ref = FirebaseStorage.instance.ref().child(
          'categoryimages').child('${DateTime.now()}.jpg');
      await ref.putFile(new File(filepath));
        var imageUrl = await ref.getDownloadURL();

      final productRef = FirebaseFirestore.instance
          .collection('categories').doc(id);
      await productRef.set({
        'name': userController.text,
        // Set the ID of the product as a field in the document
        'image_path': imageUrl,


      }).then((value) {

        ResponsiveInfo.showAlertDialog(
            context, "", "Category Edited Successfully");
        userController.clear();
        setState(() {
          filepath = "";
        });
      });
    }
    else{

      final productRef = FirebaseFirestore.instance
          .collection('categories').doc(id);
      await productRef.set({
        'name': userController.text,
        // Set the ID of the product as a field in the document
        'image_path': netimagepath,


      }).then((value) {

        ResponsiveInfo.showAlertDialog(
            context, "", "Category Edited Successfully");
        userController.clear();
        setState(() {
          filepath = "";
        });
      });




    }



    }
    else{

      ResponsiveInfo.showAlertDialog(
          context, "", "Enter Category name");
    }



                  }

                },
              ),
            ),
          ),

        ],
      ),

    );
  }


  getProductDetails()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection(
        'categories').doc(id).get();

    var m = productSnapshot.data()!;

    String name = m['name'] ?? '';
    String path = m['image_path'] ?? '';

    setState(() {

      netimagepath=path.trim();
      userController.text=name;

    });

  }
}
