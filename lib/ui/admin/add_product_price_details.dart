import 'package:flutter/material.dart';

import '../../designs/ResponsiveInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../domain/CategoryData.dart';

class AddProductPriceDetails extends StatefulWidget {

  String productid;
  String productvariantid;


   AddProductPriceDetails(this.productid,this.productvariantid) ;

  @override
  _AddProductPriceDetailsState createState() => _AddProductPriceDetailsState(this.productid,this.productvariantid);
}

class _AddProductPriceDetailsState extends State<AddProductPriceDetails> {

  String productid;

  String productvariantid;
  String selectunit="Select unit";
  List<String>units=[];
  List<CategoryData>unitobjs=[];
  CategoryData unitobjs_selected=new CategoryData("0","", "");
  _AddProductPriceDetailsState(this.productid,this.productvariantid);
  TextEditingController domesticamountcontroller=new TextEditingController();
  TextEditingController domesticgst=new TextEditingController();
  TextEditingController offercontroller=new TextEditingController();

  TextEditingController actualpricecontroller=new TextEditingController();

  TextEditingController stockcontroller=new TextEditingController();

  TextEditingController minimumorderqtycontroller=new TextEditingController();



  TextEditingController international_amountcontroller=new TextEditingController();
  TextEditingController international_gst=new TextEditingController();
  TextEditingController international_offercontroller=new TextEditingController();

