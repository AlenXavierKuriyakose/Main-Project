import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import 'package:login/userlogin.dart';
//import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            textStyle: MaterialStateProperty.all(
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.blue),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16.0)),
          ),
        ),
      ),
      home: LoginSignUpScreen(),
    );
  }
}

class LoginSignUpScreen extends StatefulWidget {
  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _selectedGender;
  // ignore: unused_field
  bool _isLoading = false;
  bool _isLoginMode = true;

  Future<void> _retrieveDetails(String uname, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/loginret/$uname/$password'),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(parsedResponse),
            ),
          );
        } else {
          print('Failed to retrieve user details: Invalid response format');
        }
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Enter a valid username or password!'),
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
      } else {
        print('Failed to retrieve user details: ${response.statusCode}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'Failed to retrieve user details. Please check your connection and try again.',
              ),
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
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'An error occurred while retrieving user details. Please check your connection and try again.',
            ),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _signUp(String u_name, String password, String f_name, String dob,
      String gender, String email) async {
    setState(() {
      _isLoading = true;
    });

    // Validation logic
    if (u_name.isEmpty || password.isEmpty || f_name.isEmpty || dob.isEmpty || gender.isEmpty || email.isEmpty) {
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
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
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Password validation: Minimum 6 characters
    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Password must be at least 6 characters long.'),
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
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Email validation using regular expression
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Enter a valid email address.'),
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
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Date of birth (dob) validation: Custom format
    // Example: dd-MM-yyyy
    RegExp dobRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dobRegex.hasMatch(dob)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Enter date of birth in the format dd-MM-yyyy.'),
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
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.211:3000/api/signup'),
        body: jsonEncode({
          'u_name': u_name,
          'password': password,
          'f_name': f_name,
          'dob': dob,
          'gender': gender,
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is Map<String, dynamic>) {
          // Handle signup success as needed
          print('Signup successful: $parsedResponse');
          // Show registration success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registered successfully!'),
              duration: Duration(seconds: 3),
            ),
          );
          // Clear input fields
          _unameController.clear();
          _passwordController.clear();
          _fNameController.clear();
          _dobController.clear();
          _genderController.clear();
          _emailController.clear();
        } else {
          print('Failed to sign up: Invalid response format');
        }
      } else {
        print('Failed to sign up: ${response.statusCode}');
        // Show error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'Failed to sign up. Please try again later.',
              ),
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
    } catch (e) {
      print('Error: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'An error occurred while signing up. Please check your connection and try again.',
            ),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/img.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _isLoginMode
              ? _buildLoginContainer()
              : _buildSignUpContainer(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Candidate Details'),
              onTap: () {
                // Navigate to candidate details screen
                Navigator.pop(context); // Close the drawer
                // Add your navigation logic here
              },
            ),
            ListTile(
              title: Text('Apply for Jobs'),
              onTap: () {
                 
                },
            ),
            ListTile(
              title: Text('Job Status'),
              onTap: () {
                // Navigate to job status screen
                Navigator.pop(context); // Close the drawer
                // Add your navigation logic here
              },
            ),
          ],
        ),
      ),
    );
    
  }

  Widget _buildLoginContainer() {
    return SizedBox(
      width: 500,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.0),
          child: _buildLoginUI(),
        ),
      ),
    );
  }

  Widget _buildSignUpContainer() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.0),
          child: _buildSignUpUI(),
        ),
      ),
    );
  }
  Widget _buildLoginUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'LOGIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          controller: _unameController,
          decoration: InputDecoration(
            labelText: 'Enter Username',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Enter Password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: SizedBox(
            width: 200.0,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _retrieveDetails(
                    _unameController.text, _passwordController.text);
              },
              child: Text('Login'),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Center(
          child: TextButton(
            onPressed: _toggleMode,
            child: Text("Don't have an account? Sign up"),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpUI() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Text(
        'SIGN UP',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _unameController,
        decoration: InputDecoration(
          labelText: 'Enter Username',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Enter Password',
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _fNameController,
        decoration: InputDecoration(
          labelText: 'Full Name',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      SizedBox(height: 20.0),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Container(
              // Your container code...
              child: DropdownButtonFormField<String>(
                value: _selectedGender, // Set the value to the selected gender
                items: <String>['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Set the selected gender when the user makes a selection
                  setState(() {
                    _selectedGender = newValue;
                    _genderController.text = newValue ?? ''; // Assign selected gender to the controller
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Gender',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 20.0),
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      SizedBox(height: 20.0),
      Center(
        child: SizedBox(
          width: 200.0,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              _signUp(
                _unameController.text,
                _passwordController.text,
                _fNameController.text,
                _dobController.text,
                _genderController.text, // Pass gender from the controller
                _emailController.text,
              );
            },
            child: Text('Sign Up'),
          ),
        ),
      ),
      SizedBox(height: 10.0),
      Center(
        child: TextButton(
          onPressed: _toggleMode,
          child: Text("Already have an account? Log in"),
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    _unameController.dispose();
    _passwordController.dispose();
    _fNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  DetailsScreen(this.userDetails);

  @override
  Widget build(BuildContext context) {
    List<String> columnsToDisplay = ['f_name', 'dob', 'email', 'u_name', 'gender']; // Example keys
    List<String> additionalDetailsKeys = ['qualification', 'address', 'pincode', 'state', 'skills', 'languages_known'];

    String formatDateOfBirth(String dob) {
      DateTime dobDate = DateTime.parse(dob);
      return '${dobDate.day}-${dobDate.month}-${dobDate.year}';
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 300,
              child: Drawer(
                elevation: 0,
                child: Container(
                  color: Color.fromARGB(255, 139, 200, 78),
                  padding: EdgeInsets.zero,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 120,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 1, 64, 96),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 16),
                              // Add your header content here
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Add and Edit Details'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddDetailsPage(
                                userDetails['candidate_id'].toString(),
                                userDetails: userDetails, // Pass userDetails here
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Apply for Jobs'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyForJobsPage(
                                userDetails: userDetails,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Application Status'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobStatusPage(
                                candidateId: userDetails['candidate_id'].toString(),
                              ),
                            ),
                          );
                        },
                      ),
                       
                      ListTile(
  title: Text('View Interviews'),
  onTap: () {
    // Convert the candidate ID to an integer before passing it to the CandidateInterviewsPage
    int candidateId = int.parse(userDetails['candidate_id'].toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidateInterviewsPage(
          candidateId: candidateId,
        ),
      ),
    );
  },
),
ListTile(
                        title: Text('Interview Status'),
                        onTap: () {
                          // Perform logout action here
                          // For example, navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InterviewStatus(
                                candidateId: userDetails['candidate_id'].toString(),
                                ),
                            ),
                          );
                        },
                      ),
 
                      // Logout Button
                      ListTile(
                        title: Text('Logout'),
                        onTap: () {
                          // Perform logout action here
                          // For example, navigate to the login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile', // Title "Profile"
                        style: TextStyle(
                          fontSize: 24, // Increase text size
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Set text color
                        ),
                      ),
                      SizedBox(height: 16), // Add spacing between title and profile details
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display basic profile details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: columnsToDisplay.map((key) {
                                    IconData iconData;
                                    String label;
                                    String value;
                                    Color color;

                                    switch (key) {
                                      case 'f_name':
                                        iconData = Icons.person;
                                        label = 'Full Name';
                                        value = userDetails[key];
                                        color = Colors.blue; // Example color
                                        break;
                                      case 'dob':
                                        iconData = Icons.calendar_today;
                                        label = 'Date of Birth';
                                        value = formatDateOfBirth(userDetails[key]);
                                        color = Colors.green; // Example color
                                        break;
                                      case 'email':
                                        iconData = Icons.email;
                                        label = 'Email';
                                        value = userDetails[key];
                                        color = Colors.orange; // Example color
                                        break;
                                      case 'u_name':
                                        iconData = Icons.account_circle;
                                        label = 'Username';
                                        value = userDetails[key];
                                        color = Colors.purple; // Example color
                                        break;
                                      case 'gender':
                                        iconData = Icons.people;
                                        label = 'Gender';
                                        value = userDetails[key];
                                        color = Colors.red; // Example color
                                        break;
                                      default:
                                        iconData = Icons.error;
                                        label = 'Unknown';
                                        value = 'Unknown';
                                        color = Colors.black; // Example color
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            iconData,
                                            size: 36, // Increase icon size
                                            color: color, // Set icon color
                                          ),
                                          SizedBox(width: 12), // Add spacing between icon and text
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                label,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18, // Increase text size
                                                  color: color, // Set text color
                                                ),
                                              ),
                                              Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 20, // Increase text size
                                                  color: color, // Set text color
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 24), // Add spacing between personal and additional details
                              // Display additional details if they are present
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: additionalDetailsKeys.map((key) {
                                    if (userDetails.containsKey(key) && userDetails[key] != null && userDetails[key] != '') {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              key.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18, // Increase text size
                                                color: Colors.blue, // Set text color
                                              ),
                                            ),
                                            Text(
                                              userDetails[key],
                                              style: TextStyle(
                                                fontSize: 20, // Increase text size
                                                color: Colors.blue, // Set text color
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox(); // Return an empty SizedBox if the detail is not present
                                    }
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDetailsPage extends StatefulWidget {
  final String candidateId;

  AddDetailsPage(this.candidateId, {required Map<String, dynamic> userDetails});

  @override
  _AddDetailsPageState createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _languagesKnownController = TextEditingController();

  bool _editingEnabled = false;

  @override
  void initState() {
    super.initState();
    fetchExistingDetails();
  }

  Future<void> fetchExistingDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/${widget.candidateId}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _qualificationController.text = jsonData['qualification'] ?? '';
          _addressController.text = jsonData['address'] ?? '';
          _pincodeController.text = jsonData['pincode'] ?? '';
          _stateController.text = jsonData['state'] ?? '';
          _skillsController.text = jsonData['skills'] ?? '';
          _languagesKnownController.text = jsonData['languages_known'] ?? '';
          _editingEnabled = false; // Disable editing initially
        });
      } else {
        print('Failed to fetch details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveOrUpdateDetails() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.211:3000/details'),
       body: jsonEncode({
  'candidate_id': widget.candidateId,
  'qualification': _qualificationController.text,
  'address': _addressController.text,
  'pincode': _pincodeController.text,
  'state': _stateController.text,
  'skills': _skillsController.text, // Include skills field here
  'languages_known': _languagesKnownController.text,
}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Details added/updated successfully
        Navigator.pop(context, true); // Navigate back to the previous screen
      } else {
        print('Failed to save details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              controller: _qualificationController,
              label: 'Qualification',
              icon: Icons.school,
              enabled: _editingEnabled, // Enable/disable editing based on _editingEnabled
            ),
            SizedBox(height: 16.0),
            _buildInputField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on,
              enabled: _editingEnabled, // Enable/disable editing based on _editingEnabled
            ),
            SizedBox(height: 16.0),
            _buildInputField(
              controller: _pincodeController,
              label: 'Pincode',
              icon: Icons.pin_drop,
              keyboardType: TextInputType.number,
              enabled: _editingEnabled, // Enable/disable editing based on _editingEnabled
            ),
            SizedBox(height: 16.0),
            _buildInputField(
              controller: _stateController,
              label: 'State',
              icon: Icons.location_city,
              enabled: _editingEnabled, // Enable/disable editing based on _editingEnabled
            ),
            SizedBox(height: 16.0),
            _buildSkillsField(), // Skills field with multiple input boxes
            SizedBox(height: 16.0),
            _buildInputField(
              controller: _languagesKnownController,
              label: 'Languages Known',
              icon: Icons.language,
              enabled: _editingEnabled, // Enable/disable editing based on _editingEnabled
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _editingEnabled ? saveOrUpdateDetails : () {
                // Enable editing when the button is pressed
                setState(() {
                  _editingEnabled = true;
                });
              },
              child: Text(_editingEnabled ? 'Update Details' : 'Edit Details'),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  required bool enabled,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      enabled: enabled,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Change border color to black
      ),
    ),
    keyboardType: keyboardType,
    enabled: enabled, // Enable/disable based on the provided parameter
  );
}


 Widget _buildSkillsField() {
  bool addComma = false; // Flag to track comma insertion

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.work),
              SizedBox(width: 12.0),
              Text('Skills', style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (var skill in _skillsController.text.split(','))
                if (skill.trim().isNotEmpty)
                  Chip(
                    label: Text(skill.trim()),
                    onDeleted: _editingEnabled
                        ? () {
                            setState(() {
                              // Remove the skill from the list
                              _skillsController.text = _skillsController.text.replaceFirst(skill.trim(), '').trim();
                            });
                          }
                        : null,
                  ),
              if (_editingEnabled)
                Container(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a skill',
                      isCollapsed: true,
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    onSubmitted: (value) {
                      setState(() {
                        // Add the new skill to the list
                        if (addComma) {
                          _skillsController.text += ', ';
                        }
                        _skillsController.text += value.trim();
                        addComma = true; // Set flag to true for next skill
                      });
                    },
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


class Requirement {
  final int id;
  final String jobTitle;
  final String qualification;
  final String experience;
  final int nov;
  final String priority;
  final String role;
  final DateTime openingDate;
  final DateTime closingDate;
  final int departmentId;
  final String jobdesc;
  final String skills;
  final String approvedBy;
  final String approvedBy1;
  final String approvedBy2;

  Requirement({
    required this.id,
    required this.jobTitle,
    required this.qualification,
    required this.experience,
    required this.nov,
    required this.priority,
    required this.role,
    required this.skills,

    required this.openingDate,
    required this.closingDate,
    required this.departmentId,
    required this.jobdesc,
    required this.approvedBy,
    required this.approvedBy1,
    required this.approvedBy2,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['JOB_ID'] ?? 0,
      jobTitle: json['JOB_TITLE'] ?? "",
      qualification: json['qualification'] ?? "",
      experience: json['experience'] ?? "",
      nov: json['NOV'] ?? 0,
      priority: json['priority'] ?? "",
      role: json['role'] ?? "",
      openingDate: DateTime.parse(json['OPENING_DATE'] ?? ""),
      closingDate: DateTime.parse(json['CLOSING_DATE'] ?? ""),
      departmentId: json['DEPT_ID'] ?? 0,
      jobdesc: json['JOB_DESC'] ?? "", // Ensure correct mapping for JOB_DESC field
      skills:json['skills']??"",
      approvedBy: json['APPROVED_BY_MANAGER'] ?? "",
      approvedBy1: json['APPROVED_BY_HR'] ?? "",
      approvedBy2: json['post'] ?? "",
    );
  }
}


class ApplyForJobsPage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  ApplyForJobsPage({required this.userDetails});

  @override
  _ApplyForJobsPageState createState() => _ApplyForJobsPageState();
}

class _ApplyForJobsPageState extends State<ApplyForJobsPage> {
  late Future<List<Requirement>> approvedRequirements2;

  @override
  void initState() {
    super.initState();
    approvedRequirements2 = fetchApprovedRequirements2();
  }

  Future<List<Requirement>> fetchApprovedRequirements2() async {
    final response = await http.get(Uri.parse('http://192.168.1.211:3000/api/approvedRequirementss'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<Requirement> allRequirements = list.map((model) => Requirement.fromJson(model)).toList();

      // Filter allRequirements to include only posted jobs and match the candidate's qualification and skills
     List<Requirement> approvedRequirements = allRequirements.where((req) {
  return req.approvedBy2 == 'posted' &&
      req.closingDate.isAfter(DateTime.now()) &&
      req.qualification == widget.userDetails['qualification'] &&
      req.skills != null && _skillsMatch(req.skills!, widget.userDetails['skills']); // Check if candidate's skills match job requirements
}).toList();

      return approvedRequirements;
    } else {
      throw Exception('Failed to load requirements');
    }
  }

  // Method to check if candidate's skills match job requirements
  bool _skillsMatch(String jobSkills, String candidateSkills) {
    List<String> candidateSkillList = candidateSkills.split(',');
    List<String> requiredSkills = jobSkills.split(',');
    for (var skill in requiredSkills) {
      if (candidateSkillList.contains(skill.trim())) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the DetailsScreen with userDetails
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(widget.userDetails),
          ),
        );
        return false; // Return false to prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Apply for Jobs'),
        ),
        body: FutureBuilder<List<Requirement>>(
          future: approvedRequirements2,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Requirement> requirements = snapshot.data!;
              return ListView.builder(
                itemCount: requirements.length,
                itemBuilder: (context, index) {
                  return FractionallySizedBox(
                    widthFactor: 0.5, // Adjust width factor as needed
                    child: Container(
                      height: 400.0, // Adjust height as needed
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requirements[index].jobTitle,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('Job ID: ${requirements[index].id}'),
                          Text('Qualification: ${requirements[index].qualification}'),
                          Text('Experience: ${requirements[index].experience}'),
                          Text('Department ID: ${requirements[index].departmentId}'),
                          Text('Job Description: ${requirements[index].jobdesc}'),
                          Text('Number of Vacancies: ${requirements[index].nov}'),
                          Text('Opening Date: ${DateFormat('yyyy-MM-dd').format(requirements[index].openingDate)}'),
                          Text('Closing Date: ${DateFormat('yyyy-MM-dd').format(requirements[index].closingDate)}'),
                          Text('Role: ${requirements[index].role}'),
                          SizedBox(height: 8.0),
                          _skillsMatch(requirements[index].skills ?? '', widget.userDetails['skills'])
                              ? Text('Your skills match the job requirements')
                              : Text('Your skills do not match the job requirements'),
                          SizedBox(height: 8.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to another page when the "Apply Now" button is pressed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadResumePage(
                                      candidateId: widget.userDetails['candidate_id'].toString(),
                                      jobId: requirements[index].id,
                                      jobTitle: requirements[index].jobTitle,
                                      departmentId: requirements[index].departmentId.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Apply Now'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}





class UploadResumePage extends StatefulWidget {
  final String candidateId;
  final int jobId;
  final String jobTitle;
  final String departmentId;
   UploadResumePage({required this.candidateId,required this.jobId,
    required this.jobTitle,required this.departmentId});
  @override
  _UploadResumePageState createState() => _UploadResumePageState();
}

class _UploadResumePageState extends State<UploadResumePage> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  bool _uploading = false;
  
  get departmentId => null;

  Future<void> _uploadResume(String resume, String full_name, String address1, String address2, String qualification, int jobId, String jobTitle) async {
  // Remove the following line since `candidateId` is accessed via `widget.candidateId`
  // String candidateId = widget.candidateId;

  setState(() {
    _uploading = true;
  });

  try {
    // Check application existence
    var checkResponse = await http.get(
      Uri.parse('http://192.168.1.211:3000/api/check-application?candidateId=${widget.candidateId}&jobId=$jobId'),
    );

    if (checkResponse.statusCode == 200) {
      final parsedResponse = json.decode(checkResponse.body);
      if (parsedResponse['exists']) {
        // Application already exists, show error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('You have already applied for this job.'),
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
        setState(() {
          _uploading = false;
        });
        return;
      }
    } else {
      print('Failed to check application existence: ${checkResponse.statusCode}');
      setState(() {
        _uploading = false;
      });
      return;
    }

    // Send resume URL and other details to server as JSON
    var response = await http.post(
      Uri.parse('http://192.168.1.211:3000/uploads'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'resume': resume,
        'full_name': full_name,
        'address1': address1,
        'address2': address2,
        'qualification': qualification,
        'candidate_id': widget.candidateId, // Use widget.candidateId here
        'JOB_ID': jobId, // Include job ID
        'JOB_TITLE': jobTitle,
         'DEPT_ID': widget.departmentId,  // Include job title
      }),
    );

    if (response.statusCode == 200) {
  // Handle successful upload
  print('Resume link uploaded successfully');
} else {
  // Handle failed upload
  print('Failed to upload resume link: ${response.body}');
}

  } catch (e) {
    print('Error uploading resume link: $e');
  }

  setState(() {
    _uploading = false;
  });
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTextFieldWithIcon(_urlController, Icons.link, 'Resume URL'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(_fullNameController, Icons.person, 'Full Name'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(_addressController, Icons.location_on, 'Address'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(_address2Controller, Icons.location_on, 'Address 2'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(_qualificationController, Icons.school, 'Qualification'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading
                  ? null
                  : () {
                      String resume = _urlController.text.trim();
                      String full_name = _fullNameController.text.trim();
                      String address1 = _addressController.text.trim();
                      String address2 = _address2Controller.text.trim();
                      String qualification = _qualificationController.text.trim();
                      if (resume.isNotEmpty && full_name.isNotEmpty && address1.isNotEmpty && address2.isNotEmpty && qualification.isNotEmpty) {
                        _uploadResume(resume, full_name, address1, address2, qualification, widget.jobId, widget.jobTitle);
                      }
                    },
              child: _uploading
                  ? CircularProgressIndicator() // Show loading indicator while uploading
                  : Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(TextEditingController controller, IconData icon, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(
        fontSize: 18.0,
      ),
    );
  }
}



class JobStatusPage extends StatefulWidget {
  final String candidateId;

  JobStatusPage({required this.candidateId});

  @override
  _JobStatusPageState createState() => _JobStatusPageState();
}

class _JobStatusPageState extends State<JobStatusPage> {
  List<dynamic> applications = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.candidateId);
  }

  void fetchData(String candidateId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/applicantss/$candidateId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedResponse = json.decode(response.body);
        print('Fetched leave applications: $parsedResponse');
        setState(() {
          applications = parsedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch leave applications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching leave applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Status'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: applications.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light shaded background color
                      borderRadius: BorderRadius.circular(10.0), // Optional: Apply border radius
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Job Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'DEPT ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Qualification',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: applications.map((application) {
                        return DataRow(cells: [
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text('${application['JOB_TITLE']}'),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text('${application['DEPT_ID']}'),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
  padding: EdgeInsets.symmetric(vertical: 8.0),
  child: Center(
    child: Text(
      application['status'] == 'Approved' ? 'Accepted' : 'Rejected',
      style: TextStyle(
        color: application['status'] == 'Approved' ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text('${application['qualification']}'),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}




class CandidateInterviewsPage extends StatefulWidget {
  final int candidateId;

  CandidateInterviewsPage({required this.candidateId});

  @override
  _CandidateInterviewsPageState createState() =>
      _CandidateInterviewsPageState();
}

class _CandidateInterviewsPageState extends State<CandidateInterviewsPage> {
  List<dynamic> interviews = [];

  @override
  void initState() {
    super.initState();
    fetchInterviews();
  }

  Future<void> fetchInterviews() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.211:3000/api/interviewss/${widget.candidateId}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          interviews = jsonDecode(response.body);
        });
      } else {
        print('Failed to fetch interviews');
      }
    } catch (e) {
      print('Error fetching interviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Interviews'),
      ),
      body: Container(
        width:600,
        height:400,
        child: interviews.isEmpty
            ? Center(
                child: Text('No scheduled interviews found.'),
              )
            : ListView.builder(
                itemCount: interviews.length,
                itemBuilder: (context, index) {
                  final interview = interviews[index];
                  // Parse interview date and time
                  DateTime interviewDate =
                      DateTime.parse(interview['interview_date']);
                  TimeOfDay interviewTime =
                      TimeOfDay.fromDateTime(DateTime.parse(interview['interview_time']));

                  // Format date and time strings
                  String formattedDate =
                      '${interviewDate.day.toString().padLeft(2, '0')}-${interviewDate.month.toString().padLeft(2, '0')}-${interviewDate.year}';
                  String formattedTime =
                      '${interviewTime.hour}:${interviewTime.minute.toString().padLeft(2, '0')}';

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.event_note),
                      title: Text(
                        'Interview ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text('Candidate ID: ${interview['candidate_id']}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.work),
                              SizedBox(width: 5),
                              Text('Job Title: ${interview['JOB_TITLE']}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.timeline),
                              SizedBox(width: 5),
                              Text('Interview Level: ${interview['interview_level']}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 5),
                              Text('Interview Date: $formattedDate'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.access_time),
                              SizedBox(width: 5),
                              Text('Interview Time: $formattedTime'),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      onTap: () {
                        // Add any action you want to perform on tapping the item
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}



class InterviewStatus extends StatefulWidget {
  final String candidateId;

  InterviewStatus({required this.candidateId});

  @override
  _InterviewStatusState createState() => _InterviewStatusState();
}

class _InterviewStatusState extends State<InterviewStatus> {
  List<dynamic> interviews = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.candidateId);
  }

  void fetchData(String candidateId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/interviewss/$candidateId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsedResponse = json.decode(response.body);
        print('Fetched interviews: $parsedResponse');
        setState(() {
          interviews = parsedResponse;
        });
      } else {
        print('Failed to fetch interviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching interviews: $e');
    }
  }



@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Status'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: interviews.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light shaded background color
                      borderRadius: BorderRadius.circular(10.0), // Optional: Apply border radius
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Interview ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: interviews.map((interview) {
                        return DataRow(cells: [
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text('${interview['interview_id']}'),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  interview['pass_fail'] == 'pass' ? 'Passed' : 'Failed',
                                  style: TextStyle(
                                    color: interview['pass_fail'] == 'pass' ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}