import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistoryScreen extends StatefulWidget {
  final String customerId;

  OrderHistoryScreen({required this.customerId});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse('/order/getCustomerOrders/${widget.customerId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Order> fetchedOrders = List.from(data).map((json) => Order.fromJson(json)).toList();

      setState(() {
        orders = fetchedOrders;
      });
    } else {
      // Handle error response
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Order ID: ${order.orderId}'),
              subtitle: Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle tapping on an order item
              },
            ),
          );
        },
      ),
    );
  }
}

class Order {
  final String orderId;
  final double totalAmount;

  Order({
    required this.orderId,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      totalAmount: json['totalAmount'],
    );
  }
}
