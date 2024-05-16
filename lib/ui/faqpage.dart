import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../designs/ResponsiveInfo.dart';

class Faqpage extends StatefulWidget {
   Faqpage() ;

  @override
  _FaqpageState createState() => _FaqpageState();
}

class _FaqpageState extends State<Faqpage> {



  String data="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFaqData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
            onPressed: () {

              Navigator.pop(context);

            }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          "FAQ",
          style: TextStyle(
              color: Colors.black,
              fontSize:ResponsiveInfo.isMobile(context)? 15 :18,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold),
        ),

      ),


      body: SingleChildScrollView(

        child: Stack(

          children: [

            (data.isNotEmpty)?  Align(
              alignment: FractionalOffset.topCenter,

              child: Text(data,style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 :16,color: Colors.black87 ),),

            ) :Align(
              alignment: FractionalOffset.center,
              child: Text("No data found",style: TextStyle(fontSize:ResponsiveInfo.isMobile(context)? 13 :16,color: Colors.black87 ),),


            )
          ],
        ),
      ),




    );
  }

  getFaqData()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection('faq').get();


    List<dynamic>c=    productSnapshot.docs.toList();



    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;

      setState(() {

        data=m['data'];
      });



    }
  }
}
