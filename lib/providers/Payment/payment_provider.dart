import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainStateNotifier extends StateNotifier<MainState> {
  MainStateNotifier(this.ref) : super(MainState.initial);

  TransactionDetailModel? transactionDetailModel;

  final Ref ref;

  Future<void> startPayment(EasyUpiPaymentModel model) async {
    state = MainState.loading;
    try {
      //
      final res = await EasyUpiPaymentPlatform.instance.startPayment(model);
      if (res != null) {
        transactionDetailModel = res;
        state = MainState.success;
      } else {
        state = MainState.error;
      }
    } on EasyUpiPaymentException {
      state = MainState.error;
    }
  }

  void savePaymentData(EasyUpiPaymentModel model) {}
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
