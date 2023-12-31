import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrdersModelAdvanced with ChangeNotifier {
  final String productId;
  final String cartid;
  final String quantity;
  OrdersModelAdvanced(
      {
      required this.productId,
        required this.cartid,
      required this.quantity,
});
}
