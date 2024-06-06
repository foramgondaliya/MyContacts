import 'package:flutter/material.dart';
import 'package:mycontacts/Modal/contact.dart';

class SearchProvider with ChangeNotifier {
  List<Contact> _searchResults = [];

  List<Contact> get searchResults => _searchResults;

  void searchContacts(String query, List<Contact> allContact) {
    _searchResults = allContact
        .where((contact) =>
            contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
