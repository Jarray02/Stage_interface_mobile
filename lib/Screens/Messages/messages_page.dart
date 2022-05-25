import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/helpers.dart';
import 'package:first_flutter_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import '../../Custm_Widgets/custm_widgets.dart';
import '../../models/models.dart';
import '../screens.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({Key? key, required this.userPic}) : super(key: key);

  final String userPic;
  final DatabaseReference _chatsRef =
      FirebaseDatabase.instance.ref().child('Chats');
  final DatabaseReference _userChatsRef =
      FirebaseDatabase.instance.ref().child('UserChats');
  final DatabaseReference _chatMessagesRef =
      FirebaseDatabase.instance.ref().child('ChatMessages');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: const Text('Messages'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          showSearch(context: context, delegate: SearchBar()),
                      icon: const Icon(Icons.search)),
                  const SizedBox(width: 3.0),
                  Avatar.small(
                      url: userPic,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProfileSettings(userPic: userPic)));
                      }),
                ],
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(_delegate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _delegate(BuildContext context, int index) {
    final Faker faker = Faker();
    final date = Helpers.randomDate();
    return _MessageTitle(
      userPic: userPic,
      messageData: MessageData(
        senderName: faker.person.name(),
        message: faker.lorem.sentence(),
        messageDate: date,
        dateMessage: Jiffy(date).fromNow(),
        profilePicture: Helpers.randomPictureUrl(),
      ),
    );
  }
}

class SearchBar extends SearchDelegate<String> {
  late Map<String, dynamic> userMap;
  late int userMapLength;
  final recentSearch = [
    "searchedUser1",
    "searchedUser2",
    "searchedUser3",
    "searchedUser4"
  ];

  UserData? userData;

  List userList = [];

  Future<void> onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    await _ref.child('Users').equalTo("name").get().then((value) {
      userList = value.children.toList();
      debugPrint(userList.toString());
    });

    // await _firestore
    //     .collection('users')
    //     .where("name ", isEqualTo: query)
    //     .get()<
    //     .then((value) {
    //   userMap = value.docs[0].data();
    // });
    // debugPrint(userMap.toString());
    // return userMap
    //     .forEach((username, userpicture) => userList.add(userData?.userName));
  }

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
        close(context, 'closed');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text('Search user'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty ? recentSearch : userList;

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () async {
                showResults(context);
                DatabaseReference _ref = FirebaseDatabase.instance.ref();
                await _ref.child('Users').get().then((value) {
                  userList = value.children.map((e) => e as String).toList();
                  print(userList.toString());
                });
              },
              title: Text(userList[index]),
              leading: const Icon(Icons.person),
            ));
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle(
      {Key? key, required this.messageData, required this.userPic})
      : super(key: key);

  final MessageData messageData;
  final String userPic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MessagingService.route(messageData, userPic));
      },
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: messageData.profilePicture),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messageData.senderName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      child: Text(
                        messageData.message,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4.0),
                    Text(
                      messageData.dateMessage.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11.0,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: AppColors.textLigth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
