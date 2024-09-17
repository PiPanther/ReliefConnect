import 'package:flutter/material.dart';

class PaymentDetailsDialog extends StatelessWidget {
  final String amount;
  final String approvalRefNo;
  final String transactionId;
  final String transactionRefId;
  final String statusCode;

  PaymentDetailsDialog({
    required this.amount,
    required this.approvalRefNo,
    required this.transactionId,
    required this.transactionRefId,
    required this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payment Details'),
      content: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Amount:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(amount),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Approval Ref No:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(approvalRefNo),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Transaction ID:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(transactionId),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Transaction Ref ID:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(transactionRefId),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Status Code:'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(statusCode),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).popAndPushNamed('/homescreen'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
