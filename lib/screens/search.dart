import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../models/card.dart';
import 'package:flutter/material.dart';
import '../widgets/bottomnavigationbar.dart';
import '../widgets/dialogbox.dart';
import '../widgets/search_box.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  void initState() {
/*     if (searchresults.isEmpty) {
      searchresults = cards;
    } */
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
      onItemTapped(context);
    });
  }

  ListView searchResults() {
    return ListView.builder(
        itemCount: searchresults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                '${searchresults[index].FullName} : ${searchresults[index].CardType}',
                style: const TextStyle(color: Colors.indigo)),
            subtitle: Text(
                '${searchresults[index].CardNumber} : ${searchresults[index].IssuingCountry}',
                style: const TextStyle(color: Colors.indigo)),
            leading: const Icon(
              Icons.credit_card,
              color: Colors.indigo,
            ),
            onTap: () {
              currentCard = searchresults[index];
              setState(() {});
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF100887)),
        title: const SearchField(),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.backup,
              color: Color(0xFF100887),
            ),
            onPressed: () {
              mainBackup();
              dialogbox(context, 'Cards', 'Backup Complete');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Color(0xFF100887),
            ),
            onPressed: () {
              setState(() {
                shareBackup();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListBody(
          children: <Widget>[
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
            const Divider(height: 5.0),
            SizedBox(height: 600, child: searchResults()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            selectedIndex, // this will be set when a new tab is tapped
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: const Color(0xFF100887),
        onTap: onTabTapped,
        items: menuitems,
      ),
    );
  }
}
