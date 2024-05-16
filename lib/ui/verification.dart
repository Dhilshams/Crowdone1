import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'membership.dart';
import 'package:ecommerce/ui/login.dart';
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

class Verification extends StatefulWidget {

  String id;
  String phone;
  String selectedcountry;


   Verification(this.id,this.phone,this.selectedcountry) ;

  @override
  _VerificationState createState() => _VerificationState(this.id,this.phone,this.selectedcountry);
}

class _VerificationState extends State<Verification> {



  String id;
  String phone;
  String selectedcountry;

  _VerificationState(this.id,this.phone,this.selectedcountry);


  TextEditingController usercontroller=new TextEditingController();
  TextEditingController controller=new TextEditingController();


  final FirebaseAuth _auth = FirebaseAuth.instance;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sendOTP(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff1f5f9),

      body:  Stack(

        children: <Widget>[

          Align(
            alignment: FractionalOffset.topCenter,
            child:  Padding(padding: EdgeInsets.fromLTRB(0, ResponsiveInfo.isMobile(context)?70.0:90.0 , 0, 0),
              child:      Image.asset("assets/images/mail.png",
                width: ResponsiveInfo.isMobile(context)? 60 : 80,height: ResponsiveInfo.isMobile(context)? 60 : 80,fit: BoxFit.fill),


            ),
          ),

          Align(
            alignment: FractionalOffset.topCenter,
            child: Padding(


              padding: EdgeInsets.fromLTRB(ResponsiveInfo.isMobile(context)?10:15,
                  ResponsiveInfo.isMobile(context)?140:170 , ResponsiveInfo.isMobile(context)?10:15, 0),
              child: Column(

                children: [
                  Text( 'OTP verification', style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?20:25,fontWeight: FontWeight.bold)
                  ),

                  Text( '\n We have just sent an OTP code   to your mobile number. Please enter here to verify your phone number', style: TextStyle(color: Colors.black,
                      fontSize: ResponsiveInfo.isMobile(context)?14:16,fontWeight: FontWeight.normal)
                  ),

                  Padding(padding: EdgeInsets.fromLTRB(0, ResponsiveInfo.isMobile(context)?10:15, 0, 0),

                  child:Padding(
                    padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 14),
                    child:            Container(
                      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
                      width: double.infinity,
                      height: ResponsiveInfo.isMobile(context) ? 55 : 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
                      ),
                      child: TextField(
                        controller: controller,

                        keyboardType:  TextInputType.phone ,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'OTP Code',
                          hintStyle: TextStyle(fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14, color: Colors.black26),
                        ),
                        style: TextStyle(fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14, color: Colors.black87),
                      ),
                    ),
                  ),

                  ),



                  Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 20 : 30),
                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                          color: Color(0xff255eab),
                          border: Border.all(color: Color(0xff255eab)),
                          borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))

                      ),


                      child:  TextButton(
                        child: Text( 'Continue', style: TextStyle(
                            color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?14:17,fontWeight: FontWeight.bold),
                        ),
                        onPressed: ()async{










                        },

                      ),

                    ),
                  ),

                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 20 : 30),
                  child:  Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Padding(
                              padding:  EdgeInsets.only(left: ResponsiveInfo.isMobile(context)?5.0:7.0),
                              child: Text('Didn\'t receive the OTP code ?',style: TextStyle(color: Colors.black87, fontSize: ResponsiveInfo.isMobile(context)?14:17)),
                            ),

                            Padding(
                              padding:  EdgeInsets.only(left:ResponsiveInfo.isMobile(context)?1.0 : 3.0),
                              child: InkWell(
                                  onTap: (){
                                    print('hello');

                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder:
                                    //         (context) =>
                                    //         Registration()
                                    //     )
                                    // );
                                  },
                                  child: Text('Click here to resend',
                                    style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?14:17, color: Color(0xff2560ac),fontWeight: FontWeight.bold),)),
                            )
                          ],
                        ),
                      )
                  )),


                Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 20 : 30),
                  child: Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Padding(
                              padding:  EdgeInsets.only(left: ResponsiveInfo.isMobile(context)?5.0:7.0),
                              child: GestureDetector(
                                
                                child: Icon(Icons.arrow_back,color: Color(0xff2560ac),size:ResponsiveInfo.isMobile(context)?20.0:25.0 ,),
                              )
                            ),

                            Padding(
                              padding:  EdgeInsets.only(left:ResponsiveInfo.isMobile(context)?1.0 : 3.0),
                              child: InkWell(
                                  onTap: (){
                                    print('hello');

                                    Navigator.push(context,
                                        MaterialPageRoute(builder:
                                            (context) =>
                                            Login()
                                        )
                                    );
                                  },
                                  child: Text('Back to login',
                                    style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?14:17, color: Color(0xff2560ac),fontWeight: FontWeight.bold),)),
                            )
                          ],
                        ),
                      )
                  ))



                ],

              )




            ),
          )






        ],
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


  verifyCustomer()
  async {
    showLoaderDialog(context);

    await FirebaseFirestore.instance.collection('registration').doc(id).update({'isverified': true}).whenComplete(() async{

      final preferenceDataStorage = await SharedPreferences
          .getInstance();
      preferenceDataStorage.setString(Constants.pref_userid, id);
      preferenceDataStorage.setString(Constants.pref_usertype, Constants.normal_usertype);


      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder:
              (context) =>
              Membership()
          )
      );

    });
  }



  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code
        verifyCustomer();
        await _auth.signInWithCredential(credential);


      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Save the verification ID for future use
        String smsCode = 'xxxxxx'; // Code input by the user 4 digits
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        // Sign the user in with the credential
        await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }



}
