import 'dart:async';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/login.dart';
import 'package:ecommerce/ui/verification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:ecommerce/ui/dashboard.dart';
import 'package:ecommerce/ui/home.dart';
import 'package:ecommerce/ui/adminhome.dart';
import 'package:ecommerce/ui/membership.dart';

// Import Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff284ca0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: ResponsiveInfo.isMobile(context) ? 120 : 150,
              height: ResponsiveInfo.isMobile(context) ? 120 : 150,
              fit: BoxFit.fill,
            )
          ],
        ),
      ),
    );
  }

  void checkLogin() async {
    final preferenceDataStorage = await SharedPreferences
        .getInstance();
 String? userid=   preferenceDataStorage.getString(Constants.pref_userid);
 String? usertype=   preferenceDataStorage.getString(Constants.pref_usertype);

 if(userid!=null && userid.toString().isNotEmpty) {

   if(usertype.toString().compareTo(Constants.admin_usertype)==0) {
     Timer(
       const Duration(seconds: 3),
           () =>
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(
               builder: (context) => AdminHomePage(),
             ),
           ),
     );
   }
   else{

     Timer(
       const Duration(seconds: 3),
           () =>

               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                   builder: (context) => Login(),
                 ),
               ),
           // Navigator.pushReplacement(
           //   context,
           //   MaterialPageRoute(
           //     builder: (context) => MyDashboardPage(),
           //   ),
           // ),
       // Navigator.pushReplacement(
       //   context,
       //   MaterialPageRoute(
       //     builder: (context) => Login(),
       //   ),
       // ),
     );

   }
 }
 else{

   Timer(
     const Duration(seconds: 3),
         () =>
             // Navigator.push(context,
             //     MaterialPageRoute(builder:
             //         (context) =>
             //         Membership()
             //     )
             // )
     Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) => Login(),
           ),
         ),
     

   );


 }
  }
}
