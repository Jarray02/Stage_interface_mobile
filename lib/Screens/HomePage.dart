import 'package:first_flutter_project/Custm_Widgets/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 10.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.thermostat,
                color: Colors.red,
              ),
              const SizedBox(width: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    'Temperature',
                    style: TextStyle(
                      fontSize: 25.0,
                      wordSpacing: 5.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'val_temp',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black, fontSize: 15.0, wordSpacing: 5.0),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 100.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Row(children: const <Widget>[
                      Icon(
                        Icons.water_drop,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 3.0),
                      Text(
                        'Humidity',
                        style: TextStyle(
                          fontSize: 25.0,
                          wordSpacing: 5.0,
                          color: Colors.black,
                        ),
                      ),
                    ]),
                    const Text(
                      'val_hum',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        wordSpacing: 5.0,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 50.0),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 3.0),
                        Text(
                          'Current profile',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            wordSpacing: 5.0,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'val_profil',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
