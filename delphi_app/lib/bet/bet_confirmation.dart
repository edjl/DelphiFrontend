import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/option.dart';
import '../model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "option_service.dart";

class BetConfirmation extends StatelessWidget {
  final Option option;
  final bool isBuyYes;
  final String eventName;

  BetConfirmation(
      {required this.option, required this.eventName, required this.isBuyYes});
  TextEditingController numberController = TextEditingController();

  Future<bool> _buyOption(int optionAmount) async {
    try {
      final buySucceeded = await OptionService.buyOption(
          (UserProfile().userId.value == -1)
              ? null
              : UserProfile().userId.value,
          eventName,
          option.title,
          optionAmount);

      if (!buySucceeded) {
        throw Exception();
      }
      return true;
    } catch (e) {
      // Handle errors
      print("Error buying option: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return showDialog<void>(
    // context: context,
    // barrierDismissible: true,
    // builder: (BuildContext context) {
    return AlertDialog(
      title: Text('How many shares of ${option.title} do you want to buy?'),
      // barrierDismissable: true,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: option.imageLink ?? "https://i.imgur.com/dRk6nBk.jpeg",
              width: 29,
              height: 29,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),
            Text(
              option.title,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              "${(isBuyYes ? "YES" : "NO")} @ ${(isBuyYes ? option.positivePrice : option.negativePrice)}",
              style: TextStyle(
                fontSize: 18,
                color: isBuyYes ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: numberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter amount of options',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        TextButton(
          onPressed: () {
            int optionAmount = int.parse(numberController.text);
            _buyOption(optionAmount).then((buySucceeded) {
              if (buySucceeded) {
                Navigator.of(context)
                    .pop(); // TODO: notify user when failed buy
              }
            });
          },
          child: const Text("Buy"),
        )
      ]),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
    // }
  }
}
