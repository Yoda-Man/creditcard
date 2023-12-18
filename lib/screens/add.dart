import 'package:country_picker/country_picker.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/card.dart';
import '../utils/cardmonthinputformatter.dart';
import '../utils/cardnumberinputformatter.dart';
import '../utils/cardutils.dart';
import '../utils/enum.dart';
import '../widgets/bottomnavigationbar.dart';
import '../widgets/search_box.dart';
import '../widgets/show_card.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController expieryDateController = TextEditingController();
  TextEditingController countryOfIssueController = TextEditingController();

  CardType cardType = CardType.Invalid;

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNumber();
      },
    );
    if (cards.isEmpty) loadbackup();
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  void getCardTypeFrmNumber() {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      onItemTapped(context);
    });
  }

  ListView displaySession() {
    return ListView.builder(
        itemCount: session.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${session[index].FullName} : ${session[index].CardType}',
                style: const TextStyle(color: Colors.indigo)),
            subtitle: Text(
                '${session[index].CardNumber} : ${session[index].IssuingCountry}',
                style: const TextStyle(color: Colors.indigo)),
            leading: const Icon(
              Icons.credit_card,
              color: Colors.indigo,
            ),
            onTap: () {
              currentCard = session[index];
              showCard(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final cardNumber = TextFormField(
      controller: cardNumberController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(19),
        CardNumberInputFormatter(),
      ],
      onChanged: (value) => currentCard.CardNumber = value,
      decoration: InputDecoration(
        hintText: "Card number",
        suffix: CardUtils.getCardIcon(cardType),
      ),
    );

    final fullName = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        onChanged: (value) => currentCard.FullName = value,
        decoration: const InputDecoration(hintText: "Full name"),
      ),
    );

    final cvv = TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        // Limit the input
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (value) => currentCard.CVV = value,
      validator: (value) => CardUtils.validateCVV(value),
      decoration: const InputDecoration(hintText: "CVV"),
    );

    final expiryDate = TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        CardMonthInputFormatter(),
      ],
      onChanged: (value) => currentCard.ExpieryDate = value,
      validator: (value) => CardUtils.validateDate(value),
      decoration: const InputDecoration(hintText: "MM/YY"),
    );

    final countryOfIssue = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        controller: countryOfIssueController,
        decoration: const InputDecoration(hintText: "Issuing Country"),
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: false,
            onSelect: (Country country) {
              countryOfIssueController.text = country.displayNameNoCountryCode;
              currentCard.IssuingCountry = country.displayNameNoCountryCode;
            },
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF100887)),
        title: const SearchField(),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.camera,
              color: Color(0xFF100887),
            ),
            onPressed: () async {
              var cardDetails = await CardScanner.scanCard(
                scanOptions: const CardScanOptions(
                  scanCardHolderName: true,
                ),
              );

              setState(() {
                currentCard.FullName = cardDetails!.cardHolderName;
                currentCard.CardNumber = cardDetails!.cardNumber;
                currentCard.ExpieryDate = cardDetails!.expiryDate;

                fullNameController.text = currentCard.FullName;
                cardNumberController.text = currentCard.CardNumber;
                expieryDateController.text = currentCard.ExpieryDate;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            selectedIndex, // this will be set when a new tab is tapped
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: const Color(0xFF100887),
        onTap: onTabTapped,
        items: menuitems,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          save(context);
          setState(() {});
        },
        label: const Text(
          'Add card',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF100887),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  cardNumber,
                  fullName,
                  Row(
                    children: [
                      Expanded(
                        child: cvv,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: expiryDate,
                      ),
                    ],
                  ),
                  countryOfIssue,
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 15,
                      right: 5,
                      top: 10,
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    dense: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.filter_list,
                          color: Color(0xFF100887)),
                      onPressed: () {},
                    ),
                    title: const Text(
                      'Session',
                      style: TextStyle(
                          color: Color(0xFF100887),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    color: Colors.lightBlueAccent,
                    endIndent: 15,
                    indent: 15,
                  ),
                  const SizedBox(height: 2),
                  SizedBox(height: 250, child: displaySession()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
