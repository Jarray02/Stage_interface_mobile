import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileSelector extends StatefulWidget {
  const ProfileSelector({Key? key}) : super(key: key);

  @override
  State<ProfileSelector> createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child('Data');
  bool barIsSelected = true;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              if (currentIndex != 0) {
                currentIndex--;
              }
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Stack(
            children: [
              VxSwiper.builder(
                  itemCount: 10,
                  // itemCount: profileList.length,
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  itemBuilder: (context, index) {
                    currentIndex = index;
                    // final prof = profileList[index];
                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(child: const Text("rou7 naiek")
                                  // prof.maxTemp.text.uppercase.white.make().px16(),
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
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(DecorationImage(
                            image: const AssetImage("assets.logo.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)))
                        .border(color: Colors.black, width: 5)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkTap(() async {
                      await _ref.update({"currentProfile": 'zebi'});
                    }).p16();
                  }).centered(),
            ],
            fit: StackFit.expand,
          ),
        ),
        IconButton(
            onPressed: () {
              if (currentIndex != 3) {
                setState(() {
                  currentIndex++;
                });
              }
            },
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black)),
      ],
    );
  }
}
