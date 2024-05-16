import 'dart:io';
import 'package:ecommerce/ui/admin/add_product_basic_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CountryData.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.black),),
      ),
      body: ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductBasicDetails()),
          );
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl = product['image'] as String;
            final name = product['name_description'] as String;
            final price = product['price'] as double;
            final productId = product.id;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullImageScreen(imageUrl: imageUrl)),
                );
              },
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '\$$price',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.yellow,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProductPage(productId: productId)),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('products').doc(productId).delete();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
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
class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String _selectedHsnCode = hsnCodes.first;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController(); // Combine controller for item and description
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _extraInput1Controller = TextEditingController();
  final TextEditingController _extraInput2Controller = TextEditingController();


  final TextEditingController gstcontroller = TextEditingController();
  final TextEditingController taxcontroller = TextEditingController();

  final TextEditingController stockcontroller = TextEditingController();
  final TextEditingController ratecontroller = TextEditingController();
  final TextEditingController discountcontroller = TextEditingController();
  final TextEditingController amountcontroller = TextEditingController();


  File? _image;
List<String>categories=[];
  List<CategoryData>categoriesobj=[];

  String selectcategory="Select Category";



  List<String>units=[];
  List<CategoryData>unitobjs=[];

  String selectunit="Select unit";
  CategoryData selected_categoryobj=new CategoryData("0","", "");


CategoryData unitobjs_selected=new CategoryData("0","", "");

String productId="0";

