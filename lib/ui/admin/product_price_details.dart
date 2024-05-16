import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../designs/ResponsiveInfo.dart';
import 'add_product_price_details.dart';

class ProductPriceDetails extends StatefulWidget {

  String productid;
   ProductPriceDetails(this.productid) ;

  @override
  _ProductPriceDetailsState createState() => _ProductPriceDetailsState(this.productid);
}

class _ProductPriceDetailsState extends State<ProductPriceDetails> {

  String productid;

  List<Map<String,String>>productdetails=[];

  _ProductPriceDetailsState(this.productid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text('Product Price Details', style: TextStyle(
            fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14,
            color: Colors.white),),

        actions: [

          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),

            child: TextButton(

              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPriceDetails(productid,"0")),
                );

              },
              child: Text("Add Price Details", style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveInfo.isMobile(context) ? 14 : 17),),
            ),

          )

        ],
      ),

      body: Stack(
        children: [

          Align(
            alignment: FractionalOffset.topCenter,
            child: ListView.builder(
                itemCount: productdetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(

                    child:ListTile(
                      leading:  Icon(Icons.price_change,size: ResponsiveInfo.isMobile(context)?20:25,),
                      trailing:  TextButton(

                        onPressed: () {

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AddProductPriceDetails(productid,productdetails[index]['product_id']!)),
                          );


                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.green, fontSize: ResponsiveInfo.isMobile(context)?  15:17),
                        ),

                      )

                      ,
                      title: Text(productdetails[index]['units_name'].toString()+"\nInternational Price : "+productdetails[index]['international_actual_price'].toString(),maxLines : 3,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?  13:15),),
                      subtitle:Text("Domestic Price : "+productdetails[index]['actual_amount_domestic'].toString(),maxLines : 3,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?  13:15),),



                    ) ,
                  )


                    ;
                }),

          )
        ],
      ),


    );
  }

  showProductDetails()
  async {


    final productSnapshot1 = await FirebaseFirestore.instance.collection('products').get();

    List<dynamic>c=    productSnapshot1.docs.toList();
    bool a=false;



    for(int i=0;i<c.length;i++)
    {

      QueryDocumentSnapshot ab=c[i];

      var m = ab.data() as Map<String,dynamic>;


      String  id1 = m['id'];
      if(id1.compareTo(productid)==0)
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
