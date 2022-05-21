import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import '../Custm_Widgets/custm_widgets.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import 'screens.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('Data');
  final DatabaseReference _profileRef =
      FirebaseDatabase.instance.ref().child('profile');
  final PageController _pageController = PageController(initialPage: 0);
  num _temperature = 0, _humidite = 0, _pression = 0;
  String _profile = 'banane';
  int _currentPageIndex = 0;
  String _currentIcon = '';
  bool barIsSelected = true;
  List _profileList = [];
  @override
  void initState() {
    super.initState();
    fetchProfileList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          title: const Text(
            'Home Page',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 5.0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          key: const Key("bottomNavigationBar"),
          backgroundColor: const Color.fromARGB(255, 24, 115, 185),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          currentIndex: _currentPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.thermostat), label: 'Température'),
            BottomNavigationBarItem(icon: Icon(Icons.water), label: 'Humidité'),
            BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Pression'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            _currentPageIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          },
        ),
        body: _pageViewWidget(),
      ),
    );
  }

  Widget _pageViewWidget() {
    return StreamBuilder<Object>(builder: (context, snapshot) {
      _ref.onValue.listen((event) {
        List sensorData = event.snapshot.children.map((e) => e.value).toList();
        fetchMatchedProfileIcon();
        setState(() {
          _profile = sensorData[0];
          _humidite = sensorData[1];
          _pression = sensorData[2];
          _temperature = sensorData[3];
        });
      });
      return PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          _currentPageIndex = newIndex;
        },
        scrollDirection: Axis.horizontal,
        children: [
          _temperatureWidget(_temperature),
          _humidityWidget(_humidite),
          _pressureWidget(_pression),
          _profileWidget(_profile),
        ],
      );
    });
  }

  Widget _profileWidget(String profile) {
    return Center(
      child: Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ProfileDetailHomePage()));
                      },
                      child: Hero(
                        tag: "ProfilePic",
                        child: Image(
                          image: NetworkImage(_currentIcon),
                        ),
                      ),
                    ),
                  ),
                ),
                Text('The current profile is $_profile'),
                const SizedBox(height: 50),
                profilSelector(),
                const SizedBox(height: 20),
                const Text(
                  'Tap on icon to select the profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ]),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _temperatureWidget(num temperature) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Temperature',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: barIsSelected
                  ? FAProgressBar(
                      progressColor: Colors.blue,
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      size: 100,
                      currentValue:
                          double.parse(temperature.toStringAsFixed(2)),
                      changeProgressColor: Colors.red,
                      maxValue: 100,
                      displayText: '°C',
                      borderRadius: BorderRadius.circular(16),
                      animatedDuration: const Duration(milliseconds: 500),
                    )
                  : const TempChart(value: 'temperature'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '$temperature °C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          slectedView(),
        ],
      ),
    );
  }

  Widget _pressureWidget(num pressure) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Pression',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: barIsSelected
                  ? FAProgressBar(
                      progressColor: Colors.blue,
                      direction: Axis.vertical,
                      verticalDirection: VerticalDirection.up,
                      size: 100,
                      currentValue: double.parse(pressure.toStringAsFixed(2)),
                      changeProgressColor: Colors.red,
                      maxValue: 5000,
                      displayText: '°C',
                      borderRadius: BorderRadius.circular(16),
                      animatedDuration: const Duration(milliseconds: 500),
                    )
                  : const TempChart(value: 'pression'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '$pressure mPa',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          slectedView(),
        ],
      ),
    );
  }

  Widget _humidityWidget(num humidity) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: const Text(
              'Humidité',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                width: 300,
                height: 300,
                child: barIsSelected
                    ? LiquidCircularProgressIndicator(
                        value: humidity / 100,
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        backgroundColor: Colors.white,
                        borderColor: Colors.blue,
                        borderWidth: 3.0,
                        direction: Axis.vertical,
                        center: Text(
                          "%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      )
                    : const TempChart(
                        value: 'humidite',
                      ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 27),
            child: Text(
              '$humidity %',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          slectedView(),
        ],
      ),
    );
  }

  Widget profilSelector() {
    int currentIndex = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (currentIndex != 0) {
              setState(() {
                currentIndex--;
              });
            }
          },
        ),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Stack(
            children: [
              VxAnimatedBox().size(50, 50).make(),
              VxSwiper.builder(
                  itemCount: _profileList.length,
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  itemBuilder: (context, index) {
                    final prof = _profileList[index];
                    currentIndex = index;
                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(
                                  // child: prof.maxTemp.text.uppercase.white
                                  // .make()
                                  // .px16(),
                                  )
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 16.0)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              // prof.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              // prof.maxTemp.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                            image: NetworkImage(prof["icon"]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)))
                        .border(color: Colors.black, width: 5)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkTap(() async {
                      await _ref.update({
                        "currentProfile": prof['name'].toString().toLowerCase()
                      });
                    }).p16();
                  }).centered(),
            ],
            fit: StackFit.expand,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
          onPressed: () {
            if (currentIndex != 3) {
              setState(() {
                currentIndex++;
              });
            }
          },
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

  Future<List<Object?>> fetchProfileList() async {
    var _list = await _profileRef
        .get()
        .then((value) => value.children.map((e) => e.value).toList());
    setState(() {
      _profileList = _list;
    });
    return _profileList;
  }

  fetchMatchedProfileIcon() async {
    var currentIcon;
    var _currentProfile =
        await _ref.child('currentProfile').get().then((value) => value.value);
    List<dynamic> _profileListKeys = await _profileRef
        .get()
        .then((value) => value.children.map((e) => e.value).toList());
    _profileListKeys.forEach((element) {
      if (element['name'].toString().toLowerCase() == _currentProfile) {
        currentIcon = element['icon'];
      }
    });
    setState(() {
      _currentIcon = currentIcon;
    });
  }
}
