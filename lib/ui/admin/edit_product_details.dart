import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/ui/admin/product_price_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../designs/ResponsiveInfo.dart';
import '../../domain/CategoryData.dart';
import '../../domain/ProductVariants.dart';
import 'add_product_price_details.dart';

class EditProductDetails extends StatefulWidget {

  String productid;

   EditProductDetails(this.productid) ;

  @override
  _EditProductDetailsState createState() => _EditProductDetailsState(this.productid);
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

class _EditProductDetailsState extends State<EditProductDetails> {

  String productid;

  String image="",name="",description="",category="";

  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();

  List<String>fileimages=[];
  final TextEditingController _hsnCodeController = TextEditingController();


  String _selectedHsnCode = hsnCodes.first;

  List<String>categories=[];
  List<CategoryData>categoriesobj=[];

  String selectcategory="Select Category";
  CategoryData selected_categoryobj=new CategoryData("0","", "");

  bool _manualHsnCodeEntry=false;

  _EditProductDetailsState(this.productid);

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

    getProductDetails();

    // for(int j=0;j<categoriesobj.length;j++)
    //   {
    //     if(categoriesobj[j].id.compareTo(category)==0)
    //       {
    //         selected_categoryobj=categoriesobj[j];
    //         break;
    //       }
    //   }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      title: Text('Edit Product',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.white),),

        actions: [

          Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),

            child: TextButton(

              onPressed: () {

                 // showProductpriceDetails();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPriceDetails(productid)),
                );



              },
              child: Text("Price Details",style: TextStyle(color: Colors.white,fontSize: ResponsiveInfo.isMobile(context)?14:17),),
            ),

          )

        ],
    ),

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),


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

                        fileimages.add(pickedFile.path)

                        ;
                      });
                    }

                  },
                ),




                  flex: 1,
                ),


              ],
            ),

            ),

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
                                child: Center(child: (!fileimages[index].contains("https"))? Image.file(File(fileimages[index]),width: ResponsiveInfo.isMobile(context)?70:100,height: ResponsiveInfo.isMobile(context)?70:100,fit: BoxFit.fill,) :

                                Image.network(fileimages[index],width: ResponsiveInfo.isMobile(context)?70:100,height: ResponsiveInfo.isMobile(context)?70:100,fit: BoxFit.fill,)

                                  ,
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



                )):Container(),



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

                                  if(fileimages[i].contains("https"))
                                    {

                                      uploadedimages.add(fileimages[i]);

                                      Navigator.pop(context);
                                    }
                                  else {
                                    File fimg = File(fileimages[i]) ;

                                    final ref = FirebaseStorage.instance.ref()
                                        .child('product_images')
                                        .child('${DateTime.now()}.jpg');
                                    await ref.putFile(fimg);
                                    final imageUrl = await ref.getDownloadURL();

                                    uploadedimages.add(imageUrl);
                                    Navigator.pop(context);
                                  }
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
                                    .doc(productid);



                                productRef.update({
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

                                  ResponsiveInfo.showAlertDialog(context, "Product Details", "Product Details Updated Successfully");



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
        )
        ,
      ),


    );
  }



  getProductDetails()async
  {


    final productSnapshot = await FirebaseFirestore.instance.collection('product_master').doc(productid).get();

 var m=   productSnapshot.data()!;


 setState(() async {

   _itemDescriptionController.text = m['description'];
   image = m['image'];
   String hsn=m['hsnCode'];

   bool a=false;

   for(int i=0;i<hsnCodes.length;i++)
     {
       if(hsn.compareTo(hsnCodes[i])==0)
         {

           a=true;

           setState(() {
             _manualHsnCodeEntry=false;
             _selectedHsnCode=hsn;
           });

           break;
         }
     }

   if(!a)
     {
       setState(() {
         _manualHsnCodeEntry=true;
        _hsnCodeController.text=hsn;
       });
     }


   List<String>imagepaths=image.split(",");

   if(imagepaths.length>0)
     {

       setState(() {
         fileimages.addAll(imagepaths);

       });
     }
   else{
     setState(() {
       fileimages.add(image);

     });

   }

   _itemNameController.text = m['name'];


   category=m['category'];



   final productSnapshot = await FirebaseFirestore.instance.collection('categories').doc(category).get();

   var m1=   productSnapshot.data()!;



setState(() {

  selectcategory=m1['name'];

  for(int i=0;i<categoriesobj.length;i++)
  {
    if(categoriesobj[i].name.compareTo(selectcategory)==0)
    {
      selected_categoryobj=categoriesobj[i];
      break;
    }


  }
});

 });








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

  showProductpriceDetails()async
  {















  }




}


class MyDialog extends StatefulWidget {

  String pid;
  MyDialog(this.pid);


  @override
  _MyDialogState createState() => new _MyDialogState(this.pid);
}

class _MyDialogState extends State<MyDialog> {
  String pid;

  List<Map<String,String>>productdetails=[];
  _MyDialogState(this.pid);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductDetails();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(

        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Stack(

          children: [

            Align(
              alignment: FractionalOffset.topCenter,
              child: ListView.builder(
                  itemCount: productdetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading:  Icon(Icons.price_change,size: ResponsiveInfo.isMobile(context)?20:25,),
                        trailing:  Text(
                          "Edit",
                          style: TextStyle(color: Colors.green, fontSize: ResponsiveInfo.isMobile(context)?  15:17),
                        ),
                        title: Text(productdetails[index]['unit_name'].toString()+"\nInternational Price : "+productdetails[index]['international_actual_price'].toString(),maxLines : 3,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?  13:15),),
                      subtitle:Text("Domestic Price : "+productdetails[index]['actual_amount_domestic'].toString(),maxLines : 3,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?  13:15),),



                    );
                  }),

            )


          ],
        ),

      ),
      actions: <Widget>[

      ],
    );
  }

  getProductDetails()
  async {

    final productSnapshot1 = await FirebaseFirestore.instance.collection('products').get();

    List<dynamic>c=    productSnapshot1.docs.toList();
    bool a=false;



    for(int i=0;i<c.length;i++)
    {

      QueryDocumentSnapshot ab=c[i];

      var m = ab.data() as Map<String,dynamic>;


      String  id1 = m['id'];
      if(id1.compareTo(pid)==0)
      {
        Map<String,String>data=new Map();
        String productid=ab.id;

        String international_actual_price=m['international_actual_price'];
        String actual_amount_domestic=m['actual_amount_domestic'];
        String units=m['units'].toString().trim();



        await FirebaseFirestore.instance.collection('units').doc(units).get().then((value) {
          Map<String,dynamic> m1= value.data()!;
          String units_name=m1['name'];

setState(() {

  data['product_id']=productid;
  data['international_actual_price']=international_actual_price;
  data['actual_amount_domestic']=actual_amount_domestic;
  data['units_name']=units_name;

  productdetails.add(data);


});
        });



      }

    }

  }




}



