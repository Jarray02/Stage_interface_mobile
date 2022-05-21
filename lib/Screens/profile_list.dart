import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/Screens/screens.dart';
import 'package:flutter/material.dart';

class MyProfileList extends StatefulWidget {
  const MyProfileList({Key? key}) : super(key: key);

  @override
  State<MyProfileList> createState() => _MyProfileListState();
}

class _MyProfileListState extends State<MyProfileList> {
  final DatabaseReference _profileRef =
      FirebaseDatabase.instance.ref().child('profile');

  List _profileList = [];

  @override
  void initState() {
    _fetchProfileList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Article list',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(24, 115, 185, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            // onPressed: () => Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => const HomePage(),
            //   ),
          ),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: _profileList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailFromList(prof: _profileList[index])));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Hero(
                            tag: _profileList[index]['name'],
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      NetworkImage(_profileList[index]['icon']),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(_profileList[index]['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.8))),
                        ],
                      )),
                      const Divider(
                        thickness: 2,
                        color: Colors.blue,
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            print('deleted');
                            showDialog(
                              context: (context),
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure ?'),
                                content: const Text(
                                    'Once you delete the item you can no longer retreive it'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        print(_profileList[index]['name']);
                                        await _deleteProfile(_profileList[index]
                                                    ['name']
                                                .toString()
                                                .toLowerCase())
                                            .then((_) {
                                          setState(() {
                                            _profileList.remove(index);
                                          });
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('confirm')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('cancel')),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _deleteProfile(var key) async {
    await _profileRef.child(key).remove();
  }

  Future _fetchProfileList() async {
    var prof = await _profileRef
        .get()
        .then((value) => value.children.map((e) => e.value).toList());
    setState(() {
      _profileList = prof;
    });

    return _profileList;
  }
}
