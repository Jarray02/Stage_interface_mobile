import 'package:first_flutter_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileSelector extends StatefulWidget {
  const ProfileSelector({Key? key}) : super(key: key);

  @override
  State<ProfileSelector> createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                const LinearGradient(
                  colors: [
                    AppColors.cardLight,
                    AppColors.cardDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make()
        ],
      ),
    );
  }
}
