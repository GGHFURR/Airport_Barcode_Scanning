import 'dart:async';
import 'package:airplane_thoriq/ui/pages/get_started_page.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/sign-up');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 150,
              margin: EdgeInsets.only(bottom: 50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/injourney_white.png'),
                ),
              ),
            ),
            Text(
              'ANGKASA PURA INDONESIA',
              style: whiteTextStyle.copyWith(
                fontSize: 15,
                fontWeight: medium,
                letterSpacing: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
