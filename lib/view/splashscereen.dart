import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_trek_e/view/firstview.dart';

class Splashscereen extends StatefulWidget {
  const Splashscereen({super.key});

  @override
  State<Splashscereen> createState() => _SplashscereenState();
}

class _SplashscereenState extends State<Splashscereen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Firstview()));
    });
  }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.manual,
  //     overlays: SystemUiOverlay.values,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('lib/view/assets/images/ab.png'),
          ),
        ),
      ),
    );
  }
}
