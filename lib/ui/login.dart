import 'package:ecommerce/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/adminhome.dart';
import 'package:ecommerce/ui/dashboard.dart';
import 'package:ecommerce/ui/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:mailer/mailer.dart' as mailAddress;
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'dashboard.dart';
import 'dart:io';
import 'dart:typed_data';

class Login extends StatefulWidget {
  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    // Check for stored user credentials when the screen is first loaded
    _autoLogin();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff1f5f9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              "assets/images/colorlogo.png",
              width: ResponsiveInfo.isMobile(context) ? 120 : 150,
              height: ResponsiveInfo.isMobile(context) ? 120 : 150,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Username',
              ),
              controller: userController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter secure password',
              ),
              controller: passwordController,
            ),
          ),
          SizedBox(
            height: ResponsiveInfo.isMobile(context) ? 10.0 : 16.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ResponsiveInfo.isMobile(context) ? 5.0 : 7.0,
              right: ResponsiveInfo.isMobile(context) ? 10.0 : 15.0,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  showEmailConfirmation();
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: ResponsiveInfo.isMobile(context) ? 14 : 17,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
            child: Container(
              width: double.infinity,
              height: ResponsiveInfo.isMobile(context) ? 50 : 65,
              decoration: BoxDecoration(
                color: Color(0xff255eab),
                border: Border.all(color: Color(0xff255eab)),
                borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
              ),
              child: TextButton(
                child: Text(
                  'Log in',
                  style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
                ),
                onPressed: () async {
                  // Call a function to authenticate user
                  authenticateUser();
                },
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveInfo.isMobile(context) ? 20 : 25,
          ),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: ResponsiveInfo.isMobile(context) ? 5.0 : 7.0),
                    child: Text('Don\'t you have an account? ', style: TextStyle(color: Colors.black87, fontSize: ResponsiveInfo.isMobile(context) ? 14 : 17)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ResponsiveInfo.isMobile(context) ? 1.0 : 3.0),
                    child: InkWell(
                      onTap: () {
                        print('hello');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                      },
                      child: Text('Register', style: TextStyle(fontSize: ResponsiveInfo.isMobile(context) ? 14 : 17, color: Colors.blue)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _autoLogin() async {
    // Check if user is already logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Constants.pref_userid);
    String? userType = prefs.getString(Constants.pref_usertype);

    if (userId != null && userType != null) {
      // Navigate based on user type
      if (userType == Constants.admin_usertype) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else if (userType == Constants.normal_usertype) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyDashboardPage()),
        );
      }
    }
  }

  void authenticateUser() async {
    String name = userController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      // Handle case where name or password is empty
      ResponsiveInfo.showAlertDialog(context, "Login", "Please enter username and password");
      return;
    }

    showLoaderDialog(context);

    // Check if user is admin
    bool isAdmin = await checkAdmin(name, password);
    Navigator.pop(context);
    if (isAdmin) {

      // Navigate to admin page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else {
      // Check if user exists in registration collection
      bool isValidUser = await checkUserCredentials(name, password);
      if (isValidUser) {
        // Navigate to regular user page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyDashboardPage()),
        );
      } else {
        userController.clear();
        passwordController.clear();
        // Show dialog box for invalid credentials
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Credentials"),
              content: Text("The username or password is incorrect."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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

  Future<bool> checkAdmin(String name, String password) async {
    // Initialize Firebase if not already initialized
    await Firebase.initializeApp();

    // Check if name or password is null
    if (name == null || password == null) {
      return false;
    }

    // Query Firestore to check if the user exists and get their userType
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: name).where('password', isEqualTo: password).get();

    // If query returns a document, check if it's an admin
    if (querySnapshot.docs.isNotEmpty) {
      // String userType = querySnapshot.docs.first.data()['usertype'];
      String userid=   querySnapshot.docs.first.id;

      final preferenceDataStorage = await SharedPreferences
          .getInstance();
      preferenceDataStorage.setString(Constants.pref_userid, userid);
      preferenceDataStorage.setString(Constants.pref_usertype, Constants.admin_usertype);
      return true;
      // return userType == '31aAARMH4Mbu0gy6HlJ4';
    }

    // If no document found, return false
    return false;
  }

  Future<bool> checkUserCredentials(String name, String password) async {
    // Initialize Firebase if not already initialized
    await Firebase.initializeApp();
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
    // Query Firestore to check if the user exists in registration collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('registration').where('email', isEqualTo: name).where('password', isEqualTo: password).get();

    // If query returns a document, user credentials are valid
    if (querySnapshot.docs.isNotEmpty) {

      String userid=   querySnapshot.docs.first.id;

      querySnapshot.docs.forEach((element) {

        var m= element.data();
        String countrycode=  m['countrycode'].toString();

        preferenceDataStorage.setString(Constants.pref_countrycode, countrycode);

      });


      preferenceDataStorage.setString(Constants.pref_userid, userid);
      preferenceDataStorage.setString(Constants.pref_usertype, Constants.normal_usertype);



      return true;
    }

    // If no document found, user credentials are invalid
    return false;
  }


  Future<bool> checkDocumentExists(String email) async {
    await Firebase.initializeApp();

    // Query Firestore to check if a document with the specified email exists
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('registration').where('email', isEqualTo: email).get();

    // If query returns any documents, then the document exists
    return querySnapshot.docs.isNotEmpty;
  }

  showEmailConfirmation() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                String email = emailController.text.trim(); // Trimming the email
                if (email.isNotEmpty) {
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            Container(
                              margin: EdgeInsets.only(left: 7),
                              child: Text("Sending Email..."),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  bool documentExists = await checkDocumentExists(email);
                  if (documentExists) {
                    String temporaryPassword = generateRandomPassword();
                    await updatePasswordInFirestore(email, temporaryPassword);
                    bool emailSent = await sendPasswordResetEmail(
                      email,
                      temporaryPassword,
                    );

                    Navigator.pop(context); // Close loading dialog

                    if (emailSent) {
                      // Email sent successfully, display success message
                      Navigator.pop(context); // Close the current dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success"),
                            content: Text("New Password sent to $email"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Failed to send email, display error message
                    }
                  } else {
                    // Document with the provided email does not exist, display error message
                    // Handle error accordingly
                  }
                } else {
                  // Email field is empty, display error message
                  Navigator.pop(context); // Close the current dialog
                  showAlertDialog(
                    context,
                    "Error",
                    "Please enter your email",
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String generateRandomPassword() {
    // Generate a random 6-digit password
    Random random = Random();
    return random.nextInt(100000000).toString().padLeft(8, '0');
  }

  Future<void> updatePasswordInFirestore(String email, String password) async {
    await Firebase.initializeApp();

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('registration').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('registration').doc(documentId).update({'password': password});

        // Close the loading dialog
        Navigator.of(context).pop();

        // Close the forgot password dialog
        Navigator.of(context).pop();

        // Show a brief alert dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true); // Close the alert dialog after 1 second
            });
            return AlertDialog(
              title: Text("Success"),
              content: Text("Check your email for the new password."),
            );
          },
        );
      } else {
        print('No document found with email $email');
        // Close the loading dialog
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating password: $e');
      // Close the loading dialog
      Navigator.of(context).pop();
    }
  }

  Future<bool> sendPasswordResetEmail(String email, String temporaryPassword) async {
    final smtpServer = SmtpServer(
      'mail.privateemail.com',
      username: 'support@crowdone.in',
      password: 'Dubai@1234',
      port: 465,
      ssl: true,
    );

    // Create message
    final message = mailAddress.Message()
      ..from = mailAddress.Address("support@crowdone.in", 'support@crowdone.in')
      ..recipients.add(email.trim())
      ..ccRecipients.addAll(['support@crowdone.in', email.trim()])
      ..subject = 'Password Update'
      ..text = 'Your New Password is: $temporaryPassword\n\nPlease use this password to login ';

    try {
      final sendReport = await mailAddress.send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true; // Email sent successfully
    } on mailAddress.MailerException catch (e) {
      print('Message not sent.' + e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false; // Failed to send email
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



//showEmailConfirmation(){
// txtemail.text=email;
// txtname.text=name;
// AlertDialog alert=AlertDialog(
//   content: Column(
//
//     children: [
//
//       Padding(
//         padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//         child: TextField(
//           keyboardType: TextInputType.text,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Enter name',
//             hintText: 'Enter name',
//           ),
//           controller: txtname,
//         ),
//       ),
//       SizedBox(
//         height: ResponsiveInfo.isMobile(context) ? 20 : 25,
//       ),
//
//       Padding(
//         padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//         child: TextField(
//           keyboardType: TextInputType.text,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Enter email',
//             hintText: 'Enter email',
//           ),
//           controller: txtemail,
//         ),
//       ),
//
//       Padding(
//         padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
//         child: Container(
//           width: double.infinity,
//           height: ResponsiveInfo.isMobile(context) ? 50 : 65,
//           decoration: BoxDecoration(
//             color: Color(0xff255eab),
//             border: Border.all(color: Color(0xff255eab)),
//             borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
//           ),
//           child: TextButton(
//             child: Text(
//               'Submit',
//               style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14),
//             ),
//             onPressed: ()  async {
//               // Call a function to authenticate user
//
//               if(txtname.text.isNotEmpty)
//               {
//                 if(txtemail.text.isNotEmpty)
//                 {
//                   final preferenceDataStorage = await SharedPreferences
//                       .getInstance();
//                   String? id=  preferenceDataStorage.getString(Constants.pref_userid);
//
//
//                   showLoaderDialog(context);
//
//                   await FirebaseFirestore.instance.collection('registration').doc(id).update({'email':txtemail.text,
//                     'name':txtname.text}).then((value) {
//
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                     getUserDetails();
//
//                   });
//                 }
//                 else{
//
//                   ResponsiveInfo.showAlertDialog(context, "", "Enter email");
//                 }
//
//               }
//               else{
//
//                 ResponsiveInfo.showAlertDialog(context, "", "Enter name");
//               }
//
//
//
//
//             },
//           ),
//         ),
//       ),
//
//
//
//     ],
//   ),
// );
// showDialog(barrierDismissible: false,
//   context:context,
//   builder:(BuildContext context){
//     return alert;
//   },
// );
//}
//}