import 'package:flutter/material.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'UserProductView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/domain/CategoryData.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:ecommerce/ui/admin/product_details_admin_page.dart';
import 'package:ecommerce/ui/products_by_category.dart';
import 'package:ecommerce/domain/Products.dart';
import 'package:ecommerce/ui/product_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PreOrders extends StatefulWidget {
  PreOrders();

  @override
  _PreOrdersState createState() => _PreOrdersState();
}

class _PreOrdersState extends State<PreOrders> {


  String currency="";

  List<CategoryData>list=[];

  List<Products>list_products=[];

  List<Map<String,dynamic>>mpoffer=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryList();
    getProductList();
    getProductOfferList();


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f5f9),
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset.topCenter,
            child: SingleChildScrollView(



            child : Column(
              children: [
                Padding(
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
                    child:Autocomplete(
                      optionsBuilder: (TextEditingValue
                      textEditingValue) async {
                        if (textEditingValue.text == '') {
                          return const Iterable<
                              String>.empty();
                        } else {

                          List<String> matches = <String>[];
                          for(int i=0;i<list_products.length;i++)
                            {
                              if(list_products[i].name.toLowerCase().contains(          textEditingValue.text
                                  .toLowerCase()))
                                {

                                  matches.add(list_products[i].name);
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
                        for(int i=0;i<list_products.length;i++)
                        {
                          if(selection.compareTo(list_products[i].name)==0)
                          {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsAdminPage(list_products[i].id,"user")));

                            break;
                          }


                        }

                      },
                    ) ,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: ListTile(

                    title: Text(
                      "Top Categories",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveInfo.isMobile(context) ? 17 : 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Check out our top category list",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ResponsiveInfo.isMobile(context) ? 12 : 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: SizedBox(

                    width: double.infinity,
                    height:  ResponsiveInfo.isMobile(context) ? 130 : 150,

                    child:      ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        list.length,
                            (i) => GestureDetector(

                              child:Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 8 : 12),

                                child: Container(
                                  width: ResponsiveInfo.isMobile(context) ? 100 : 120,
                                  height:ResponsiveInfo.isMobile(context) ? 74 : 90 ,
                                  color: Colors.white,

                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(list[i].imagepath,width:ResponsiveInfo.isMobile(context) ? 65 : 75 ,

                                        height:ResponsiveInfo.isMobile(context) ? 65 : 75 ,fit: BoxFit.fill,
                                      ),
                                      Text(
                                        list[i].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: ResponsiveInfo.isMobile(context)
                                                ? 12
                                                : 14,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 2,
                                      )



                                    ],
                                  ),
                                ),

                              ) ,
                              onTap: (){

                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    ProductsByCategory(list[i].id)));


                              },
                            )




                      ),
                    ),
                  )



                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: ListTile(
                    trailing: Padding(
                        padding: EdgeInsets.all(
                            ResponsiveInfo.isMobile(context) ? 8 : 12),
                        child: GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(
                                  ResponsiveInfo.isMobile(context) ? 6 : 9),
                              decoration: BoxDecoration(
                                  color: Color(0xff2453a4),
                                  border: Border.all(color: Color(0xff2453a4)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ResponsiveInfo.isMobile(context)
                                              ? 10
                                              : 15))),
                              child: Text(
                                " See all  > ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveInfo.isMobile(context)
                                        ? 12
                                        : 14,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              )),
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage()));

                          },
                        )),
                    title: Text(
                      "Featured Products",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveInfo.isMobile(context) ? 17 : 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Check out our top picks.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ResponsiveInfo.isMobile(context) ? 12 : 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: SizedBox(
                    height: ResponsiveInfo.isMobile(context) ? 200 : 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        (list_products.length>3)?3: list_products.length ,
                        (i) => GestureDetector(
                          onTap: (){

                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsAdminPage(list_products[i].id,"user")));


                          },

                          child:
                            Padding(
                            padding: EdgeInsets.all(
                                ResponsiveInfo.isMobile(context) ? 5 : 8),
                            child: SizedBox(
                                width: ResponsiveInfo.isMobile(context)
                                    ? 150
                                    : 180,
                                child: Card(
                                  elevation:
                                      ResponsiveInfo.isMobile(context) ? 5 : 8,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child:  Padding(
                                  padding: EdgeInsets.all(
                                      ResponsiveInfo.isMobile(context) ? 5 : 8),

                                      child:  Image.network(list_products[i].imagepath
                                          ,
                                          width: double.infinity,
                                          height:
                                              ResponsiveInfo.isMobile(context)
                                                  ? 70
                                                  : 85,
                                          fit: BoxFit.fill,
                                        ) ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    ResponsiveInfo.isMobile(
                                                            context)
                                                        ? 3
                                                        : 6),
                                                child: Text(
                                                  list_products[i].name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: ResponsiveInfo
                                                              .isMobile(context)
                                                          ? 14
                                                          : 17),
                                                )),
                                            Text(
                                              list_products[i].price +" "+currency,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ResponsiveInfo.isMobile(
                                                              context)
                                                          ? 14
                                                          : 17,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ))) ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: ListTile(
                    title: Text(
                      "Limited Time Offers!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveInfo.isMobile(context) ? 17 : 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Check out our offers.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ResponsiveInfo.isMobile(context) ? 12 : 15),
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.all(
                      ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: (mpoffer.length>0)?CarouselSlider(
                    options: CarouselOptions(),
                    items: mpoffer.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),

                            child:Image.network(i['image']!.toString(),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width/1.7,
                              fit: BoxFit.fill,
                            ) ,

                          )

                            ;
                        },
                      );
                    }).toList(),
                  ) :Container()
                )



              ],
            ),
            )



          )
        ],
      ),
    );
  }

  getProductOfferList()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection('productoffer').get();

    List<dynamic>c=    productSnapshot.docs.toList();

    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;
      
      setState(() {
        
        mpoffer.add(m);
      });
      
      
    }
    
    
    
  }

  getCategoryList()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection('categories').get();
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    List<dynamic>c=    productSnapshot.docs.toList();

    // Navigator.pop(context);
    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;


      String id = ab.id;
      String name = m['name'] ?? '';
      String path = m['image_path'] ?? '';

      setState(() {
        list.add(new CategoryData(id,name,path));
      });


    }

  }



  getProductList()async
  {



    final productSnapshot = await FirebaseFirestore.instance.collection('product_master').get();

    List<dynamic>c=    productSnapshot.docs.toList();



    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      String id = ab.id;
      String name = m['name'] ?? '';
      String path = m['image'] ?? '';
      String category = m['category'] ?? '';

      setState(() {


          list_products.add(new Products(id,name,path,"",""));



      });
    }

    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    String? countrycode=   preferenceDataStorage.getString(Constants.pref_countrycode);

   String a= await ResponsiveInfo.getCurrencyByCountry(countrycode.toString());

   setState(() {
     currency=a;
   });






    for(int i=0;i<list_products.length;i++) {

      String productid=list_products[i].id;

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('products').where('id', isEqualTo: productid).get();


      List<dynamic>c1=    querySnapshot.docs.toList();


      if(c1.length>0) {

        QueryDocumentSnapshot ab1 = c1[0];

        var m1 = ab1.data() as Map<String, dynamic>;
        String Amount="";
        if(countrycode.toString().trim().compareTo("+91")==0)
          {
             Amount= await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['actual_amount_domestic']) ;
          }
        else{

          Amount= await ResponsiveInfo.getPriceByCountry(countrycode.toString(), m1['international_actual_price']) ;


        }


        String units=m1['units'];



        setState(() {

          list_products[i].price=Amount;

        });
        FirebaseFirestore.instance.collection('units').doc(units.trim()).get().then((value1) {
          var m3=value1.data()!;
          String unitname=m3['name'];

          setState(() {
            list_products[i].unit=unitname;

          });



        });



      }



    }

  }


}
