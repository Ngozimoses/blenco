import 'package:flutter/material.dart';
class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Payment',style: TextStyle(fontSize: 24),),
              ],
            ),
          ),
            Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Product 1 x 1: \$29.99'), // Replace with dynamic order data
            Text('Product 2 x 2: \$59.98'), // Replace with dynamic order data
            Divider(),
            Text('Total: \$89.97', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Replace with dynamic total
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Credit Card'),
              leading: Radio(
                value: 'Credit Card',
                groupValue: 'selectedMethod', // Handle selection state
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('PayPal'),
              leading: Radio(
                value: 'PayPal',
                groupValue: 'selectedMethod', // Handle selection state
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text('Pay \$89.97'), // Replace with dynamic total
                onPressed: () {
                  // Handle payment processing
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
