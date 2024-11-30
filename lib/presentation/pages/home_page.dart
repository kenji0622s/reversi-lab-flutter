import 'package:flutter/material.dart';
import 'package:reversi_lab/presentation/pages/play_page.dart';
import 'package:reversi_lab/presentation/pages/challenge_page.dart';
import 'package:reversi_lab/presentation/widgets/my_app_bar.dart';
import 'package:reversi_lab/presentation/widgets/menu_button.dart';
import 'package:gap/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const MyAppBar(title: 'Reversi Lab'),
      body: Padding(
        padding: EdgeInsets.all(deviceWidth * 0.15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                label: 'Play',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PlayPage()));
                },
              ),
              const Gap(16),
              MenuButton(
                label: 'Challenge',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChallengePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
