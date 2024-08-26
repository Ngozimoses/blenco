import 'package:flutter/material.dart';
class CartPage extends StatelessWidget {
  final List<Map<String, String>> cartItems;
  final Function(int) removeFromCart;

  CartPage({required this.cartItems, required this.removeFromCart});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      String priceWithoutDollar = item['price']!.replaceAll('\$', ''); // Remove dollar sign
      return sum + double.parse(priceWithoutDollar);
    });

    return Scaffold(

      body: Column(
        children: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Cart',style: TextStyle(fontSize: 24),),
            ],
          ),
        ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) => CartItem(
                name: cartItems[i]['name']!,
                imageUrl: cartItems[i]['image']!,
                price: cartItems[i]['price']!,
                index: i,
                removeFromCart: removeFromCart,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20)),
                Text(
                  '\$$totalPrice',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text('Checkout'),
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String price;
  final int index;
  final Function(int) removeFromCart;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.index,
    required this.removeFromCart,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(imageUrl),
      title: Text(name),
      subtitle: Text(price),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          removeFromCart(index);
        },
      ),
    );
  }
}
