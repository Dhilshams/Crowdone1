import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../designs/ResponsiveInfo.dart';
import 'edit_faq_admin.dart';

class FaqAdmin extends StatefulWidget {
   FaqAdmin() ;

  @override
  _FaqAdminState createState() => _FaqAdminState();
}

class _FaqAdminState extends State<FaqAdmin> {


  String data="";
  String id="0";

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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {

              Navigator.pop(context);

            }
        ),
        title: Text("FAQ",style: TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: Colors.blue,
        elevation: 4.0,
        actions: [
          Padding(padding: EdgeInsets.all(15),

            child: GestureDetector(
              child: Icon(Icons.edit,color: Colors.white,size: ResponsiveInfo.isMobile(context)?30:35),

              onTap: () async {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditFaqAdmin(data,id)),
                );

                Map m=result as Map;

                if(m.containsKey("result"))
                  {

                    int m1=m["result"] as int;

                    if(m1==1)
                    {
                      getFaqData();
                    }

                  }


                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EditFaqAdmin(data,id)), // Navigate to PreOrders page
                // );


              },

            ),
          )


        ],
      ),

      body: SingleChildScrollView(

        child: Text(data,style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?13:15,color: Colors.black87),),
      ),

    );
  }


  getFaqData()async
  {
    final productSnapshot = await FirebaseFirestore.instance.collection('faq').get();


    List<dynamic>c=    productSnapshot.docs.toList();



    for(int i=0;i<c.length;i++) {
      QueryDocumentSnapshot ab = c[i];

      id=ab.id;

      var m = ab.data() as Map<String, dynamic>;

      setState(() {

        data=m['data'];
      });



    }
  }
}
