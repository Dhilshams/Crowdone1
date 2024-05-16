import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductView extends StatefulWidget {
  @override
  _UserProductViewState createState() => _UserProductViewState();
}

class _UserProductViewState extends State<UserProductView> {
  late Future<QuerySnapshot> _products;

  @override
  void initState() {
    super.initState();
    _products = _fetchProducts();
  }

  Future<QuerySnapshot> _fetchProducts() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance.collection('products').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> products = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> productData = products[index].data() as Map<String, dynamic>;
                return _buildProductCard(productData);
              },
            );
          } else {
            return Center(
              child: Text('No Products Found!'),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> productData) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productData['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Product Name
            Text(
              productData['name'] ?? 'No Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Product Price
            Text(
              '\$${productData['price'] ?? 'Price not available'}',
              style: TextStyle(color: Colors.green),
            ),
            //  add more fields here
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProductView(),
  ));
}
