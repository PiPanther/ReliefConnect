import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frs/models/campaign.dart';

class MainStateNotifier extends StateNotifier<MainState> {
  MainStateNotifier(this.ref) : super(MainState.initial);

  final Ref ref;
  TransactionDetailModel? transactionDetailModel;

  Future<void> completePaymentWithTransaction(EasyUpiPaymentModel model,
      String campaignId, double donationAmount) async {
    state = MainState.loading;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Start the UPI payment process
      final res = await EasyUpiPaymentPlatform.instance.startPayment(model);

      if (res != null && res == "SUCCESS") {
        transactionDetailModel = res;

        // Transaction to update Firestore atomically
        await firestore.runTransaction((transaction) async {
          DocumentReference campaignDoc =
              firestore.collection('campaigns').doc(campaignId);

          // Fetch the campaign document inside the transaction
          DocumentSnapshot campaignSnapshot =
              await transaction.get(campaignDoc);

          if (campaignSnapshot.exists) {
            Campaign campaign = Campaign.fromMap(
                campaignSnapshot.data() as Map<String, dynamic>);

            // Calculate the new donation amount
            double updatedAmount = 50 + donationAmount;

            // Update the campaign's current amount in Firestore within the transaction
            transaction.update(campaignDoc, {'currentAmount': updatedAmount});
            print(
                'Campaign updated successfully with new amount: $updatedAmount');
          } else {
            throw Exception('Campaign not found, rolling back transaction.');
          }
        });

        state = MainState.success;
      } else {
        state = MainState.error;
      }
    } on EasyUpiPaymentException catch (e) {
      print("Payment error: $e");
      state = MainState.error;
    } catch (e) {
      print("Unknown error during transaction: $e");
      state = MainState.error;
    }
  }

  void savePaymentData(EasyUpiPaymentModel model) {
    // You can implement this function to store payment details locally or remotely if needed
  }
}

final mainStateProvider =
    StateNotifierProvider.autoDispose<MainStateNotifier, MainState>(
  (ref) {
    return MainStateNotifier(ref);
  },
);

enum MainState {
  initial,
  loading,
  success,
  error,
}
