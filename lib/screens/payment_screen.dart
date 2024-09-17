import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/components/payment_details.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/campaign.dart';
import 'package:frs/providers/Payment/payment_provider.dart';

class PayymentScreen extends ConsumerWidget {
  final Campaign campaign;
  PayymentScreen({super.key, required this.campaign});

  final payeeVpaController = TextEditingController();
  final payeeNameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> startPayment(
      BuildContext context, EasyUpiPaymentModel model) async {
    try {
      final paymentResult =
          await EasyUpiPaymentPlatform.instance.startPayment(model);
      if (paymentResult != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PaymentDetailsDialog(
              amount: paymentResult.amount ?? "0.0",
              approvalRefNo: paymentResult.approvalRefNo ?? '',
              transactionId: paymentResult.transactionId ?? '',
              transactionRefId: paymentResult.transactionRefId ?? '',
              statusCode: paymentResult.responseCode ?? '',
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Payment Result"),
              content: const Text("No result received from payment."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      if (e.code == "Cancelled") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Payment Cancelled"),
              content: const Text("Transaction was cancelled by the user."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Payment Failed"),
              content: Text('Error: ${e.message ?? 'Unknown error'}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Payment Failed"),
            content: Text('Error: ${e.toString()}'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    payeeNameController.text = campaign.firmName;
    payeeVpaController.text = campaign.upi;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kblue,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(mainStateProvider);
          return AbsorbPointer(
            absorbing: state == MainState.loading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 36),
                        TextFormField(
                          enabled: false,
                          controller: payeeNameController,
                          decoration: const InputDecoration(
                            labelText: 'Payee Name',
                            counterText: '',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          enabled: false,
                          controller: payeeVpaController,
                          decoration: const InputDecoration(
                            labelText: 'Payee UPI ID',
                            counterText: '',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid UPI ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            counterText: '',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final doubleValue = double.tryParse(value ?? '');
                            if (value == null ||
                                value.isEmpty ||
                                doubleValue == null) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            counterText: '',
                          ),
                          keyboardType: TextInputType.name,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 36),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(kpink)),
                          onPressed: () async {
                            EasyUpiPaymentModel model = EasyUpiPaymentModel(
                              payeeVpa: payeeVpaController.text,
                              payeeName: payeeNameController.text,
                              amount: double.parse(amountController.text),
                              description: descriptionController.text,
                            );

                            await startPayment(context, model);
                          },
                          child: Text(
                            'Pay Now',
                            style: TextStyling().styleh3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
