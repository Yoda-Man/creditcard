import 'package:custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../models/card.dart';

void showCard(BuildContext context) {
  SlideDialog.showSlideDialog(
    context: context,
    backgroundColor: Colors.white,
    pillColor: Colors.yellow,
    transitionDuration: const Duration(milliseconds: 300),
    child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 5,
            top: 10,
          ),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          trailing: IconButton(
            icon: const Icon(Icons.credit_card, color: Color(0xFF100887)),
            onPressed: () {},
          ),
          title: const Text("Card Details",
              style: TextStyle(color: Color(0xFF100887), fontSize: 20)),
          // tileColor: ThemeColors.white,
        ),
        const Divider(
          color: Colors.lightBlueAccent,
          endIndent: 15,
          indent: 15,
        ),
        CreditCardWidget(
          cardNumber: currentCard.CardNumber,
          expiryDate: currentCard.ExpieryDate,
          cardHolderName: currentCard.FullName,
          cvvCode: currentCard.CVV,
          obscureCardCvv: false,
          obscureCardNumber: false,
          showBackView: false, //true when you want to show cvv(back) view
          width: 324,
          height: 204,
          onCreditCardWidgetChange: (CreditCardBrand
              brand) {}, // Callback for anytime credit card brand is changed
        ),
      ],
    ),
  );
}
