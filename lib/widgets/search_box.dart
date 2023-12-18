import 'package:flutter/material.dart';
import '../models/card.dart';
import '../screens/search.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const secondaryColor = Colors.white;
    const defaultPadding = 16.0;
    String searchPattern = '';

    return TextField(
      style: const TextStyle(color: Colors.black),
      onChanged: (value) {
        searchPattern = value;
      },
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        hintStyle: const TextStyle(color: Color(0xFF2A2D3E)),
        labelStyle: const TextStyle(color: Color(0xFF2A2D3E)),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {
            searchresults = search(searchPattern);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: Color(0xFF100887),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30.0,
            ), //SvgPicture.asset('assets/Search.svg'),
          ),
        ),
      ),
    );
  }
}