List<CountryData>countrylist=[];
  CountryData selectedCountry=new CountryData("", "", "","","");
  List<String>countrylistdata=[];
  bool _manualGSTentry = false;

  bool _GSTEnable = false;

  String selectcountry="Select Country";

  bool othertax=false;
  bool  othertaxEnable=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryList();
    getUnitList();
    getCountryList();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("Add Product",style: TextStyle(color: Colors.white,fontSize: 12),),
        centerTitle: false,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 (_image != null) ?
                  Container(
                    height: 150,
                    width: double.infinity, // Adjust width as needed
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ) :      Container(
              height: 150,
              width: double.infinity, // Adjust width as needed
              child: Icon(Icons.image,color: Colors.black26,size:120),
            ),
                  SizedBox(height: 30),


                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Add Image'),
                ),

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
                )
                ,
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

                Padding(padding: EdgeInsets.all(10),

                    child: Text("Add Product variant details",style: TextStyle(color: Colors.black,fontSize: 15),)

                ),

                SizedBox(height: 20),

                Padding(padding: EdgeInsets.all(10),

                child: DropdownButton<String>(
                  value: selectcountry,
                  onChanged: (value) {
                    setState(() {

                      selectcountry = value!;
                    });

                    othertaxEnable =false;
                    othertax=false;

                    _manualGSTentry=false;
                    _GSTEnable=false;

                    for(int i=0;i<countrylist.length;i++)
                    {
                      if(selectcountry.compareTo(countrylist[i].name)==0) {

                        selectedCountry=countrylist[i];
                        if (countrylist[i].code.contains("91")) {
                          _manualGSTentry = false;
                          _GSTEnable = true;

                          break;
                        }
                      }
                    }
                    setState(() {
                      if(!_GSTEnable)
                        {
                          othertaxEnable =true;
                          othertax=false;
                        }
                    });
                  },
                  items: countrylistdata.map((String c) {
                    return DropdownMenuItem<String>(
                      value: c,
                      child: Text(c),
                    );
                  }).toList(),
                  disabledHint: Text('Select country'),
                ),

                ),




                TextFormField(
                  controller: stockcontroller,
                  decoration: InputDecoration(labelText: 'Stock'),
                  // keyboardType: TextInputType.number,
                  validator: (value) {
                    // Validation logic for Category field
                    return null; // Return null if the input is valid
                  },
                ),
                TextFormField(
                  controller: ratecontroller,
                  decoration: InputDecoration(labelText: 'Rate'),
                  keyboardType: TextInputType.number,
          onChanged: (txt)
                  {
                    double a =0;
                    if(txt.toString().isNotEmpty) {
                      double a = double.parse(txt.toString());

                      if(_GSTEnable)
                        {
                          if(_manualGSTentry)
                            {

                              String gst_text=gstcontroller.text;
                              double t=double.parse(gst_text);
                              double gstpercent_amount=a*(t/100);
                              a=a+gstpercent_amount;
                              setState(() {
                                amountcontroller.text=a.toString();
                              });

                            }


                        }
                      else if(othertaxEnable)
                        {
                          if(othertax)
                          {

                            String gst_text=taxcontroller.text;
                            double t=double.parse(gst_text);
                            double gstpercent_amount=a*(t/100);
                            a=a+gstpercent_amount;
                            setState(() {
                              amountcontroller.text=a.toString();
                            });



                          }



                        }
                      else{

                        amountcontroller.text=a.toString();
                      }


                    }
                    else{

                      setState(() {
                        amountcontroller.text=a.toString();
                      });


                    }


                  },
                ),
                (_GSTEnable)?  Row(
                  children: [
                    Checkbox(
                      value: _manualGSTentry,
                      onChanged: (value) {
                        setState(() {
                          _manualGSTentry = value!;
                        });
                      },
                    ),


                    Text('GST'),
                    SizedBox(width: 10),
                    Expanded(
                      child: _manualGSTentry
                          ? TextFormField(
                        controller: gstcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'GST %'),
                        onChanged: (txt)
                        {

                          double a =0;
                          if(txt.toString().isNotEmpty) {
                            double a = double.parse(ratecontroller.text.toString());

                            if(_GSTEnable)
                            {
                              if(_manualGSTentry)
                              {

                                String gst_text=txt.toString();
                                double t=double.parse(gst_text);
                                double gstpercent_amount=a*(t/100);
                                a=a+gstpercent_amount;
                                setState(() {
                                  amountcontroller.text=a.toString();
                                });

                              }
                              else{

                                amountcontroller.text=a.toString();
                              }


                            }

                            else{

                              amountcontroller.text=a.toString();
                            }


                          }
                          else{

                            amountcontroller.text=a.toString();
                          }

                        },
                      )
                          : Container(),
                    ),
                  ],
                ) : Container(),

                (othertaxEnable)?  Row(
                  children: [
                    Checkbox(
                      value: othertax,
                      onChanged: (value) {
                        setState(() {
                          othertax = value!;
                        });
                      },
                    ),


                    Text('TAX'),
                    SizedBox(width: 10),
                    Expanded(
                      child: othertax
                          ? TextFormField(
                        controller: taxcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'TAX %'),
                        onChanged: (txt){
                          double a = 0;
                          if(txt.isNotEmpty) {
                            double a = double.parse(
                                ratecontroller.text.toString());
                            if (othertaxEnable) {
                              if (othertax) {
                                String gst_text = txt.toString();
                                double t = double.parse(gst_text);
                                double gstpercent_amount = a * (t / 100);
                                a = a + gstpercent_amount;
                                setState(() {
                                  amountcontroller.text = a.toString();
                                });
                              }
                            }
                          }
                          else{



                          amountcontroller.text=a.toString();

                          }

                        },
                      )
                          : Container(),
                    ),
                  ],
                ) : Container(),



                // TextFormField(
                //   controller: discountcontroller,
                //   decoration: InputDecoration(labelText: 'Discount'),
                //   // keyboardType: TextInputType.number,
                //   validator: (value) {
                //     // Validation logic for Extra Input 1 field
                //     return null; // Return null if the input is valid
                //   },
                // ),
                TextFormField(
                  controller: amountcontroller,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Validation logic for Extra Input 2 field
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),



                Padding(padding: EdgeInsets.all(10),

                  child: DropdownButton<String>(
                    value: selectunit,
                    onChanged: (value) {
                      setState(() {


                        selectunit = value!;

                        for(int i=0;i<unitobjs.length;i++)
                          {
                            if(unitobjs[i].name.compareTo(selectunit)==0)
                              {
                                unitobjs_selected=unitobjs[i];
                                break;

                              }



                          }




                      });
                    },
                    items: units.map((String hsnCode) {
                      return DropdownMenuItem<String>(
                        value: hsnCode,
                        child: Text(hsnCode),
                      );
                    }).toList(),
                    disabledHint: Text('Select unit'),
                  )

                )
                ,




                SizedBox(height: 20),

                Stack(
                  children: [

                    Align(
                      alignment: FractionalOffset.center,
                      child: Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?18:25),

                        child:  ElevatedButton(
                          onPressed: _addProduct,
                          child: Text('Add Product'),
                        ),

                      )
                      ,
                    )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  getCountryList() async {
    final productSnapshot1 = await FirebaseFirestore.instance.collection(
        'countryList').get();

    List<dynamic>c = productSnapshot1.docs.toList();
    bool a = false;
    countrylist.clear();

    countrylist.add(new CountryData("", "", "","",""));
    countrylistdata.add(selectcountry);

    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;


      String name = m['name'];
      String code = m['countrycode'];
      String conversionfactor=m['ConversionFactor'];
      String currency_symbol="";

      if(m.containsKey("currency_symbol"))
        {
          currency_symbol=m['currency_symbol'];
        }


      String id = ab.id;

      CountryData data = new CountryData(id, name, code,conversionfactor,currency_symbol);

      setState(() {
        countrylistdata.add(name);

        countrylist.add(data);
      });
    }


    // countryList
  }





  bool _manualHsnCodeEntry = false;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addProduct() async {

    if(_image!=null) {
      if(_itemNameController.text.isNotEmpty) {
        if(_itemDescriptionController.text.isNotEmpty) {
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

              if(selectedCountry.name.isNotEmpty) {

                if(stockcontroller.text.isNotEmpty) {
                  if(ratecontroller.text.isNotEmpty) {
                  try {
                    final ref = FirebaseStorage.instance.ref()
                        .child('product_images')
                        .child('${DateTime.now()}.jpg');
                    await ref.putFile(_image!);
                    final imageUrl = await ref.getDownloadURL();

                    var productRef;

                    if (productId.isEmpty) {
                      productRef = FirebaseFirestore.instance.collection(
                          'product_master')
                          .doc();
                      productId = productRef.id;
                    }
                    else {
                      productRef = FirebaseFirestore.instance.collection(
                          'product_master')
                          .doc(productId);
                    }

                    // Generate a new document reference without specifying an ID

                    print(productId); // Get the automatically generated ID
                    await productRef.set({
                      // 'id': productId, // Set the ID of the product as a field in the document
                      'name': _itemNameController.text,
                      'image': imageUrl,
                      'description': _itemDescriptionController.text,
                      'hsnCode': _manualHsnCodeEntry
                          ? _hsnCodeController.text
                          : _selectedHsnCode,
                      'category': selected_categoryobj.id

                    });

                    final productRef1 = FirebaseFirestore.instance.collection(
                        'products')
                        .doc();

                    await productRef1.set({
                      'id': productId,
                      // Set the ID of the product as a field in the document

                      'price': ratecontroller.text,
                      'hsnCode': _manualHsnCodeEntry
                          ? _hsnCodeController.text
                          : _selectedHsnCode,
                      'country_id':selectedCountry.id,
                      'Tax':taxcontroller.text,
                      'GST':gstcontroller.text,
                      'Qty': stockcontroller.text,
                      'units': unitobjs_selected.id,
                      'Discount': "0.00",
                      'Amount': amountcontroller.text,
                    });


                    _priceController.clear();
                    // _hsnCodeController.clear();
                    _categoryController.clear();
                    _extraInput1Controller.clear();
                    _extraInput2Controller.clear();

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //         'One Product variant added successfully.Enter details to add another'),
                    //   ),
                    // );


                    ResponsiveInfo.showAlertDialog(context, "", "One Product variant added successfully.Enter details to add another");



                  } catch (error) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Failed to add product: $error'),
                    //   ),
                    // );

                    ResponsiveInfo.showAlertDialog(context, "", "Failed to add product");



                  }

                  }
                  else{

                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text('Please enter rate'),
                    //   duration: Duration(seconds: 2),
                    // ));

                    ResponsiveInfo.showAlertDialog(context, "", "Please enter rate");


                  }


                }
                else{

                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('Please enter stock'),
                  //   duration: Duration(seconds: 2),
                  // ));

                  ResponsiveInfo.showAlertDialog(context, "", "Please enter stock");


                }


              }
              else{

                //
                // .of(context).showSnackBar(SnackBar(
                //   content: Text('Please select country'),
                //   duration: Duration(seconds: 2),
                // ));

                ResponsiveInfo.showAlertDialog(context, "", "Please select country");



              }
            }
            else{
              ResponsiveInfo.showAlertDialog(context, "", "Please enter or select hsn code");
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('Please enter or select hsn code'),
              //   duration: Duration(seconds: 2),
              // ));

            }

          }
          else {
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('Select Category'),
            //   duration: Duration(seconds: 2),
            // ));

            ResponsiveInfo.showAlertDialog(context, "", "Select Category");



          }
        }
        else{
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Enter Description'),
          //   duration: Duration(seconds: 2),
          // ));


          ResponsiveInfo.showAlertDialog(context, "", "Enter Description");


        }
      }
      else{

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Enter name'),
        //   duration: Duration(seconds: 2),
        // ));


        ResponsiveInfo.showAlertDialog(context, "", "Enter name");

      }
    }
    else{
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Select Product Image'),
      //   duration: Duration(seconds: 2),
      // ));

      ResponsiveInfo.showAlertDialog(context, "", "Select Product Image");


    }
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

  getUnitList()async{
    final productSnapshot = await FirebaseFirestore.instance.collection('units').get();

    String id="";
    units.clear();
    unitobjs.clear();
    units.add(selectunit);
    unitobjs.add(new CategoryData("0", selectunit, ""));

    productSnapshot.docs.forEach((element) {

      id=element.id;
      var m=element.data();
      print (m);
      setState(() {
        units.add(m['name']);
        unitobjs.add(new CategoryData(id, m['name'], ""));

      });



    });


  }

}






