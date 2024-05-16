import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:flutter/material.dart';

class EditFaqAdmin extends StatefulWidget {

  String data;
  String id;
   EditFaqAdmin(this.data,this.id) ;

  @override
  _EditFaqAdminState createState() => _EditFaqAdminState(this.data,this.id);
}

class _EditFaqAdminState extends State<EditFaqAdmin> {

  String data;
  String id;

  _EditFaqAdminState(this.data,this.id);
  TextEditingController textEditingController=new TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      textEditingController.text=data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,  //It should be false to work
        onPopInvoked : (didPop) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop({"result":1});
           //Here this temporary, you can change this line
        },
        child:Scaffold(

      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {

              Navigator.of(context).pop({"result":1});

            }
        ),
        title: Text("Edit FAQ",style: TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: Colors.blue,
        elevation: 4.0,

      ),

      body: Column(

        children: [

          Expanded(child:        Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child:Container(
            width: double.infinity,
            height: double.infinity,
           child: TextField(

             keyboardType: TextInputType.multiline,
             maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),

                labelText: 'Faq',
                hintText: 'Faq',
              ),
              controller: textEditingController,
            )),
          ),flex:3),

          Expanded(child:    Stack(

            children: [

              Align(
                alignment: FractionalOffset.center,
                child:Padding(
                  padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                  child: Container(
                    width: ResponsiveInfo.isMobile(context) ? 130 : 160,
                    height: ResponsiveInfo.isMobile(context) ? 50 : 65,
                    decoration: BoxDecoration(
                      color: Color(0xff255eab),
                      border: Border.all(color: Color(0xff255eab)),
                      borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
                    ),
                    child: TextButton(
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                      ),
                      onPressed: () async {
                        // Call a function to authenticate user
                        showLoaderDialog(context);
                        await FirebaseFirestore.instance.collection('faq').doc(id).update({"data":textEditingController.text}).then((value) {

                          Navigator.pop(context);
                          ResponsiveInfo.showAlertDialog(context, "", "Details Updated Successfully");

                        });





                      },
                    ),
                  ),
                ),
              )
            ],
          )


          ,flex: 1,)



        ],
      ),

    ) );
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
