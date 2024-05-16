import 'package:ecommerce/ui/admin/add_product_price_details.dart';
import 'package:ecommerce/ui/admin/edit_product_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';
import 'package:ecommerce/ui/admin/Addproductdetailspage.dart';
import 'package:ecommerce/ui/admin/product_details_admin_page.dart';

import 'add_product_basic_details.dart';


class ProductlistPage extends StatefulWidget {
   ProductlistPage() ;

  @override
  _ProductlistPageState createState() => _ProductlistPageState();
}

class _ProductlistPageState extends State<ProductlistPage> {

  List<CategoryData>list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductList();
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
        title: Text(
          "Product List", style: TextStyle(color: Colors.white, fontSize: 12),),
        centerTitle: false,
        actions: [

          Padding(padding: EdgeInsets.all(15),

            child: GestureDetector(
              child: Icon(Icons.add, color: Colors.white,
                  size: ResponsiveInfo.isMobile(context) ? 30 : 35),

              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage()));


                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductBasicDetails()),
                );
              },

            ),
          )


        ],


      ),

      body: Stack(

        children: [

          Align(
            alignment: FractionalOffset.topCenter,
            child: Padding(
              padding: EdgeInsets.all(
                  ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: Container(
                padding: EdgeInsets.all(
                    ResponsiveInfo.isMobile(context) ? 10 : 15),
                width: double.infinity,
                height: ResponsiveInfo.isMobile(context) ? 55 : 65,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(
                        ResponsiveInfo.isMobile(context) ? 10 : 15))),

                // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 50),
                child: Autocomplete(
                  optionsBuilder: (TextEditingValue
                  textEditingValue) async {
                    if (textEditingValue.text == '') {
                      return const Iterable<
                          String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      for (int i = 0; i < list.length; i++) {
                        if (list[i].name.toLowerCase().contains(
                            textEditingValue.text
                                .toLowerCase())) {
                          matches.add(list[i].name);
                        }
                      }


                      return matches;
                    }
                  },
                  fieldViewBuilder: ((context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,

                      onEditingComplete: onFieldSubmitted,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          suffixIcon: Icon(Icons.search,
                              size: ResponsiveInfo.isMobile(context) ? 20 : 24),
                          disabledBorder:
                          InputBorder.none,
                          hintText:
                          'Search Product'),
                    );
                  }),
                  onSelected: (String selection) {
                    print('You just selected $selection');
                    for (int i = 0; i < list.length; i++) {
                      if (selection.compareTo(list[i].name) == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              EditProductDetails(list[i].id,)),
                        );
                        break;
                      }
                    }
                  },
                ),
              ),
            ),
          ),

          Align(
              alignment: FractionalOffset.topCenter,
              child: Padding(padding: EdgeInsets.fromLTRB(
                  0, ResponsiveInfo.isMobile(context) ? 80 : 130, 0, 0),

                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(

                        child: Container(
                            width: double.infinity,
                            height: 250,
                            child: Column(
                              children: [

                                Expanded(child: Image.network(
                                    list[index].imagepath,
                                    width: double.infinity,
                                    height: 190,
                                    fit: BoxFit.fill), flex: 2,)
                                ,
                                Expanded(child: Padding(

                                  child: Row(

                                    children: [

                                      Expanded(child: Text(
                                        list[index].name, style: TextStyle(
                                          color: Colors.black, fontSize: 15),),
                                        flex: 1,),

                                      Expanded(child: Row(

                                        children: [
                                          Padding(padding: EdgeInsets.all(5),
                                            child: TextButton(

                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProductDetails(
                                                            list[index].id,)),
                                                );
                                              },
                                            ),

                                          ),
                                          Padding(padding: EdgeInsets.all(5),
                                            child: TextButton(

                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 15),
                                              ),
                                              onPressed: () {
                                                Widget okButton = TextButton(
                                                  child: Text("yes"),
                                                  onPressed: () async {
                                                    final productSnapshot = await FirebaseFirestore
                                                        .instance.collection(
                                                        'products').get();

                                                    productSnapshot.docs
                                                        .forEach((element) {
                                                      var m = element.data();

                                                      String productmasterid = m['id'];
                                                      if (productmasterid
                                                          .compareTo(
                                                          list[index].id) ==
                                                          0) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            'products')
                                                            .doc(element.id)
                                                            .delete();
                                                      }
                                                    });


                                                    FirebaseFirestore.instance
                                                        .collection(
                                                        'product_master')
                                                        .doc(list[index].id)
                                                        .delete();

                                                    setState(() {
                                                      list.removeAt(index);
                                                    });

                                                    Navigator.pop(context);

                                                    ResponsiveInfo
                                                        .showAlertDialog(
                                                        context, "",
                                                        "Product Deleted Successfully");


                                                    // ScaffoldMessenger.of(context).showSnackBar(
                                                    //   SnackBar(
                                                    //     content: Text('Product Deleted Successfully'),
                                                    //   ),
                                                    // );


                                                  },
                                                );

                                                Widget okButton1 = TextButton(
                                                  child: Text("no"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );

                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("Delete Product"),
                                                  content: Text(
                                                      "Do you want to delete product ?"),
                                                  actions: [
                                                    okButton,
                                                    okButton1
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                      BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                            ),

                                          )

                                        ],
                                      )


                                        , flex: 1,),


                                    ],

                                  ),
                                  padding: EdgeInsets.all(10),
                                )


                                  , flex: 1,)


                              ],

                            )
                        )


                        ,
                        elevation: 8,
                      ),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsAdminPage(list[index].id,"admin")));
                        //

                      },
                    )


                    ;
                  },
                ),

              )


          ),


        ],
      ),


    );
  }


  getProductList() async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection(
        'product_master').get();

    List<dynamic>c = productSnapshot.docs.toList();


    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      String id = ab.id;
      String name = m['name'] ?? '';
      String path = m['image'] ?? '';
      String category = m['category'] ?? '';

      setState(() {
        list.add(new CategoryData(id, name, path));
      });
    }
  }

}