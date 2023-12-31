import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_stripe/consts/cache%20helper.dart';
import 'package:payment_stripe/payment/stripe_payment/keys.dart';
import 'package:payment_stripe/providers/cart_provider.dart';
import 'package:payment_stripe/providers/orderprovider.dart';
import 'package:payment_stripe/providers/products_provider.dart';
import 'package:payment_stripe/providers/theme_provider.dart';
import 'package:payment_stripe/providers/user_provider.dart';
import 'package:payment_stripe/providers/viewed_recently_provider.dart';
import 'package:payment_stripe/providers/wishlist_provider.dart';
import 'package:payment_stripe/root_screen.dart';
import 'package:payment_stripe/screens/auth/forgot_password.dart';
import 'package:payment_stripe/screens/auth/login.dart';
import 'package:payment_stripe/screens/auth/register.dart';
import 'package:payment_stripe/screens/inner_screen/orders/orders_screen.dart';
import 'package:payment_stripe/screens/inner_screen/product_details.dart';
import 'package:payment_stripe/screens/inner_screen/viewed_recently.dart';
import 'package:payment_stripe/screens/inner_screen/wishlist.dart';
import 'package:payment_stripe/screens/search_screen.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=ApiKeys.pusblishableKey;
  await CachHelper.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductsProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishlistProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewedProdProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return Orderprovider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'ShopSmart EN',
                    theme: Styles.themeData(
                        isDarkTheme: themeProvider.getIsDarkTheme,
                        context: context),
                    home: const RootScreen(),
                    routes: {
                      RootScreen.routeName: (context) => const RootScreen(),
                      ProductDetailsScreen.routName: (context) =>
                      const ProductDetailsScreen(),
                      WishlistScreen.routName: (context) => const WishlistScreen(),
                      ViewedRecentlyScreen.routName: (context) =>
                      const ViewedRecentlyScreen(),
                      RegisterScreen.routName: (context) => const RegisterScreen(),
                      LoginScreen.routeName: (context) => const LoginScreen(),
                      OrdersScreenFree.routeName: (context) =>
                      const OrdersScreenFree(),
                      ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                      SearchScreen.routeName: (context) => const SearchScreen(),
                    },
                  );
                }),
          );
        });
  }
}
