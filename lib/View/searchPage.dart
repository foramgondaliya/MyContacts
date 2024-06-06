import 'package:flutter/material.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/search_contactProvider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.green,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            final contactProvider =
                Provider.of<ContactProvider>(context, listen: false);
            Provider.of<SearchProvider>(context, listen: false)
                .searchContacts(query, contactProvider.allContact);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          final searchResults = searchProvider.searchResults;

          if (searchResults.isEmpty) {
            return Center(
              child: Text(
                'No results found',
              ),
            );
          } else {
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final contact = searchResults[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.contact),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('detailPage', arguments: contact);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
