import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/verification.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../constants/Constants.dart';
import '../domain/CountryData.dart';

class Registration extends StatefulWidget {
  Registration();

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late var p1;

  bool checkedValue=false;

  List<String>countrylist=[];

  String selectedcountry="";

  List<CountryData>countrycodelist=[];

  late CountryData cdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f5f9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 14),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/colorlogo.png",
                        width: ResponsiveInfo.isMobile(context) ? 120 : 150,
                        height: ResponsiveInfo.isMobile(context) ? 120 : 150,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Get onboard',
                            style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context) ? 20 : 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Create Profile to start your journey',
                            style: TextStyle(color: Colors.black54, fontSize: ResponsiveInfo.isMobile(context) ? 10 : 13, fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                    flex: 4,
                  )
                ],
              ),
            ),

            // TextFields for user registration details
            // Full Name
            buildTextField("Full Name", _nameController),
            // Email Address
            buildTextField("Email Address", _emailController),


            // Phone Number


    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Expanded(child:Padding(
          padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    fontSize: ResponsiveInfo.isMobile(context) ? 12 : 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: "Country Code"),
                    new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: ResponsiveInfo.isMobile(context) ? 55 : 65,
                padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?3:7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
                ),
                child: DropdownButton<String>(
                  value: selectedcountry,
                  onChanged: (value) {
                    setState(()async {

                      selectedcountry = value!;

                      for(int j=0;j<countrycodelist.length;j++)
                        {

                          if(selectedcountry.trim().compareTo(countrycodelist[j].code.trim())==0)
                            {

                              cdata=countrycodelist[j];

                              final preferenceDataStorage = await SharedPreferences
                                  .getInstance();
                              preferenceDataStorage.setString(Constants.pref_countrycode,selectedcountry);
                              break;
                            }


                        }



                    });
                  },
                  items: countrylist.map((String hsnCode) {
                    return DropdownMenuItem<String>(
                      value: hsnCode,
                      child: Text(hsnCode),
                    );
                  }).toList(),
                  disabledHint: Text(""),
                ) ,
              )

             ,

            ],
          ),
        )





        ,flex: 1,),

        Expanded(child: buildTextField("Phone Number", _phoneController,ismobile:true),flex: 2,)


      ],
    ),






            // Password
            buildTextField("Password", _passwordController, isPassword: true),

            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: CheckboxListTile(
                title: RichText(
    text: TextSpan(
    children: [
    TextSpan(
    text: 'I agree ',
    style: TextStyle(color: Colors.black),
    ),
    TextSpan(
    text: 'terms and conditions',
    style: TextStyle(color: Colors.blue),
    recognizer: TapGestureRecognizer()
    ..onTap = () async{
    // Handle the click action here
    print('You clicked on "here"');
    var url = Uri.parse("https://crowdone.in/privacy");
    // if (await canLaunchUrl(url)) {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
      // } else {
      // throw 'Could not launch $url';
      // }
    },
    ),

    ],
    )),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )
            ),

            // Signup Button
            Padding(
              padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff255eab),
                  border: Border.all(color: Color(0xff255eab)),
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context) ? 10 : 15)),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Save user details to Firestore
                    await saveUserDetails();

                  },
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
            //     child:Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Expanded(child: Container(
            //           width: double.infinity,
            //           height: ResponsiveInfo.isMobile(context)? 1 : 2,
            //           color: Colors.black26,
            //
            //         ),flex: 3,),
            //         Text(' Or ',style: TextStyle(color: Colors.black87, fontSize: ResponsiveInfo.isMobile(context)?14:17)),
            //
            //
            //
            //         Expanded(child: Container(
            //           width: double.infinity,
            //           height: ResponsiveInfo.isMobile(context)? 1 : 2,
            //           color: Colors.black26,
            //
            //         ),flex: 3,)
            //
            //
            //       ],
            //
            //
            //     )
            //
            // ),


            // Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
            //   child: Container(
            //
            //
            //       width: double.infinity,
            //       height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(color: Colors.black54),
            //           borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))
            //
            //       ),
            //
            //
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //
            //         children: [
            //
            //           Padding(padding: EdgeInsets.all(5),
            //             child:      Image.asset("assets/images/google.png",width: ResponsiveInfo.isMobile(context)? 30 : 40,height: ResponsiveInfo.isMobile(context)? 30 : 40,),
            //
            //
            //           ),
            //
            //           TextButton(
            //             child: Text( 'Continue with Google', style: TextStyle(color: Colors.black, fontSize: ResponsiveInfo.isMobile(context)?15:17,fontWeight: FontWeight.bold),
            //             ),
            //             onPressed: ()async{
            //
            //
            //
            //
            //
            //
            //
            //             },
            //
            //           ),
            //         ],
            //       )
            //
            //
            //
            //
            //   ),
            // ),
            //
            //
            // Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)? 10 : 15),
            //   child: Container(
            //
            //
            //       width: double.infinity,
            //       height:ResponsiveInfo.isMobile(context)? 55 : 65 ,
            //       decoration: BoxDecoration(
            //           color: Color(0xff3877f2),
            //           border: Border.all(color: Color(0xff3877f2)),
            //           borderRadius: BorderRadius.all(Radius.circular(ResponsiveInfo.isMobile(context)? 10 : 15))
            //
            //       ),
            //
            //
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //
            //         children: [
            //
            //           Padding(padding: EdgeInsets.all(5),
            //             child:      Image.asset("assets/images/fb.png",width: ResponsiveInfo.isMobile(context)? 30 : 40,height: ResponsiveInfo.isMobile(context)? 30 : 40,),
            //
            //
            //           ),
            //
            //           TextButton(
            //             child: Text( 'Continue with Facebook', style: TextStyle(color: Colors.white, fontSize: ResponsiveInfo.isMobile(context)?15:17,fontWeight: FontWeight.bold),
            //             ),
            //             onPressed: ()async{
            //
            //               // if(usercontroller.text.toString().isNotEmpty)
            //               // {
            //               //   if(passwordcontroller.text.toString().isNotEmpty)
            //               //   {
            //               //
            //               //     showLoaderDialog(context);
            //               //
            //               //     String urlmethode=Constants.baseurl+Constants.login;
            //               //
            //               //     ApiServices apiservices=new ApiServices();
            //               //     Map mp = new HashMap();
            //               //     mp['username'] = usercontroller.text;
            //               //     mp['password'] = passwordcontroller.text;
            //               //     String? data= await  apiservices.postmethod(context, mp, urlmethode);
            //               //
            //               //     Navigator.pop(context);
            //               //
            //               //     var a=jsonDecode(data.toString());
            //               //
            //               //
            //               //     UserdetailsEntity userdetails=UserdetailsEntity.fromJson(a);
            //               //
            //               //     if(userdetails.status==1)
            //               //     {
            //               //
            //               //       final preferenceDataStorage = await SharedPreferences
            //               //           .getInstance();
            //               //
            //               //
            //               //       preferenceDataStorage.setString(Constants.userkey, data.toString());
            //               //
            //               //       Navigator.pushReplacement(context,
            //               //           MaterialPageRoute(builder:
            //               //               (context) =>
            //               //               Home()
            //               //           )
            //               //       );
            //               //
            //               //
            //               //     }
            //               //     else{
            //               //
            //               //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //               //         content: Text('Login Failed'),
            //               //       ));
            //               //     }
            //               //
            //               //
            //               //   }
            //               //   else{
            //               //
            //               //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //               //       content: Text('Enter password'),
            //               //     ));
            //               //
            //               //   }
            //               //
            //               //
            //               //
            //               // }
            //               // else{
            //               //
            //               //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //               //     content: Text('Enter username'),
            //               //   ));
            //               //
            //               // }
            //
            //
            //
            //
            //
            //             },
            //
            //           ),
            //         ],
            //       )
            //
            //
            //
            //
            //   ),
            // ),


            // Other UI elements...
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller, {bool isPassword = false,bool ismobile = false} ) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveInfo.isMobile(context) ? 10 : 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: new TextSpan(
              style: new TextStyle(
                fontSize: ResponsiveInfo.isMobile(context) ? 12 : 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: labelText),
                new TextSpan(text: ' * \n', style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
          Container(
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
              obscureText: isPassword,
              keyboardType: (ismobile)? TextInputType.phone : TextInputType.text ,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter $labelText',
                hintStyle: TextStyle(fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14, color: Colors.black26),
              ),
              style: TextStyle(fontSize: ResponsiveInfo.isMobile(context) ? 12 : 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserDetails() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text;
    String location_details="";

    if(name.isNotEmpty) {
      if(email.isNotEmpty) {
        if(phone.isNotEmpty) {

          if(password.isNotEmpty) {

            if(password.length>=8) {

              if(checkedValue) {
                // Add user details to Firestore

                showLoaderDialog(context);

                bool isexistcountry = false;

                Location location = new Location();

                bool _serviceEnabled;
                PermissionStatus _permissionGranted;
                LocationData _locationData;

                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (!_serviceEnabled) {
                    return;
                  }
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                _locationData = await location.getLocation();

                if (_locationData != null) {
                  print(_locationData.latitude.toString() + "," +
                      _locationData.longitude.toString());

                  List<geocode.Placemark> placemarks = await geocode
                      .placemarkFromCoordinates(
                      _locationData.latitude!, _locationData.longitude!);

                  if (placemarks.length > 0) {
                    for (int i = 0; i < placemarks.length; i++) {
                      print(i.toString() + "," +
                          placemarks[i].country.toString());
                      location_details=location_details+
                          placemarks[i].country.toString()+","+placemarks[i].isoCountryCode.toString()+","+placemarks[i].name.toString()+","+placemarks[i].postalCode.toString();

                      if (placemarks[i].country.toString().trim().compareTo(
                          cdata.name.trim()) == 0) {
                        isexistcountry = true;
                        break;
                      }
                    }
                  }


                  final productSnapshot = await FirebaseFirestore.instance
                      .collection('registration').get();

                  List<dynamic>c = productSnapshot.docs.toList();
                  bool a = false,b=false;
                  for (int i = 0; i < c.length; i++) {
                    QueryDocumentSnapshot ab = c[i];

                    var m = ab.data() as Map<String, dynamic>;


                    String email1 = m['email'];
                    String phone1=m['phone'];
                    if (email.compareTo(email1) == 0) {
                      a = true;
                    }
                    if (phone1.compareTo(phone) == 0) {
                      b = true;
                    }
                  }


                  if (isexistcountry) {
                    if (!a) {
                      if(!b) {
                        p1 =
                        await FirebaseFirestore.instance.collection(
                            'registration').add(
                            {
                              'name': name,
                              'email': email,
                              'phone': phone,
                              'password': password,
                              'countrycode':selectedcountry,
                              'timestamp': DateTime.now(),
                              'isverified': false,
                              'image': ""
                            }).whenComplete(() {
                          Navigator.pop(context);

                          _nameController.clear();
                          _emailController.clear();
                          _phoneController.clear();
                          _passwordController.clear();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Verification(p1.id,phone,selectedcountry)),
                          );
                        });
                      }
                      else{
                        Navigator.pop(context);


                        ResponsiveInfo.showAlertDialog(
                            context, "", "This Phone number is already registered");
                      }
                    }
                    else {
                      Navigator.pop(context);


                      ResponsiveInfo.showAlertDialog(
                          context, "", "This email ID is already registered");
                    }
                  }
                  else {
                    Navigator.pop(context);

                    // ResponsiveInfo.showAlertDialog(context, "", location_details);
                    ResponsiveInfo.showAlertDialog(context, "",
                        "Your current location is not matching with selected country.Please Change the country code");
                  }
                }
                else {
                  Navigator.pop(context);


                  ResponsiveInfo.showAlertDialog(
                      context, "", "Cannot access your location");
                }
              }
              else{

                ResponsiveInfo.showAlertDialog(context, "", "Please accept our terms and conditions");

              }




      // Clear text fields after saving
            }
            else{


              ResponsiveInfo.showAlertDialog(context, "", "Your Password should contain atleast 8 characters");

            }




          }
          else{



            ResponsiveInfo.showAlertDialog(context, "", "Enter Password");

          }

        }
        else{

          ResponsiveInfo.showAlertDialog(context, "", "Enter Phone");


        }

      }
      else{
        ResponsiveInfo.showAlertDialog(context, "", "Enter email");

      }



    }
    else{
      ResponsiveInfo.showAlertDialog(context, "", "Enter name");

    }

  }


  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }

  getCountryList() async {
    final productSnapshot1 = await FirebaseFirestore.instance.collection(
        'countryList').get();

    List<dynamic>c = productSnapshot1.docs.toList();
    bool a = false;
    countrylist.clear();
    for (int i = 0; i < c.length; i++) {
      QueryDocumentSnapshot ab = c[i];

      var m = ab.data() as Map<String, dynamic>;


      String name = m['name'];
      String code = m['countrycode'];
      String id = ab.id;
      String conversionfactor=m['ConversionFactor'];
      String currency_symbol="";

      if(m.containsKey("currency_symbol"))
      {
        currency_symbol=m['currency_symbol'];
      }


       CountryData data = new CountryData(id, name, code,conversionfactor,currency_symbol);

      setState(() {

        countrycodelist.add(data);
        countrylist.add(code);
        if(i==0){

          cdata=countrycodelist[i];
          selectedcountry=code;


        }
      });
    }




    // countryList
  }


  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." ,style: TextStyle(fontSize: 12,color: Colors.black),)),
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
