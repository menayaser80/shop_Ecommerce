import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_stripe/consts/app_colors.dart';
import 'package:payment_stripe/providers/cart_provider.dart';
import 'package:payment_stripe/root_screen.dart';
import 'package:payment_stripe/screens/cart/cart_widget.dart';
import 'package:payment_stripe/screens/loading_manager.dart';
import 'package:payment_stripe/services/assets_manager.dart';
import 'package:payment_stripe/services/my_app_functions.dart';
import 'package:payment_stripe/widgets/empty_bag.dart';
import 'package:payment_stripe/widgets/title_text.dart';
import 'package:provider/provider.dart';


import 'package:uuid/uuid.dart';

import '../../payment/stripe_payment/payment_manager.dart';
import '../../providers/products_provider.dart';
import '../../providers/user_provider.dart';
import 'bottom_checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  var database=FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  var point ;
  get_point()async {
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).snapshots()
        .listen((event) {
      setState(() {
        point = event["points"];
      });
    });
  }
  @override
  void initState() {
    get_point();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<ProductsProvider>(context);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return cartProvider.getCartitems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Your cart is empty",
              subtitle:
                  "Looks like your cart is empty add something and make me happy",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomSheetWidget(function: () async {
              var money =(cartProvider.getTotal(productsProvider: productsProvider).toInt());
              var auth = FirebaseAuth.instance.currentUser?.uid;
              var mypoints =await database.doc(auth.toString()).get();
              print(mypoints["points"]);
              List p = [];
              int _newpoints = 0;
              cartProvider.getCartitems.values.forEach((element) {
                p.add({"p_id":element.productId,
                "p_q" : element.quantity,
                "p_c":element.cartId});

              });
              await PaymentManager.makePayment(double.
                parse(money.toString()), "EGP")
                    .then((value) async{
                  await database.doc(auth.toString()).collection("pay_data").add(
                      {
                        "data" : p,"all_money": money.toString(),"hala" : 1 ,
                      }).whenComplete(() async{
                    cartProvider.getCartitems.values.forEach((element)async {
                      await cartProvider.removeCartItemFromFirestore(
                          productId:element.productId ,
                          cartId:element.cartId ,
                          qty: element.quantity);
                    });

                    await database.doc(auth.toString()).update({"points" : point+10});
                    showToast(message: 'Payment Succeded');
                    navigateTo(context, RootScreen());
                  });
                });



            }),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitlesTextWidget(
                  label: "Cart (${cartProvider.getCartitems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Clear cart?",
                      fct: () async {
                        cartProvider.clearCartFromFirebase();
                        // cartProvider.clearLocalCart();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            body: LoadingManager(
              isLoading: _isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartProvider.getCartitems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: cartProvider.getCartitems.values
                                  .toList()[index],
                              child: const CartWidget());
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          );
  }

  Future<void> placeOrderAdvanced({
    required CartProvider cartProvider,
    required ProductsProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        _isLoading = true;
      });
      cartProvider.getCartitems.forEach((key, value) async {
        final getCurrProduct = productProvider.findByProdId(value.productId);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .doc(orderId)
            .set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          "productTitle": getCurrProduct!.productTitle,
          'price': double.parse(getCurrProduct.productPrice) * value.quantity,
          'totalPrice':
              cartProvider.getTotal(productsProvider: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.productImage,
          'userName': userProvider.getUserModel!.userName,
          'orderDate': Timestamp.now(),
        });
      });
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
    } catch (e) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
