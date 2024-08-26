import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/payment.dart';
import 'package:untitled1/setting.dart';

import 'bloc/bloc_bloc.dart';
import 'bloc/repository.dart';
import 'home.dart';
import 'orders.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> cartItems = [];

  void addToCart(String name, String imageUrl, String price) {
    setState(() {
      cartItems.add({'name': name, 'image': imageUrl, 'price': price});
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userRepository: userRepository),
        ),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          final themeMode = context.read<AuthBloc>().themeMode ?? ThemeMode.system;
          _updateSystemNavigationBarColor(themeMode);
        },
        builder: (context, state) {
          final ThemeData darkThemeWithBlue = ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
            ),
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
          );

          final themeMode = context.read<AuthBloc>().themeMode ?? ThemeMode.system;

          return MaterialApp(debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: darkThemeWithBlue, // Apply the custom dark theme with blue
            themeMode: themeMode,
            home: state is Authenticated
                ?  HomePage(token: state.token,

          )
                : LoginScreen(),
            routes: {
              '/cart': (context) => CartPage(
                cartItems: cartItems,
                removeFromCart: removeFromCart,
              ),
              '/Home': (context) => HomePage( token: '',),
              '/OrderTrackingPage': (context) => OrderTrackingPage(),
              '/AccountSettingsPage': (context) => AccountSettingsPage(),
              '/Payment': (context) => PaymentPage(),
            },
          );
        },
      ),
    );
  }

  void _updateSystemNavigationBarColor(ThemeMode themeMode) {
    final systemNavigationBarColor = themeMode == ThemeMode.dark ? Colors.blue : Colors.white;
    final systemNavigationBarIconBrightness =
    themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: systemNavigationBarColor,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
    ));

    // Debug print to verify the correct color and brightness are applied
    print('System Navigation Bar updated to color: $systemNavigationBarColor, brightness: $systemNavigationBarIconBrightness');
  }
}



class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to the home page when authentication is successful
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(token: state.token)));
          } else if (state is Unauthenticated) {
            // Show an error message if authentication failed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(hintText: 'Email')),
            TextField(controller: usernameController, decoration: InputDecoration(hintText: 'Username')),
            TextField(controller: passwordController, decoration: InputDecoration(hintText: 'Password')),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  RegisterEvent(
                    email: emailController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}



class HomePage extends StatefulWidget {


  HomePage({ required String token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final List<Map<String, String>> products = [
    {
      'name': 'Product 1',
      'image': 'https://cdn.pixabay.com/photo/2023/08/16/10/09/oranges-8193789_1280.jpg',
      'price': '\$29.99',
    },
    {
      'name': 'Product 2',
      'image': 'https://cdn.pixabay.com/photo/2022/07/10/20/15/raspberries-7313700_1280.jpg',
      'price': '\$39.99',
    },
    {
      'name': 'Product 3',
      'image': 'https://cdn.pixabay.com/photo/2023/12/09/21/03/pineapple-8440180_1280.jpg',
      'price': '\$49.99',
    },
  ];
  List<Map<String, String>> cartItems = [];

  void addToCart(String name, String imageUrl, String price) {
    setState(() {
      cartItems.add({'name': name, 'image': imageUrl, 'price': price});
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }
  void _updateSystemNavigationBarColor(ThemeMode themeMode) {
    final systemNavigationBarColor = themeMode == ThemeMode.dark ? Colors.blue : Colors.white;
    final systemNavigationBarIconBrightness =
    themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: systemNavigationBarColor,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
    ));

    // Debug print to verify the correct color and brightness are applied
    print('System Navigation Bar updated to color: $systemNavigationBarColor, brightness: $systemNavigationBarIconBrightness');
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        leading:SizedBox(width: 0,),
        elevation: 0,  actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
          },
        ),
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: () {
            if (Theme.of(context).brightness == Brightness.light) {
              context.read<AuthBloc>().add(DarkModeEvent());
            } else {
              context.read<AuthBloc>().add(LightModeEvent());
            }
          },
        ),
      ],
        title: Row(
          children: [Padding(
            padding: const EdgeInsets.only(top: 8.0,bottom: 8,right: 8,),
            child: Icon(Icons.deck,color: Colors.cyan,),
          ),
            Text(
              'Blenco',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

      ),
      body: PageView(scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductItem(
                name: products[i]['name']!,
                imageUrl: products[i]['image']!,
                price: products[i]['price']!,
                addToCart:addToCart,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
          CartPage(
            cartItems: cartItems,
            removeFromCart: (index) {
              setState(() {
               cartItems.removeAt(index);
              });
            },
          ),
          OrderTrackingPage(),
          AccountSettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon:
          Stack(
            children: [
                           Icon(Icons.shopping_cart, color: Colors.black),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                    cartItems.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String price;
  final Function(String, String, String) addToCart;

  ProductItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text('Add to Cart', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  addToCart(name, imageUrl, price);
                },
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.blue),
                onPressed: () {
                  addToCart(name, imageUrl, price);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
