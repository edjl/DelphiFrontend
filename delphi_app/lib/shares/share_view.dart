import 'package:delphi_app/shares/share_controller.dart';
import 'package:flutter/material.dart';
import './share_model.dart';

// ignore: must_be_immutable
class ShareView extends StatelessWidget {
  final ShareModel share;
  ShareController shareController = ShareController();

  ShareView({super.key, required this.share});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Text(share.betQuestion),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(share.betAnswer),
                      Text('currently ${share.currentValue.toString()} c'),
                      Text('Bought on ${share.purchaseDate.toIso8601String()}'),
                      Text('Ends ${share.endDate.toIso8601String()}'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(shareController.getPercentChange(share)),
                      Text(shareController.getCreditChange(share)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
