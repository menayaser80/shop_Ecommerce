import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_stripe/models/order_model.dart';

class Orderprovider with ChangeNotifier{
final List<OrdersModelAdvanced>orders=[];
List<OrdersModelAdvanced>get getorders=>orders;
Future<List<OrdersModelAdvanced>>fetchorder()async
{
  final auth=FirebaseAuth.instance;
  User?user=auth.currentUser;
  var uid=user!.uid;
  try{
    await FirebaseFirestore.instance.collection('pay_data')
        .where('userId',isEqualTo: uid)
        .get().then((ordersnapshot) {
      orders.clear();
      for(var element in ordersnapshot.docs)
        {
          orders.insert(0,OrdersModelAdvanced(
            productId:element.get('p_id'),
            cartid:element.get('p_c') ,
            quantity:element.get('p_q'),
          ));
        }
    });
    return orders;
  }catch(e)
  {
    rethrow;
  }
}

}