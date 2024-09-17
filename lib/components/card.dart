import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frs/constants/pallette.dart';

class MyCard extends StatelessWidget {
  final String text;
  final String description;
  final Icon icon;
  const MyCard(
      {super.key,
      required this.text,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              icon,
              Text(
                text,
                style: TextStyling().styleh1.copyWith(color: kblack),
              ),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
