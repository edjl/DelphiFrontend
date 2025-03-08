import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/option.dart';
import '../model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "option_service.dart";
import '../shared_services/sound_effects.dart';

class BetConfirmation extends StatefulWidget {
  final Option option;
  final bool isBuyYes;
  final String eventName;

  const BetConfirmation({
    required this.option,
    required this.eventName,
    required this.isBuyYes,
    Key? key,
  }) : super(key: key);

  @override
  _BetConfirmationState createState() => _BetConfirmationState();
}

class _BetConfirmationState extends State<BetConfirmation> {
  final TextEditingController numberController = TextEditingController();
  bool isBuyEnabled = true;

  int get maxAllowed {
    int price = widget.isBuyYes
        ? widget.option.positivePrice
        : widget.option.negativePrice;
    if (price <= 0) return 0;
    return UserProfile().balance.value ~/ price;
  }

  @override
  void initState() {
    super.initState();
    numberController.text = '${(maxAllowed < 50) ? maxAllowed : 50}';
    numberController.addListener(_validateInput);
  }

  @override
  void dispose() {
    numberController.removeListener(_validateInput);
    numberController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      int? enteredValue = int.tryParse(numberController.text);
      isBuyEnabled = enteredValue != null &&
          enteredValue >= 1 &&
          enteredValue <= maxAllowed;
    });
  }

  void _showFailureMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase failed. Please try again later.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _buyOption(int optionAmount) async {
    try {
      final buySucceeded = await OptionService.buyOption(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        widget.eventName,
        widget.option.title,
        optionAmount,
      );

      if (!buySucceeded) {
        throw Exception();
      }

      await SoundEffects.playMoneySound();
      return true;
    } catch (e) {
      print("Error buying option: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'How many shares of ${widget.option.title} to buy?',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: widget.option.imageLink ??
                    "https://i.imgur.com/dRk6nBk.jpeg",
                width: 29,
                height: 29,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.option.title,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // const Spacer(),
              Text(
                "${widget.isBuyYes ? "YES" : "NO"} @ ${(widget.isBuyYes ? widget.option.positivePrice : widget.option.negativePrice)}",
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: widget.isBuyYes ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            controller: numberController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Amount (Max: $maxAllowed)',
              errorText: (numberController.text.isNotEmpty &&
                      (int.tryParse(numberController.text) == null ||
                          int.parse(numberController.text) < 1 ||
                          int.parse(numberController.text) > maxAllowed))
                  ? (maxAllowed > 0
                      ? 'Please enter a value between 1 and ${maxAllowed}'
                      : 'Not enough credits')
                  : null,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                int enteredValue = int.tryParse(value) ?? 0;
                if (enteredValue < 1) {
                  numberController.text = '1';
                } else if (enteredValue > maxAllowed) {
                  numberController.text = maxAllowed.toString();
                }
              }
            },
            onTap: () {
              if (numberController.text.isEmpty) {
                numberController.text =
                    '${(maxAllowed < 50) ? maxAllowed : 50}';
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.blue,
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: isBuyEnabled
                    ? () async {
                        int optionAmount = int.parse(numberController.text);

                        int amountBet = optionAmount *
                            (widget.isBuyYes
                                ? widget.option.positivePrice
                                : widget.option.negativePrice);
                        UserProfile().makeBet(amountBet);

                        bool buySucceeded = await _buyOption(
                            widget.isBuyYes ? optionAmount : -1 * optionAmount);
                        if (!buySucceeded) {
                          UserProfile().refundBet(amountBet);
                          _showFailureMessage(context);
                        }
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isBuyYes ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                    side: const BorderSide(color: Colors.black, width: 0.5),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const SizedBox(
                  width: 35,
                  child: Center(
                    child: Text(
                      'Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