  TextEditingController international_actualpricecontroller=new TextEditingController();




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

getProductPriceDetails();
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUnitList();
  }

  getProductPriceDetails()
  async {

    final productSnapshot1 = await FirebaseFirestore.instance.collection('products').doc(productvariantid).get();

  Map m=  productSnapshot1.data()!;

  setState(() async {

    stockcontroller.text = m['Qty'];
    actualpricecontroller.text = m['actual_amount_domestic'];
    domesticgst.text = m['domestic_gst'];
    offercontroller.text = m['domestic_offer'];
    domesticamountcontroller.text = m['domestic_price'];
    international_actualpricecontroller.text = m['international_actual_price'];
    international_offercontroller.text = m['international_offer'];
    international_amountcontroller.text = m['international_price'];
    international_gst.text = m['international_tax'];
    minimumorderqtycontroller.text = m['minimum_orderQty'];

    String units = m['units'].toString().trim();

    await FirebaseFirestore.instance.collection('units').doc(units).get().then((value) {
      Map<String,dynamic> m1= value.data()!;
      String units_name=m1['name'];

      setState(() {
        selectunit=units_name;
      });

      for(int i=0;i<unitobjs.length;i++)
      {
        if(unitobjs[i].name.compareTo(selectunit)==0)
        {
          unitobjs_selected=unitobjs[i];
          break;

        }



      }


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
        title: Text((productvariantid.compareTo("0")==0)?'Add Product\'s price details' : 'Edit Product\'s price details',style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14,color: Colors.white),),
      ),

      body: SingleChildScrollView(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: stockcontroller,
                decoration: InputDecoration(labelText: 'Stock Qty'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),



            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: minimumorderqtycontroller,
                decoration: InputDecoration(labelText: 'Minimum Order Qty'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),



            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),

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
              ),


            ),

            Padding(padding: EdgeInsets.all(10),

                child: Text("Domestic price details",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)

            ),




            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: domesticamountcontroller,
                decoration: InputDecoration(labelText: 'Amount (exclusive tax)'),
                keyboardType: TextInputType.number,
                onChanged: (txt){

                  String a=txt.toString();
                  if(a.isNotEmpty)
                    {

                      double amount=double.parse(a);
                      double actualprice=0;
                      actualprice=amount;

                      String gst=domesticgst.text;
                      String offerpercent=offercontroller.text;
                      if(gst.isNotEmpty)
                        {
                          double g=double.parse(gst);
                          double t=actualprice*(g/100);
                          actualprice=amount+t;
                        }
                     if(offerpercent.isNotEmpty)
                       {
                         double o=double.parse(offerpercent);
                         double t=actualprice*(o/100);
                         actualprice=actualprice-t;

                       }
                     actualpricecontroller.text=actualprice.toString();


                    }
                  else{

                    setState(() {
                      actualpricecontroller.text="";
                    });


                  }


                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),



            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: domesticgst,
                decoration: InputDecoration(labelText: 'GST % (optional)'),
                keyboardType: TextInputType.number,
                onChanged: (txt){


                  String a=domesticamountcontroller.text;
                  if(a.isNotEmpty)
                  {

                    double amount=double.parse(a);
                    double actualprice=0;
                    actualprice=amount;

                    String gst=domesticgst.text;
                    String offerpercent=offercontroller.text;
                    if(gst.isNotEmpty)
                    {
                      double g=double.parse(gst);
                      double t=actualprice*(g/100);
                      actualprice=amount+t;
                    }
                    if(offerpercent.isNotEmpty)
                    {
                      double o=double.parse(offerpercent);
                      double t=actualprice*(o/100);
                      actualprice=actualprice-t;

                    }
                    actualpricecontroller.text=actualprice.toString();


                  }
                  else{

                    setState(() {
                      actualpricecontroller.text="";
                    });


                  }



                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: offercontroller,
                decoration: InputDecoration(labelText: 'offer percentage'),
                keyboardType: TextInputType.number,
                onChanged: (txt){

                  String a=domesticamountcontroller.text;
                  if(a.isNotEmpty)
                  {

                    double amount=double.parse(a);
                    double actualprice=0;
                    actualprice=amount;

                    String gst=domesticgst.text;
                    String offerpercent=offercontroller.text;
                    if(gst.isNotEmpty)
                    {
                      double g=double.parse(gst);
                      double t=actualprice*(g/100);
                      actualprice=amount+t;
                    }
                    if(offerpercent.isNotEmpty)
                    {
                      double o=double.parse(offerpercent);
                      double t=actualprice*(o/100);
                      actualprice=actualprice-t;

                    }
                    actualpricecontroller.text=actualprice.toString();


                  }
                  else{

                    setState(() {
                      actualpricecontroller.text="";
                    });


                  }
                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: actualpricecontroller,

                decoration: InputDecoration(labelText: 'Actual Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Padding(padding: EdgeInsets.all(10),

                child: Text("International price",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)

            ),


            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: international_amountcontroller,
                decoration: InputDecoration(labelText: 'Amount (exclusive tax)'),
                keyboardType: TextInputType.number,
                onChanged: (txt){

                  String a=international_amountcontroller.text;
                  if(a.isNotEmpty)
                  {

                    double amount=double.parse(a);
                    double actualprice=0;
                    actualprice=amount;

                    String gst=international_gst.text;
                    String offerpercent=international_offercontroller.text;
                    if(gst.isNotEmpty)
                    {
                      double g=double.parse(gst);
                      double t=actualprice*(g/100);
                      actualprice=amount+t;
                    }
                    if(offerpercent.isNotEmpty)
                    {
                      double o=double.parse(offerpercent);
                      double t=actualprice*(o/100);
                      actualprice=actualprice-t;

                    }
                    international_actualpricecontroller.text=actualprice.toString();


                  }
                  else{

                    setState(() {
                      international_actualpricecontroller.text="";
                    });


                  }
                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),



            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: international_gst,
                decoration: InputDecoration(labelText: 'TAX % (optional)'),
                keyboardType: TextInputType.number,
                onChanged: (txt){

                  String a=international_amountcontroller.text;
                  if(a.isNotEmpty)
                  {

                    double amount=double.parse(a);
                    double actualprice=0;
                    actualprice=amount;

                    String gst=international_gst.text;
                    String offerpercent=international_offercontroller.text;
                    if(gst.isNotEmpty)
                    {
                      double g=double.parse(gst);
                      double t=actualprice*(g/100);
                      actualprice=amount+t;
                    }
                    if(offerpercent.isNotEmpty)
                    {
                      double o=double.parse(offerpercent);
                      double t=actualprice*(o/100);
                      actualprice=actualprice-t;

                    }
                    international_actualpricecontroller.text=actualprice.toString();


                  }
                  else{

                    setState(() {
                      international_actualpricecontroller.text="";
                    });


                  }


                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: international_offercontroller,
                onChanged: (txt){
                  String a=international_amountcontroller.text;
                  if(a.isNotEmpty)
                  {

                    double amount=double.parse(a);
                    double actualprice=0;
                    actualprice=amount;

                    String gst=international_gst.text;
                    String offerpercent=international_offercontroller.text;
                    if(gst.isNotEmpty)
                    {
                      double g=double.parse(gst);
                      double t=actualprice*(g/100);
                      actualprice=amount+t;
                    }
                    if(offerpercent.isNotEmpty)
                    {
                      double o=double.parse(offerpercent);
                      double t=actualprice*(o/100);
                      actualprice=actualprice-t;

                    }
                    international_actualpricecontroller.text=actualprice.toString();


                  }
                  else{

                    setState(() {
                      international_actualpricecontroller.text="";
                    });


                  }
                },
                decoration: InputDecoration(labelText: 'offer percentage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
              child:    TextFormField(
                controller: international_actualpricecontroller,
                decoration: InputDecoration(labelText: 'Actual Price'),
                keyboardType: TextInputType.number,
                onChanged: (txt){


                },
                validator: (value) {
                  // Validation logic for Extra Input 2 field
                  return null; // Return null if the input is valid
                },
              ),

            ),

            Stack(
              children: [

                Align(
                  alignment: FractionalOffset.center,
                  child: Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?18:25),

                    child:  ElevatedButton(
                      onPressed: (){
                        if(stockcontroller.text.isNotEmpty)
                        {
                          if(minimumorderqtycontroller.text.isNotEmpty)
                          {
                            if(unitobjs_selected.id.compareTo("0")!=0)
                            {
                              if(domesticamountcontroller.text.isNotEmpty)
                              {
                                if(international_amountcontroller.text.isNotEmpty)
                                {

                                  showLoaderDialog(context);

                                  if(productvariantid.compareTo("0")==0) {
                                    final productRef1 = FirebaseFirestore
                                        .instance.collection(
                                        'products')
                                        .doc();

                                    productRef1.set({
                                      'id': productid,
                                      // Set the ID of the product as a field in the document

                                      'domestic_price': domesticamountcontroller
                                          .text,
                                      'minimum_orderQty': minimumorderqtycontroller
                                          .text,
                                      'domestic_gst': domesticgst.text,
                                      'domestic_offer': offercontroller.text,
                                      'actual_amount_domestic': domesticamountcontroller
                                          .text,
                                      'international_price': international_amountcontroller
                                          .text,
                                      'international_tax': international_gst
                                          .text,
                                      'international_offer': international_offercontroller
                                          .text,
                                      'international_actual_price': international_actualpricecontroller
                                          .text,
                                      'Qty': stockcontroller.text,
                                      'units': unitobjs_selected.id,


                                    }).then((value) {
                                      Navigator.pop(context);
                                      domesticamountcontroller.clear();
                                      minimumorderqtycontroller.clear();
                                      domesticgst.clear();
                                      offercontroller.clear();
                                      actualpricecontroller.clear();
                                      domesticamountcontroller.clear();
                                      international_actualpricecontroller
                                          .clear();
                                      international_amountcontroller.clear();
                                      international_gst.clear();
                                      international_offercontroller.clear();
                                      stockcontroller.clear();

                                      ResponsiveInfo.showAlertDialog(
                                          context, "",
                                          "One Product Unit Details added Successfully.");
                                    });
                                  }
                                  else{


                                    final productRef1 = FirebaseFirestore
                                        .instance.collection(
                                        'products')
                                        .doc(productvariantid);

                                    productRef1.update({
                                      'id': productid,
                                      // Set the ID of the product as a field in the document

                                      'domestic_price': domesticamountcontroller
                                          .text,
                                      'minimum_orderQty': minimumorderqtycontroller
                                          .text,
                                      'domestic_gst': domesticgst.text,
                                      'domestic_offer': offercontroller.text,
                                      'actual_amount_domestic': domesticamountcontroller
                                          .text,
                                      'international_price': international_amountcontroller
                                          .text,
                                      'international_tax': international_gst
                                          .text,
                                      'international_offer': international_offercontroller
                                          .text,
                                      'international_actual_price': international_actualpricecontroller
                                          .text,
                                      'Qty': stockcontroller.text,
                                      'units': unitobjs_selected.id,


                                    }).then((value) {
                                      Navigator.pop(context);
                                      domesticamountcontroller.clear();
                                      minimumorderqtycontroller.clear();
                                      domesticgst.clear();
                                      offercontroller.clear();
                                      actualpricecontroller.clear();
                                      domesticamountcontroller.clear();
                                      international_actualpricecontroller
                                          .clear();
                                      international_amountcontroller.clear();
                                      international_gst.clear();
                                      international_offercontroller.clear();
                                      stockcontroller.clear();

                                      ResponsiveInfo.showAlertDialog(
                                          context, "",
                                          "One Product Unit Details update Successfully.");
                                    });




                                  }


                                }
                                else{

                                  ResponsiveInfo.showAlertDialog(context, "", "Enter International sale amount");
                                }

                              }
                              else{

                                ResponsiveInfo.showAlertDialog(context, "", "Enter Amount");
                              }

                            }
                            else{

                              ResponsiveInfo.showAlertDialog(context, "", "Select Unit");
                            }

                          }
                          else{

                            ResponsiveInfo.showAlertDialog(context, "", "Enter Minimum order Qty");
                          }

                        }
                        else{

                          ResponsiveInfo.showAlertDialog(context, "", "Enter stock qty");
                        }



                      },
                      child: Text((productvariantid.compareTo("0")==0)?'Add Price Details':'Update Price Details'),
                    ),

                  )
                  ,
                )
              ],
            )




          ],


        ),
      ),




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
