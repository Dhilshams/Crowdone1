import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../designs/ResponsiveInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ProductItem(
                imageUrl: data['image'] ?? '', // Check for null
                name: data['name_description'] ?? '', // Check for null
                price: data['price'] != null ? data['price'].toDouble() : 0.0, // Check for null and convert to double
              );
            },
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;

  ProductItem({
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductUnitScreen(
              imageUrl: imageUrl,
              name: name,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: imageUrl.isNotEmpty
              ? Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
              : SizedBox(
            width: 50,
            height: 50,
            child: Placeholder(),
          ),
          title: Text(name),
          subtitle: Text('\$$price'),
        ),
      ),
    );
  }
}

class ProductUnitScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;

  ProductUnitScreen({
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductUnitScreen> {
  List<String> selectedUnits = [];
  List<String> manualUnits = [];

  String? dropdownValue;
  List<String> dropdownItems = ['500kg', '1kg', '100g']; // Default units

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.imageUrl.isNotEmpty
                ? Image.network(
              widget.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : SizedBox(
              height: 200,
              child: Placeholder(),
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${widget.price}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Units',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildDropdownUnitBox(),
                SizedBox(width: 10),
                _buildManualInputBox(),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...selectedUnits.map((unit) => _buildUnitBox(unit)),
                ...manualUnits.map((unit) => _buildUnitBox(unit)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveData(widget.name),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownUnitBox() {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
          if (newValue != null) {
            selectedUnits.add(newValue);
          }
        });
      },
      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildManualInputBox() {
    String manualInput = '';

    return SizedBox(
      width: 160,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Manual Input'),
              onChanged: (value) {
                manualInput = value;
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    manualUnits.add(value);
                    dropdownItems.add(value); // Add to dropdown items
                  });
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (manualInput.isNotEmpty) {
                setState(() {
                  manualUnits.add(manualInput);
                  dropdownItems.add(manualInput); // Add to dropdown items
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitBox(String unit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            unit,
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (selectedUnits.contains(unit)) {
                  selectedUnits.remove(unit);
                }
                if (manualUnits.contains(unit)) {
                  manualUnits.remove(unit);
                }
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  void _saveData(String productName) async {
    if (selectedUnits.isNotEmpty || manualUnits.isNotEmpty) {
      try {
        // Fetch product document from products collection
        QuerySnapshot productQuerySnapshot = await FirebaseFirestore.instance.collection('products').where('name_description', isEqualTo: productName).get();
        if (productQuerySnapshot.docs.isNotEmpty) {
          // Get the first document (assuming there's only one product with the given name)
          DocumentSnapshot productSnapshot = productQuerySnapshot.docs.first;
          // Add product details and units to Firestore
          await FirebaseFirestore.instance.collection('units').add({
            'product_id': productSnapshot.id,
            'product_name': productName,
            'units': [...selectedUnits, ...manualUnits],
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Data saved successfully')),
          // );

          ResponsiveInfo.showAlertDialog(context, "", "Data saved successfully");


        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Product not found')),
          // );

          ResponsiveInfo.showAlertDialog(context, "", "Product not found");
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to save data: $e')),
        // );

        ResponsiveInfo.showAlertDialog(context, "", "Failed to save data");
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please select units')),
      // );

      ResponsiveInfo.showAlertDialog(context, "", "Please select units");
    }
  }
}