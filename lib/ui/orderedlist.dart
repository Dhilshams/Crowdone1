import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String id;
  String name;
  String status;
  int price;
  int units;

  Product({required this.id, required this.name, required this.status, required this.price, required this.units});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Status Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderedListScreen(),
    );
  }
}

class OrderedListScreen extends StatefulWidget {
  @override
  _OrderedListScreenState createState() => _OrderedListScreenState();
}

class _OrderedListScreenState extends State<OrderedListScreen> {
  String filterValue = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ordered').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Product> products = [];

          snapshot.data!.docs.forEach((DocumentSnapshot document) {
            Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

            if (data != null) {
              String id = document.id;
              String name = data['name'] ?? '';
              String status = data['status'] ?? 'ordered';
              int price = int.tryParse(data['price'] ?? '') ?? 0; // Parse string to int, default to 0 if parsing fails
              int units = int.tryParse(data['units'] ?? '') ?? 0; // Parse string to int, default to 0 if parsing fails
              products.add(Product(id: id, name: name, status: status, price: price, units: units));
            }
          });

          // Filter products based on selected status
          List<Product> filteredProducts = filterValue == 'All'
              ? products
              : products.where((product) => product.status == filterValue).toList();

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(filteredProducts[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${filteredProducts[index].status}'),
                    Text('Price: ${filteredProducts[index].price}'),
                    Text('Units: ${filteredProducts[index].units}'),
                  ],
                ),
                trailing: DropdownButton<String>(
                  value: filteredProducts[index].status,
                  onChanged: (String? newValue) {
                    setState(() {
                      filteredProducts[index].status = newValue!;
                      _updateStatus(filteredProducts[index].id, newValue);
                    });
                  },
                  items: <String>['ordered', 'pending', 'delivered']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Status'),
          content: DropdownButton<String>(
            value: filterValue,
            onChanged: (String? newValue) {
              setState(() {
                filterValue = newValue!;
                Navigator.of(context).pop();
              });
            },
            items: <String>['All', 'ordered', 'pending', 'delivered']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _updateStatus(String productId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('ordered').doc(productId).update({'status': newStatus});
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