class EditProductPage extends StatefulWidget {
  final String productId;

  EditProductPage({required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemDescriptionController = TextEditingController(); // Combined controller for item and description
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _hsnCodeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _extraInput1Controller = TextEditingController();
  final TextEditingController _extraInput2Controller = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final productSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();
      if (productSnapshot.exists) {
        final productData = productSnapshot.data() as Map<String, dynamic>;
        final nameDescription = productData['name_description'] ?? ''; // Get combined field
        _itemDescriptionController.text = nameDescription;
        _priceController.text = productData['price']?.toString() ?? '';
        _hsnCodeController.text = productData['hsnCode'] ?? '';
        _categoryController.text = productData['Qty'] ?? '';
        _extraInput1Controller.text = productData['Discount'] ?? '';
        _extraInput2Controller.text = productData['Amount'] ?? '';
        setState(() {});
      } else {
        // Handle case where document doesn't exist


        ResponsiveInfo.showAlertDialog(context, "", "Product not found");


      }
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Failed to fetch product details: $error'),
      //   ),
      // );

      ResponsiveInfo.showAlertDialog(context, "", "Failed to fetch product details");

    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _editProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imageUrl = '';
        if (_image != null) {
          final ref = FirebaseStorage.instance.ref().child('product_images').child('${DateTime.now()}.jpg');
          await ref.putFile(_image!);
          imageUrl = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance.collection('products').doc(widget.productId).update({
          'name_description': _itemDescriptionController.text, // Update combined field
          'price': double.parse(_priceController.text),
          'hsnCode': _hsnCodeController.text,
          'category': _categoryController.text,
          'extraInput1': _extraInput1Controller.text,
          'extraInput2': _extraInput2Controller.text,
          if (imageUrl.isNotEmpty) 'image': imageUrl,
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Product updated successfully'),
        //   ),
        // );


        ResponsiveInfo.showAlertDialog(context, "", "Product updated successfully");



      } catch (error) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to update product: $error'),
        //   ),
        // );


        ResponsiveInfo.showAlertDialog(context, "", "Failed to update product");



      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_image != null) ...[
                  Container(
                    height: 80,
                    width: double.infinity, // Adjust width as needed
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Change Image'),
                ),
                TextFormField(
                  controller: _itemDescriptionController, // Use combined controller for item and description
                  decoration: InputDecoration(labelText: 'Item & Description'), // Update label
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter item and description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hsnCodeController,
                  decoration: InputDecoration(labelText: 'HSN Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter HSN code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Qty'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Validation logic for Qty field
                    return null; // Return null if the input is valid
                  },
                ),
                TextFormField(
                  controller: _extraInput1Controller,
                  decoration: InputDecoration(labelText: 'Discount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Validation logic for Discount field
                    return null; // Return null if the input is valid
                  },
                ),
                TextFormField(
                  controller: _extraInput2Controller,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Validation logic for Amount field
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editProduct,
                  child: Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}












class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  FullImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}