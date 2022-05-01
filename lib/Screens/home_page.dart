import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import '../Custm_Widgets/navigation_drawer_widget.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

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
  final PageController _pageController = PageController(initialPage: 0);
  double _temperature = 0, _humidite = 0, _pression = 0;
  String _profile = '1';
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Home Page'),
          elevation: 5.0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
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
        var dataMap =
            Map<String, dynamic>.from(event.snapshot.value as LinkedHashMap);
        SensorData sensorData = SensorData.fromRTDB(dataMap);
        setState(() {
          _temperature = sensorData.temperature;
          _humidite = sensorData.humidite;
          _profile = sensorData.profile;
          _pression = sensorData.pression;
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
        // const Icon(Icons.person, color: Colors.blue, size: 100),
        // Text('The current profile is $profile'),
        // const SizedBox(height: 50.0),
        profilSelector(),
      ]),
    );
  }

  Widget _temperatureWidget(double temperature) {
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: FAProgressBar(
                progressColor: Colors.blue,
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                size: 100,
                currentValue: double.parse(temperature.toStringAsFixed(2)),
                changeProgressColor: Colors.red,
                maxValue: 100,
                displayText: '°C',
                borderRadius: BorderRadius.circular(16),
                animatedDuration: const Duration(milliseconds: 500),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '$temperature °C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          )
        ],
      ),
    );
  }

  Widget _pressureWidget(double pressure) {
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
              child: FAProgressBar(
                progressColor: Colors.blue,
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                size: 100,
                currentValue: double.parse(pressure.toStringAsFixed(2)),
                changeProgressColor: Colors.red,
                maxValue: 50000,
                displayText: '°C',
                borderRadius: BorderRadius.circular(16),
                animatedDuration: const Duration(milliseconds: 500),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '$pressure mPa',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          )
        ],
      ),
    );
  }

  Widget _humidityWidget(double humidity) {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 50),
              child: LiquidCircularProgressIndicator(
                value: humidity / 100, // Defaults to 0.5.
                valueColor: const AlwaysStoppedAnimation(Colors
                    .blue), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blue,
                borderWidth: 3.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: const Text("%",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              '$humidity %',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          )
        ],
      ),
    );
  }

  Widget profilSelector() {
    Profile banane = Profile(
        name: 'Banane',
        id: 1,
        icon: const AssetImage('assets/banane.webp'),
        maxTemp: 20,
        maxHumid: 50);
    Profile algue = Profile(
        name: 'Algue',
        id: 2,
        icon: const AssetImage('assets/algue.png'),
        maxTemp: 50,
        maxHumid: 30);
    Profile apple = Profile(
        name: 'Apple',
        id: 3,
        icon: const AssetImage('assets/apple.png'),
        maxTemp: 20,
        maxHumid: 50);
    Profile orange = Profile(
        name: 'Orange',
        id: 1,
        icon: const AssetImage('assets/orange.png'),
        maxTemp: 20,
        maxHumid: 50);
    List<Profile> profileList = [banane, algue, apple, orange];
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 200,
      child: Stack(
        children: [
          VxAnimatedBox().size(50, 50).make(),
          VxSwiper.builder(
              itemCount: profileList.length,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              itemBuilder: (context, index) {
                final prof = profileList[index];
                return VxBox(
                        child: ZStack(
                  [
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: VxBox(
                        child: prof.maxTemp.text.uppercase.white.make().px16(),
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
                          prof.name.text.xl3.white.bold.make(),
                          5.heightBox,
                          prof.maxTemp.text.sm.white.semiBold.make(),
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
                    10.heightBox,
                    "Tap to change current profile".text.gray300.make(),
                  ],
                ))
                    .clip(Clip.antiAlias)
                    .bgImage(DecorationImage(
                        image: prof.icon,
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken)))
                    .border(color: Colors.black, width: 0.5)
                    .withRounded(value: 60.0)
                    .make()
                    .onInkTap(() {})
                    .p16();
              }).centered(),
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
