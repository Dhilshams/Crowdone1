import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'package:ecommerce/ui/admin/add_category.dart';

class CategoryPage extends StatefulWidget {
   CategoryPage() ;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryList();

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
        title: Text("Category List",style: TextStyle(color: Colors.white,fontSize: 12),),
        centerTitle: false,
        actions: [

          Padding(padding: EdgeInsets.all(15),

          child: GestureDetector(
            child: Icon(Icons.add,color: Colors.white,size: ResponsiveInfo.isMobile(context)?20:30),

            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory("")));

            },

          ),
          )




        ],


      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
              String path = data['image_path'] ?? '';

list.add(new CategoryData(id,name,path));



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
                          leading: Image.network(list[index].imagepath,width: 50,height: 50,fit: BoxFit.fill),
                          trailing: TextButton(

                            child:Text(
                              "Edit",
                              style: TextStyle(color: Colors.green, fontSize: 15),
                            ) ,
                            onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory(list[index].id)));


                              // Widget okButton = TextButton(
                              //   child: Text("yes"),
                              //   onPressed: () {
                              //
                              //   FirebaseFirestore.instance.collection('categories').doc(list[index].id).delete();
                              //
                              //   setState(() {
                              //
                              //     list.removeAt(index);
                              //   });
                              //
                              //   Navigator.pop(context);
                              //
                              //
                              //
                              //
                              //
                              //
                              //   },
                              // );
                              //
                              // Widget okButton1 = TextButton(
                              //   child: Text("no"),
                              //   onPressed: () { },
                              // );
                              //
                              // // set up the AlertDialog
                              // AlertDialog alert = AlertDialog(
                              //   title: Text("Delete Category"),
                              //   content: Text("Do you want to delete category ?"),
                              //   actions: [
                              //     okButton,
                              //     okButton1
                              //   ],
                              // );
                              //
                              // // show the dialog
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return alert;
                              //   },
                              // );


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



  getCategoryList()async
  {




  }
}
