import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payment_stripe/models/order_model.dart';
import 'package:payment_stripe/providers/orderprovider.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_bag.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    final orderprovider = Provider.of<Orderprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Placed orders',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<OrdersModelAdvanced>>(
              future: orderprovider.fetchorder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(snapshot.error.toString()),
                  );
                } else if (!snapshot.hasData || orderprovider.getorders.isEmpty) {
                  return EmptyBagWidget(
                      imagePath: AssetsManager.orderBag,
                      title: 'No orders has been placed yet',
                      subtitle: '',
                      buttonText: 'Shop now');
                }
                return ListView.separated(
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                        child: OrdersWidgetFree(
                            ordersModelAdvanced: orderprovider.getorders[index]),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: snapshot.data!.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}
