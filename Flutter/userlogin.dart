import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login/candlog.dart';

import 'package:login/dhead.dart';
import 'package:login/dhead1.dart';
import 'package:login/dhead2.dart';



import 'package:login/hr.dart';
import 'package:login/manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Image Example',
      home: UserPage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'lib/assets/img.jpg', // Replace this with your image path
            fit: BoxFit.cover,
          ),
          // White Container for Login
          LoginContainer(),
          // Company Name
          Positioned(
            top: 40.0,
            left: 35.0,
            child: Text(
              ' Company ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Icon Button
          Positioned(
            top: 40.0,
            right: 35.0, // Adjust the right distance
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // Navigate to candidate login page
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginSignUpScreen()),
                    );
                  },
                ),
               // Add spacing between the icon and the text
               
                SizedBox(width: 10), // Add spacing between the icon and the text
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginSignUpScreen()),
                    );
                  },
                  child: Text(
                    'Candidate Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
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

class LoginContainer extends StatefulWidget {
  @override
  _LoginContainerState createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _loginUser(String username, String password, BuildContext context) async {
    const String serverUrl = 'http://192.168.1.211:3000/api/logins';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        if (userData.containsKey('userType')) {
          String userType = userData['userType'];
          switch (userType) {
            case 'Employee':
              final employeeResponse = await http.get(
                Uri.parse('http://192.168.1.211:3000/api/employee/$username'),
              );

              if (employeeResponse.statusCode == 200) {
                Map<String, dynamic> employeeData = json.decode(employeeResponse.body);
                int deptId = employeeData['DEPT_ID'];

                switch (deptId) {
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequirementPage()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequirementPage1()),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequirementPage2()),
                    );
                    break;
                  default:
                    _showDialog(context, 'Invalid department. Please contact support.');
                }
              } else {
                _showDialog(context, 'Error fetching employee data');
              }
              break;
            case 'hr':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
              break;
            case 'manager':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagerPage()),
              );
              break;
            default:
              _showDialog(context, 'Invalid user type. Please contact support.');
          }
        } else {
          _showDialog(context, 'User type not found in response. Please contact support.');
        }
      } else {
        _showDialog(context, 'Invalid username or password. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      _showDialog(context, 'An error occurred. Please try again later.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500, // Width of the container
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            // Username Field
            Row(
              children: [
                Icon(Icons.person), // Username icon
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            // Password Field
            Row(
              children: [
                Icon(Icons.lock), // Password icon
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              width: 300,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.black, // Black color
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextButton(
                onPressed: () {
                  _loginUser(usernameController.text, passwordController.text, context);
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white), // White text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
