import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_stripe/payment/stripe_payment/keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(double amount, String currency) async {
    try {
      print(amount);
      String clientSecret =
          await _getClientSecret((amount * 100).toStringAsFixed(0), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    try {
      print(amount);
      Dio dio = Dio();
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: {
          'amount': amount,
          'currency': currency,
        },
      );
      print('object');
      return response.data["client_secret"];
    } catch (e) {
      if(e is DioException){
        print(e.response?.data);
      }
      rethrow;
    }
  }
}
