import 'package:creditcard/models/banned_countries.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/dialogbox.dart';

class Card {
  String CardNumber;
  String CardType;
  String CVV;
  String IssuingCountry;
  String ExpieryDate;
  String FullName;
  String DateCaptured;

  Card({
    required this.CardNumber,
    required this.CardType,
    required this.CVV,
    required this.IssuingCountry,
    required this.ExpieryDate,
    required this.FullName,
    required this.DateCaptured,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
        CardNumber: json['CardNumber'] ?? json['CardNumber'],
        CardType: json['CardType'] ?? json['CardType'],
        CVV: json['CVV'] ?? json['CVV'],
        IssuingCountry: json['IssuingCountry'] ?? json['IssuingCountry'],
        ExpieryDate: json['ExpieryDate'] ?? json['ExpieryDate'],
        FullName: json['FullName'] ?? json['FullName'],
        DateCaptured: json['DateCaptured'] ?? json['DateCaptured']);
  }

  Map<String, dynamic> toJson() => {
        'CardNumber': CardNumber,
        'CardType': CardType,
        'CVV': CVV,
        'IssuingCountry': IssuingCountry,
        'ExpieryDate': ExpieryDate,
        'FullName': FullName,
        'DateCaptured': DateCaptured,
      };
}

List<Card> cards = [];
List<Card> session = [];
List<Card> searchresults = [];

Card currentCard = Card(
    CardNumber: '',
    CardType: '',
    CVV: '',
    IssuingCountry: '',
    ExpieryDate: '',
    FullName: '',
    DateCaptured: '');

List<Card> search(String pattern) {
  return cards
      .where((c) => (c.FullName == pattern || c.CardNumber == pattern))
      .toList();
}

void save(BuildContext context) {
  if (currentCard.CardNumber.isEmpty) {
    dialogbox(context, 'Card', 'Invalid Card Number');
    return;
  }

  List<Card> matchingCards =
      cards.where((c) => (c.CardNumber == currentCard.CardNumber)).toList();

  if (matchingCards.isNotEmpty) {
    dialogbox(context, 'Card', 'Card Already Exists');
    return;
  }

  if (bannedCountries.contains(currentCard.IssuingCountry)) {
    dialogbox(context, 'Card', 'Specified country is banned');
    return;
  }

  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  currentCard.DateCaptured = inputFormat.format(DateTime.now()).toString();

  cards.add(currentCard);
  session.add(currentCard);
  dialogbox(context, 'Card Saved',
      '${currentCard.FullName} ${currentCard.CardNumber}');
  backup();
  currentCard = Card(
      CardNumber: '',
      CardType: '',
      CVV: '',
      IssuingCountry: '',
      ExpieryDate: '',
      FullName: '',
      DateCaptured: '');
}

backup() async {
  try {
    await logresponse(jsonEncode(cards), 'cards.json');
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

mainBackup() async {
  try {
    await logresponse(jsonEncode(cards), 'cards_all.json');
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

shareBackup() async {
  try {
    final applicationDirectory = await getApplicationDocumentsDirectory();
    XFile file = XFile('${applicationDirectory.path}/cards_all.json');

    await logresponse(jsonEncode(cards), 'cards_all.json');
    Share.shareXFiles([file], text: 'Cards Logs');
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

loadbackup() async {
  try {
    final applicationDirectory = await getApplicationDocumentsDirectory();
    String path = applicationDirectory.path;
    File file = File('$path/cards.json');
    if (await file.exists()) {
      String contents = await file.readAsString();
      final parsed = json.decode(contents).cast<Map<String, dynamic>>();
      cards = parsed.map<Card>((json) => Card.fromJson(json)).toList();
    }
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

logresponse(String responseBody, String filename) async {
  try {
    final applicationDirectory = await getApplicationDocumentsDirectory();
    String path = applicationDirectory.path;

    File('$path/$filename').writeAsString(responseBody);
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}
