import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Account Settings',style: TextStyle(fontSize: 24),),
            ],
          ),
        ),
          ListTile(
            title: Text('Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to Profile Information page
            },
          ),
          ListTile(
            title: Text('Order History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to Order History page
            },
          ),
          ListTile(
            title: Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to Payment Methods page
            },
          ),
          ListTile(
            title: Text('Notification Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to Notification Settings page
            },
          ),
        ],
      ),
    );
  }
}
