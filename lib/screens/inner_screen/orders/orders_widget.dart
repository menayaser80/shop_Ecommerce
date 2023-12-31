import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:payment_stripe/models/order_model.dart';
import '../../../widgets/subtitle_text.dart';
import '../../../widgets/title_text.dart';

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key, required this.ordersModelAdvanced});
  final OrdersModelAdvanced ordersModelAdvanced;
  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  bool isLoading = false;

  var database=FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitlesTextWidget(
                          label: widget.ordersModelAdvanced.productId,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 22,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      TitlesTextWidget(
                        label: 'quantity:  ',
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "${widget.ordersModelAdvanced.cartid} ",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "Qty: ${widget.ordersModelAdvanced.quantity}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   width: 150.0,
                  //   height: 40.0,
                  //   color: Colors.blue,
                  //   child: MaterialButton(
                  //     onPressed: () async {
                  //       var auth = FirebaseAuth.instance.currentUser?.uid;
                  //       print(auth);
                  //
                  //       print(widget.ordersModelAdvanced.price);
                  //       await PaymentManager.makePayment(double.
                  //       parse(widget.ordersModelAdvanced.price), "EGP")
                  //             .then((value) async{
                  //         await database.doc(auth.toString()).collection("pay_data").add(
                  //             {
                  //               "id" : widget.ordersModelAdvanced.productId,
                  //
                  //             });
                  //       navigateTo(context, RootScreen());
                  //     });
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.monetization_on_rounded),
                  //         SizedBox(
                  //           width: 15,
                  //         ),
                  //         Text(
                  //           'Payment',
                  //           style: TextStyle(
                  //             fontSize: 15.0,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
