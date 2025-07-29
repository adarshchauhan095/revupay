import 'package:get/get.dart';

class PaymentController extends GetxController {
  Future<bool> processPayment({required double amount, required String description}) async {
    // Simulate payment process
    await Future.delayed(Duration(seconds: 2));
    return true; // Return false to simulate failure
  }
}
