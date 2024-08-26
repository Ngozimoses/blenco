import 'package:flutter/material.dart';
class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Row(
              children: [
                Text('Order Tracking',style: TextStyle(fontSize: 24),),
              ],
            ),
          ),
            Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Processing'),
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: Colors.blue),
              title: Text('Shipped'),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.orange),
              title: Text('Out for Delivery'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Delivered'),
            ),
            Divider(),
            Text('Tracking Number: 1234567890', style: TextStyle(fontSize: 16)), // Replace with dynamic tracking number
            Text('Estimated Delivery: Aug 30, 2024', style: TextStyle(fontSize: 16)), // Replace with dynamic delivery date
          ],
        ),
      ),
    );
  }
}
