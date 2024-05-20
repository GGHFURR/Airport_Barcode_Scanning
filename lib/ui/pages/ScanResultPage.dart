import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ScanResultPage extends StatelessWidget {
  final String rawpnr;

  const ScanResultPage({Key? key, required this.rawpnr, required String token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/injourney_colour.png'),
                ),
              ),
            ),
            Text(
              'Scan Result:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              rawpnr,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendDataToAPI(context),
              child: Text('Send Data to API'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendDataToAPI(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String? tokenExpiry = prefs.getString('token_expiry');

    if (token != null && tokenExpiry != null) {
      DateTime expiryDate = DateTime.parse(tokenExpiry);
      if (DateTime.now().isBefore(expiryDate)) {
        _sendData(context, token);
      } else {
        bool tokenRefreshed = await refreshToken();
        if (tokenRefreshed) {
          token = prefs.getString('token');
          if (token != null) {
            _sendData(context, token);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No token found. Please log in again.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token expired. Please log in again.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please log in again.')),
      );
    }
  }

  Future<void> _sendData(BuildContext context, String token) async {
    String apiUrl = 'https://dashapigcp.travelin.co.id/external/validate/pnr';
    String devid = 'mobile-external';

    String guid = hashGuid(token, devid);

    String basicAuthCredentials = base64Encode(
        utf8.encode('external-mobile-apps:FVNUxQlNhcUBhsMsqBez9yyN'));

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Basic $basicAuthCredentials',
          'Content-Type': 'application/json',
          'guid': guid,
        },
        body: jsonEncode({
          'rawPnr': rawpnr,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Guid: $guid');
      print('rawPnr : $rawpnr');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data sent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send data')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  String hashGuid(String token, String devid) {
    String combinedString = devid + '-' + token;
    var bytes = utf8.encode(combinedString);
    var digest = sha256.convert(bytes);
    print('combined : $combinedString');
    return digest.toString();
  }

  Future<bool> refreshToken() async {
    String refreshTokenUrl =
        'https://dashapigcp.travelin.co.id/external/validate/pnr';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      return false;
    }

    String basicAuthCredentials = base64Encode(
        utf8.encode('external-mobile-apps:FVNUxQlNhcUBhsMsqBez9yyN'));

    try {
      var response = await http.post(
        Uri.parse(refreshTokenUrl),
        headers: {
          'Authorization': 'Basic $basicAuthCredentials',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['code'] == 200 && data['data'].containsKey('token')) {
          String newToken = data['data']['token'];
          await prefs.setString('token', newToken);
          await prefs.setString('token_expiry',
              DateTime.now().add(Duration(hours: 1)).toIso8601String());
          return true;
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }
}
