import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/ui/admin/add_product_price_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../designs/ResponsiveInfo.dart';
import '../../domain/CategoryData.dart';

class AddProductBasicDetails extends StatefulWidget {
   AddProductBasicDetails() ;

  @override
  _AddProductBasicDetailsState createState() => _AddProductBasicDetailsState();
}

List<String> hsnCodes = [
  '9100',
  '9619',
  '1513',
  '3401',
  '1701',
  '1903',
  '3306',
  '2106',
  '0905',
  '1513',
  '2001',
  '2508',
  '3304',
  //  HSN codes
];

class _AddProductBasicDetailsState extends State<AddProductBasicDetails> {

  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();

  String _selectedHsnCode = hsnCodes.first;

  List<String>categories=[];
  List<CategoryData>categoriesobj=[];

  String selectcategory="Select Category";
  CategoryData selected_categoryobj=new CategoryData("0","", "");

  String productId="0";

  bool _manualHsnCodeEntry = false;

  List<File?>fileimages=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryList();
  }


  getCategoryList()async{
    final productSnapshot = await FirebaseFirestore.instance.collection('categories').get();

    String id="";
    categories.clear();
    categoriesobj.clear();
    categories.add(selectcategory);
    categoriesobj.add(new CategoryData("0", selectcategory, ""));

    productSnapshot.docs.forEach((element) {

      id=element.id;
      var m=element.data();
      print (m);

      setState(() {
        categories.add(m['name']);
        categoriesobj.add(new CategoryData(id, m['name'], m['image_path']));

      });



    });


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text('Add Product\'s basic details',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.white),),
      ),
      body: SingleChildScrollView(

        child:



      Stack(

        children: [

          Align(
            alignment: FractionalOffset.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Expanded(child: Text('Product Images',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.black),),
                  flex: 2,
                ),
                Expanded(child: TextButton(

                  child: Text('Add new',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.blue),),
                  onPressed: ()async{
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {

                        fileimages.add(File(pickedFile.path))

                         ;
                      });
                    }

                  },
                ),




                  flex: 1,
                ),


              ],
            )


          ),

          Align(
            child: Padding(
              padding: EdgeInsets.fromLTRB(ResponsiveInfo.isMobile(context)?10 : 20, ResponsiveInfo.isMobile(context)?90:110, ResponsiveInfo.isMobile(context)?10:20, 0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [

                  (fileimages.length>0)?Container(
                    width: double.infinity,
                    height: ResponsiveInfo.isMobile(context)?150 : 200,


                    child: Padding(

                      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: fileimages.length,
                        itemBuilder: (BuildContext context, int index) => Center(
                            child: Card(

                              child: Column(

                                children: [

                                  Expanded(child:

                                  Padding(

                                    padding: EdgeInsets.all(3),
                                    child: Center(child: Image.file(fileimages[index]!,width: ResponsiveInfo.isMobile(context)?70:100,height: ResponsiveInfo.isMobile(context)?70:100,fit: BoxFit.fill,),
                                    ) ,
                                  ),flex: 2, ),

                                  Expanded(child:

                                  Padding(

                                    padding: EdgeInsets.all(2),
                                    child: TextButton(onPressed: () {

                                      setState(() {

                                        fileimages.removeAt(index);

                                      });
                                    },
                                    child:Text("Remove",style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:15,color: Colors.blue),) ,) ,
                                  ),flex: 1,)


                                ],
                              )


                              ,
                            )),
                      ),



                    )):Container()
                ,




                  TextFormField(
                    controller: _itemNameController, // Use combined controller for item and description
                    decoration: InputDecoration(labelText: 'Name'),
                    maxLines: 1,// Update label
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _itemDescriptionController, // Use combined controller for item and description
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 5,// Update label
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),






                  Padding(padding: EdgeInsets.all(10),

                    child: DropdownButton<String>(
                      value: selectcategory,
                      onChanged: (value) {
                        setState(() {

                          selectcategory = value!;
                          productId="";
                          for(int i=0;i<categoriesobj.length;i++)
                          {
                            if(categoriesobj[i].name.compareTo(selectcategory)==0)
                            {
                              selected_categoryobj=categoriesobj[i];
                              break;
                            }


                          }


                        });
                      },
                      items: categories.map((String hsnCode) {
                        return DropdownMenuItem<String>(
                          value: hsnCode,
                          child: Text(hsnCode),
                        );
                      }).toList(),
                      disabledHint: Text('Select category'),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Checkbox(
                        value: _manualHsnCodeEntry,
                        onChanged: (value) {
                          setState(() {
                            _manualHsnCodeEntry = value!;
                          });
                        },
                      ),


                      Text('Manual Entry HSN/SAC'),
                      SizedBox(width: 10),
                      Expanded(
                        child: _manualHsnCodeEntry
                            ? TextFormField(
                          controller: _hsnCodeController,
                          decoration: InputDecoration(labelText: 'HSN Code'),
                          validator: (value) {
                            if (_manualHsnCodeEntry && value!.isEmpty) {
                              return 'Please enter an HSN/SAC';
                            }
                            return null;
                          },
                        )
                            : DropdownButton<String>(
                          value: _selectedHsnCode,
                          onChanged: (value) {
                            setState(() {
                              _manualHsnCodeEntry = false;
                              _selectedHsnCode = value!;
                            });
                          },
                          items: hsnCodes.map((String hsnCode) {
                            return DropdownMenuItem<String>(
                              value: hsnCode,
                              child: Text(hsnCode),
                            );
                          }).toList(),
                          disabledHint: Text('Select an HSN/SAC'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Stack(

                    children: [

                      Align(
                        alignment: FractionalOffset.center,
                        child:     ElevatedButton(
                          onPressed: () async {

                            if(fileimages.length>0)
                              {
                                if(_itemNameController.text.isNotEmpty)
                                {
                                  if(_itemDescriptionController.text.isNotEmpty)
                                  {

                                  if (selected_categoryobj.id.compareTo("0") != 0) {
                                  String hsn="";
                                  if(_manualHsnCodeEntry)
                                  {
                                  hsn=_hsnCodeController.text;
                                  }
                                  else{

                                  hsn=_selectedHsnCode;
                                  }

                                  if(hsn.isNotEmpty) {


                                    List<String>uploadedimages=[];


                                    for(int i=0;i<fileimages.length;i++)
                                      {
                                        showLoaderDialog(context);
                                        File? fimg=fileimages[i];

                                        final ref = FirebaseStorage.instance.ref()
                                            .child('product_images')
                                            .child('${DateTime.now()}.jpg');
                                        await ref.putFile(fimg!);
                                        final imageUrl = await ref.getDownloadURL();

                                        uploadedimages.add(imageUrl);
                                        Navigator.pop(context);
                                      }

                                    String imagestring="";

                                  for(int i=0;i<uploadedimages.length;i++)
                                  {
                                    if(i==0)
                                      {
                                        imagestring=uploadedimages[i];
                                      }
                                    else{
                                      imagestring=imagestring+","+uploadedimages[i];
                                    }
                                  }

                                  showLoaderDialog(context);

                                 var   productRef = FirebaseFirestore.instance.collection(
                                        'product_master')
                                        .doc();
                                    productId = productRef.id;


                                     productRef.set({
                                      // 'id': productId, // Set the ID of the product as a field in the document
                                      'name': _itemNameController.text,
                                      'image': imagestring,
                                      'description': _itemDescriptionController.text,
                                      'hsnCode': _manualHsnCodeEntry
                                          ? _hsnCodeController.text
                                          : _selectedHsnCode,
                                      'category': selected_categoryobj.id

                                    }).then((value) {


                                      Navigator.pop(context);


                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddProductPriceDetails(productId,"0")),
                                      );
                                      // Navigator.pop(context);
                                     });









                                  }
                                  else{

                                    ResponsiveInfo.showAlertDialog(context, "Add Product", "Please select or enter hsn code");
                                  }


                                    }
                                    else{

                                      ResponsiveInfo.showAlertDialog(context, "Add Product", "Please select category");
                                    }



                                  }
                                  else{

                                    ResponsiveInfo.showAlertDialog(context, "Add Product", "Please enter description");
                                  }

                                }
                                else{

                                  ResponsiveInfo.showAlertDialog(context, "Add Product", "Please enter name");
                                }

                              }
                            else{

                              ResponsiveInfo.showAlertDialog(context, "Add Product", "Please add atleast one image");
                            }





                          },
                          child: Text('Add Product'),
                        ),
                      )
                    ],
                  )




                ],
              ),
            ),
          )



















        ],


      ),

      )

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
