import 'package:first_flutter_project/Custm_Widgets/custm_widgets.dart';
import 'package:flutter/material.dart';

class CurrentProfileWidget extends StatefulWidget {
  const CurrentProfileWidget({Key? key, required this.profile})
      : super(key: key);

  final String profile;

  @override
  State<CurrentProfileWidget> createState() => _CurrentProfileWidgetState();
}

class _CurrentProfileWidgetState extends State<CurrentProfileWidget> {
  String profile = '';
  bool barIsSelected = true;
  void fetchProfile() {
    switch (widget.profile.toLowerCase()) {
      case 'algue':
        profile = 'algue.png';
        break;
      case 'banane':
        profile = 'banane.png';
        break;
      case 'apple':
        profile = 'apple.png';
        break;
      case 'orange':
        profile = 'orange.jpg';
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(children: [
            const SizedBox(height: 20),
            SizedBox(
                width: 150,
                height: 150,
                child: Center(child: Image(image: AssetImage(widget.profile)))),
            Text('The current profile is $profile'),
            const SizedBox(height: 50),
            const ProfileSelector(),
            const SizedBox(height: 20),
            const Text(
              'Tap on icon to select the profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ],
    );
  }

  Widget slectedView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              if (!barIsSelected) {
                setState(() {
                  barIsSelected = true;
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: barIsSelected
                    ? MaterialStateProperty.all<Color>(Colors.blue)
                    : MaterialStateProperty.all<Color>(Colors.white)),
            child: Text(
              'Bar',
              style:
                  TextStyle(color: barIsSelected ? Colors.white : Colors.blue),
            ),
          ),
          const SizedBox(width: 5),
          OutlinedButton(
            onPressed: () {
              if (barIsSelected) {
                setState(() {
                  barIsSelected = false;
                });
              }
            },
            child: Text(
              'Graphe',
              style:
                  TextStyle(color: barIsSelected ? Colors.blue : Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: barIsSelected
                    ? MaterialStateProperty.all<Color>(Colors.white)
                    : MaterialStateProperty.all<Color>(Colors.blue)),
          ),
        ],
      ),
    );
  }
}
