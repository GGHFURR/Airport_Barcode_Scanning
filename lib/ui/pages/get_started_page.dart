import 'package:airplane_thoriq/ui/pages/qrviewexample.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import 'qrviewexample.dart'; // Import halaman scan_page.dart
import 'sign_up_page.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/image_get_started.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40, // Adjust the top position as needed
            right: 20, // Adjust the right position as needed
            child: Image.asset(
              'assets/injourney_black.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                ),
                Text(
                  'Passenger Data Collections',
                  style: whiteTextStyle.copyWith(
                    fontSize: 32,
                    fontWeight: semibold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Boarding Pass Scanner',
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: light,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 150,
                  height: 55,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                    ),
                    child: Text(
                      'SCAN',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
