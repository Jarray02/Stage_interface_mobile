import 'package:flutter/material.dart';

class SearchBar extends SearchDelegate<String> {
  final usersList = [
    "User1",
    "User2",
    "User3",
    "User4",
    "User5",
    "User6",
    "User7",
    "User8",
    "User9"
  ];
  final recentSearch = [
    "searchedUser1",
    "searchedUser2",
    "searchedUser3",
    "searchedUser4"
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop;
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : usersList.where((element) => element.startsWith(query)).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () => showResults(context),
              title: Text(suggestionList[index]),
              leading: const Icon(Icons.person),
            ));
  }
}
