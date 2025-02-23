import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/share.dart';
import '../model/user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "../bet/option_service.dart";

class SellConfirmation extends StatefulWidget {
  final Share share;

  const SellConfirmation({
    required this.share,
    Key? key,
  }) : super(key: key);

  @override
  _SellConfirmationState createState() => _SellConfirmationState();
}

class _SellConfirmationState extends State<SellConfirmation> {
  final TextEditingController numberController = TextEditingController();
  bool isSellEnabled = true;

  @override
  void initState() {
    super.initState();
    numberController.text = '${widget.share.shares.abs()}';
    numberController.addListener(_validateInput);
  }

  @override
  void dispose() {
    numberController.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      int? enteredValue = int.tryParse(numberController.text);
      isSellEnabled = enteredValue != null &&
          enteredValue >= 1 &&
          enteredValue <= widget.share.shares.abs();
    });
  }

  void _showFailureMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sale failed. Please try again later.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _sellShare(int optionAmount) async {
    try {
      final sellSucceeded = await OptionService.sellShares(
        (UserProfile().userId.value == -1) ? null : UserProfile().userId.value,
        widget.share.eventName,
        widget.share.optionName,
        widget.share.purchaseDateTime,
        optionAmount,
      );

      if (!sellSucceeded) {
        throw Exception();
      } else {}
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
          '${widget.share.eventName}',
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
                imageUrl: widget.share.imageLink ??
                    "https://i.imgur.com/dRk6nBk.jpeg",
                width: 29,
                height: 29,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.share.optionName,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Text(
                "${widget.share.shares.abs()} ${widget.share.shares > 0 ? "YES" : "NO"} shares @ ${widget.share.price} c",
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: widget.share.shares > 0 ? Colors.green : Colors.red,
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
              labelText: 'Amount (Max: ${widget.share.shares.abs()})',
              errorText: (numberController.text.isNotEmpty &&
                      (int.tryParse(numberController.text) == null ||
                          int.parse(numberController.text) < 1 ||
                          int.parse(numberController.text) >
                              widget.share.shares.abs()))
                  ? (widget.share.shares.abs() > 0
                      ? 'Please enter a value between 1 and ${widget.share.shares.abs()}'
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
                } else if (enteredValue > widget.share.shares.abs()) {
                  numberController.text = widget.share.shares.abs().toString();
                }
              }
            },
            onTap: () {
              if (numberController.text.isEmpty) {
                numberController.text = widget.share.shares.abs().toString();
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
                onPressed: isSellEnabled
                    ? () async {
                        int optionAmount = int.parse(numberController.text);

                        int amountGain =
                            optionAmount * widget.share.currentPrice;
                        int initialAmount = optionAmount * widget.share.price;
                        UserProfile().sellShare(initialAmount, amountGain,
                            optionAmount == widget.share.shares.abs());

                        bool sellSucceeded = await _sellShare(optionAmount);
                        if (!sellSucceeded) {
                          UserProfile().refundSale(initialAmount, amountGain,
                              optionAmount == widget.share.shares.abs());
                          _showFailureMessage(context);
                          Navigator.pop(context, false);
                        }
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.share.shares < 0 ? Colors.green : Colors.red,
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
                      'Sell',
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
