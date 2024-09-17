import 'package:flutter/material.dart';
import 'package:flutter_phone_dialer/flutter_phone_dialer.dart';
import 'package:frs/constants/pallette.dart';

class CallingIcon extends StatelessWidget {
  final String path;
  final String number;
  final String org;
  const CallingIcon(
      {super.key, required this.path, required this.number, required this.org});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () async {
            await FlutterPhoneDialer.dialNumber(number);
          },
          style: const ButtonStyle(
            enableFeedback: true,
          ),
          icon: Image.asset(
            'lib/assets/icons/$path',
            height: 64,
          ),
        ),
        Text(
          org,
          style: TextStyling().stylep1.copyWith(color: kblack),
        ),
      ],
    );
  }
}
