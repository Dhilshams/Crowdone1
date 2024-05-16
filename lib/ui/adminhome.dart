import 'package:ecommerce/ui/admin/faq_admin.dart';
import 'package:ecommerce/ui/faqpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/ui/admin/Addproductdetailspage.dart';
import 'productunit.dart';
import 'orderedlist.dart';
import 'pre_orders.dart';
import 'package:ecommerce/designs/ResponsiveInfo.dart';
import 'package:ecommerce/ui/admin/category_page.dart';
import 'package:ecommerce/ui/admin/uom_page.dart';
import 'package:ecommerce/ui/admin/productlist_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/constants/Constants.dart';
import 'package:ecommerce/ui/login.dart';
import 'package:ecommerce/ui/admin/wallet_request_list.dart';
import 'package:ecommerce/ui/admin/sales_ordery_admin.dart';
import 'package:ecommerce/ui/admin/payment_q_rcode.dart';
import 'package:ecommerce/ui/admin/country_list.dart';
import 'package:ecommerce/ui/admin/sales_offers.dart';
import 'package:ecommerce/ui/admin/product_offers.dart';
import 'package:ecommerce/ui/admin/member_ship_details.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {

            }
        ),
        title: Text("Admin Home",style: TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: Colors.blue,
        elevation: 4.0,
        actions: [
          Padding(padding: EdgeInsets.all(15),

            child: GestureDetector(
              child: Icon(Icons.exit_to_app,color: Colors.white,size: ResponsiveInfo.isMobile(context)?30:35),

              onTap: (){

                Widget okButton = TextButton(
                  child: Text("yes"),
                  onPressed: ()async {

                    final preferenceDataStorage = await SharedPreferences
                        .getInstance();
                    preferenceDataStorage.setString(Constants.pref_userid, "");
                    preferenceDataStorage.setString(Constants.pref_usertype, "");

                    Navigator.pop(context);


                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));



                  },
                );

                Widget okButton1 = TextButton(
                  child: Text("no"),
                  onPressed: () { },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Logout"),
                  content: Text("Do you want to logout now ?"),
                  actions: [
                    okButton,
                    okButton1
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },

            ),
          )


        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?10:15),

                child: Text(
                  'Dashboard',
                  style: TextStyle(
                      fontSize: ResponsiveInfo.isMobile(context)? 14.0 :16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ) ,


              GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: ResponsiveInfo.isMobile(context)?7:10,
                  crossAxisSpacing: ResponsiveInfo.isMobile(context)?7:10,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  childAspectRatio: 0.9,
                  children: [
                    _buildCategoryCard('User', Icons.person, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserListPage()));
                    }),
                    _buildCategoryCard('Category', Icons.category, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    }),
                    _buildCategoryCard('Product', Icons.shopping_bag, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductlistPage()));
                    }),
                    // _buildCategoryCard('Orders', Icons.add_shopping_cart, () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => OrderedListScreen()));
                    // }),
                    _buildCategoryCard('Units', Icons.scale, () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UomPage()));
                    }),
                    _buildCategoryCard('Sales Orders', Icons.list_alt, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SalesOrderyAdmin()), // Navigate to PreOrders page
                      );
                    }),

                    _buildCategoryCard('Wallet requests', Icons.wallet, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletRequestList()), // Navigate to PreOrders page
                      );

                    }),
                    _buildCategoryCard('Membership types', Icons.card_membership, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MemberShipDetails()), // Navigate to PreOrders page
                      );

                    }),



                    _buildCategoryCard('Product\'s Offers', Icons.local_offer_outlined, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductOffers()), // Navigate to PreOrders page
                      );

                    }),

                    _buildCategoryCard('Sale\'s Offers', Icons.local_offer, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SalesOffers()), // Navigate to PreOrders page
                      );


                    }),

                    _buildCategoryCard('Country', Icons.flag, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CountryList()), // Navigate to PreOrders page
                      );

                    }),

                    _buildCategoryCard('Payment QR code', Icons.qr_code, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentQRcode()), // Navigate to PreOrders page
                      );



                    }),

                    _buildCategoryCard('FAQ', Icons.info, () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FaqAdmin()), // Navigate to PreOrders page
                      );



                    }),

                  ],
                ),




              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => PreOrders()), // Navigate to PreOrders page
              //     );
              //   },
              //   child: Text('PreOrders'), // Text on the button
              // ),
            ],

          ),
          scrollDirection: Axis.vertical,
        )



      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
Navigator.pop(context);
            }
        ),
        backgroundColor: Colors.blue,
        title: Text('User List',style: TextStyle(fontSize:  ResponsiveInfo.isMobile(context)?13:15,color: Colors.white)),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('registration').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data!.docs.map((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          final name = data['name'] as String?;
          final email = data['email'] as String?;
          final isverified=data['isverified'].toString();
          final isApprovedbyAdmin=data['isApprovedbyAdmin'].toString();
          return {'name': name, 'email': email,'isverified':isverified,'isApprovedbyAdmin':isApprovedbyAdmin};
        }).toList();
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?6:12),

            child:Container(

              child:Card(
                color: Colors.white,
                elevation: 5,// Set the color of the card
                child: ListTile(
                  contentPadding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?6:10),
                  leading: Icon(Icons.person, color: Colors.blue),
                  trailing: Padding(padding: EdgeInsets.all(ResponsiveInfo.isMobile(context)?6:10),

                    child: (users[index]['isApprovedbyAdmin'].toString().compareTo("false")==0)? TextButton(onPressed: () {



                    }, child: Text("Approve",style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14),),


                    ) : TextButton(onPressed: () {



                    }, child: Text("Cancel Approval",style: TextStyle(fontSize: ResponsiveInfo.isMobile(context)?12:14),),


                    ) ,

                  ),
                  title: Text(
                    user['name'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveInfo.isMobile(context)?13:15,
                    ),
                  ),
                  subtitle: Text(
                    user['email'] ?? 'No Email',
                    style: TextStyle(
                      fontSize: ResponsiveInfo.isMobile(context)?13:15,
                    ),
                  ),
                  onTap: () {

                  },
                ),
              ) ,
              width: double.infinity,
              height: ResponsiveInfo.isMobile(context)?120:170,
            )


             ,

            )

              ;
          },
        );
      },
    );
  }
}





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminHomePage(),
    );
  }
}
class ProductUnitPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductUnitPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductUnitPageState createState() => _ProductUnitPageState();
}

class _ProductUnitPageState extends State<ProductUnitPage> {
  int availableUnits = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Units - ${widget.product['name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.product['imageUrl'] ?? ''),
              ),
              title: Text(widget.product['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['description'] ?? ''),
                  Text('Rating: ${widget.product['rating'] ?? 'N/A'}'),
                  Text('\$${widget.product['price'] ?? ''}'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Available Units',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter available units',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        availableUnits = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Save the available units to Firestore
                    saveAvailableUnits();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveAvailableUnits() async {
    try {
      await FirebaseFirestore.instance.collection('units').doc(widget.product['id']).set({
        'availableUnits': availableUnits,
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Available units saved successfully'),
      //   duration: Duration(seconds: 2),
      // ));


      ResponsiveInfo.showAlertDialog(context, "", "Available units saved successfully");



    } catch (error) {
      print('Error saving available units: $error');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Failed to save available units'),
      //   duration: Duration(seconds: 2),
      // ));
      ResponsiveInfo.showAlertDialog(context, "", "Failed to save available units");



    }
  }
}
