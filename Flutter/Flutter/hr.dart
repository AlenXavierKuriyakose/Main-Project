//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:login/userlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';




//import 'package:intl/intl.dart'; // Import the intl package


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = true;
  bool _showAddDepartmentForm = false;
  bool _showAddDesignationForm = false;
  bool _showManageDepartment = false;
  bool _showAddEmployeeForm = false;
  bool _showManageDesignation=false;
  bool _showManageEmployee=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isDrawerOpen ? 300 : 0,
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
                            Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 50,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'HRMS',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                      },
                    ),
                    ExpansionTile(
                      title: Text(
                        'Department',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Department',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDesignation=false;
                                _showAddDepartmentForm = true;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                _showAddEmployeeForm = false;
                                _showManageEmployee=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Department',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDesignation=false;
                                _showManageDepartment = true;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showAddEmployeeForm = false;
                                _showManageEmployee=false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'Designation',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Designation',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDesignation=false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = true;
                                _showManageDepartment = false;
                                _showAddEmployeeForm = false;
                                _showManageEmployee=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Designation',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageDesignation=true;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showAddEmployeeForm = false;
                                _showManageEmployee=false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        'Employees',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Add Employee',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showAddEmployeeForm = true;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                                _showManageDepartment = false;
                                _showManageDesignation=false;
                                _showManageEmployee=false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ListTile(
                            tileColor: Colors.blueGrey,
                            title: Text(
                              'Manage Employee',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _showManageEmployee=true;
                                _showManageDesignation=false;
                                _showManageDepartment = false;
                                _showAddDepartmentForm = false;
                                _showAddDesignationForm = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
              ExpansionTile(
  title: Text(
    'Job Requirements',
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
  children: [
    Padding(
      padding: EdgeInsets.only(left: 30),
      child: ListTile(
        tileColor: Colors.blueGrey,
        title: Text(
          'View Requirements',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ApprovedRequirementsPage()),
  );
},
      ),
    ),
  ],
),  
 ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Job Posting',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JobPostingForm()),
  );
},
                    ),
                     ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'View Applicants',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ViewApplicationsPage()),
  );
},
                    ),

                    ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Interview Schedule',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => InterviewPage()),
  );
},

                    ),
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

                    /*ListTile(
                      tileColor: Colors.blueGrey,
                      title: Text(
                        'Documents',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              setState(() {
                _isDrawerOpen = !_isDrawerOpen;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _showAddDepartmentForm
                  ? AddDepartmentPage()
                  : (_showAddDesignationForm
                      ? AddDesignationPage()
                      : (_showManageDepartment
                          ? ManageDepartmentPage()
                          : (_showManageDesignation
                          ? ManageDesignationPage()
                          : (_showAddEmployeeForm
                              ? AddEmployeePage()
                              : (_showManageEmployee
                              ? ManageEmployeePage() // Show the employee form here
                              : MainContent()))))),
            ),
          ),
        ],
      ),
    );
  }
}
class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                //DashboardCard(icon: Icons.person, title: 'Employees', value: '55', iconColor: Colors.orange),
                //DashboardCard(icon: Icons.airplane_ticket, title: 'Leave', value: '25', iconColor: Colors.green),
                DashboardCard(icon: Icons.check, title: 'Approved', value: '34', iconColor: Colors.blue),
                DashboardCard(icon: Icons.info, title: 'Pending', value: '12', iconColor: Colors.orange),
                DashboardCard(icon: Icons.delete, title: 'Canceled', value: '15', iconColor: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  DashboardCard({required this.icon, required this.title, required this.value, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 10,
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 70, color: iconColor),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddDepartmentPage extends StatefulWidget {
  @override
  _AddDepartmentPageState createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final TextEditingController _departmentNameController = TextEditingController();
  final TextEditingController _departmentDescriptionController = TextEditingController();

  // Function to submit the department data
  Future<void> _submitForm() async {
    const String serverUrl = 'http://192.168.1.211:3000/api/adddep';
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'DEPT_NAME': _departmentNameController.text,
          'DEPT_SHORT_NAME': _departmentDescriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Data inserted successfully!');
      } else {
        print('Data insertion failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
 Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.add_circle, color: Colors.blue), // Icon for "Add Department"
            SizedBox(width: 10),
            Text(
              'Add Department',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
        
        SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _departmentNameController,
              decoration: InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _departmentDescriptionController,
              decoration: InputDecoration(
                labelText: 'Department Short Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
       
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Set button color to blue
          ),
          child: Text('Submit'),
        ),
      ],
    ),
  );
}

}

class AddDesignationPage extends StatefulWidget {
  @override
  _AddDesignationPageState createState() => _AddDesignationPageState();
}

class _AddDesignationPageState extends State<AddDesignationPage> {
  final TextEditingController _designationNameController = TextEditingController();
  final TextEditingController _designationDescriptionController = TextEditingController();
  final TextEditingController _minexpController = TextEditingController();
  final TextEditingController _maxexpController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();




  Future<void> _submitForm() async {
  const String serverUrl = 'http://192.168.1.211:3000/api/adddes';
  try {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'DESIGN_NAME': _designationNameController.text,
        'DESIGN_DESC': _designationDescriptionController.text,
        'MIN_EXP': _minexpController.text,
        'MAX_EXP': _maxexpController.text,
        'QUALIFICATION': _qualificationController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Data inserted successfully!');
    } else {
      print('Data insertion failed. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

  @override
  void dispose() {
    _designationNameController.dispose();
    _designationDescriptionController.dispose();
    _minexpController.dispose();
    _maxexpController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(5.0),
      constraints: BoxConstraints(maxWidth: 300, maxHeight: 500), // Increase maxHeight
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, color: Color.fromARGB(227, 230, 78, 8)), // Icon for "Add Designation"
              SizedBox(width: 10),
              Text(
                'Add Designation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 244, 92, 5)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _designationNameController,
              decoration: InputDecoration(
                labelText: 'Designation Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _designationDescriptionController,
              decoration: InputDecoration(
                labelText: 'Designation Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _minexpController,
              decoration: InputDecoration(
                labelText: 'Minimum Experience ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _maxexpController,
              decoration: InputDecoration(
                labelText: 'Maximum Experience',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 500, // Adjust the width as needed
            height: 50, // Adjust the height as needed
            child: TextFormField(
              controller: _qualificationController,
              decoration: InputDecoration(
                labelText: 'Qualification ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Set button color to blue
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    ),
  );
}



}

class ManageDepartmentPage extends StatefulWidget {
  @override
  _ManageDepartmentPageState createState() => _ManageDepartmentPageState();
}

class _ManageDepartmentPageState extends State<ManageDepartmentPage> {
  Future<List<Map<String, dynamic>>> _fetchDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/managedept'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve department details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve department details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void _editDepartment(int index) {
    // Implement edit department functionality
    print('Edit department at index: $index');
  }

  void _deleteDepartment(int index) {
    // Implement delete department functionality
    print('Delete department at index: $index');
  }

  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Department',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchDepartments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final departments = snapshot.data!;
                return DataTable(
                  columns: [
                    DataColumn(label: Text('Department ID')),
                    DataColumn(label: Text('Department Name')),
                    DataColumn(label: Text('Department Short Name')),
                    DataColumn(label: Text('Action')), // Added action column
                  ],
                  rows: departments.map((department) {
                    return DataRow(cells: [
                      DataCell(Text(department['DEPT_ID'].toString())),
                      DataCell(Text(department['DEPT_NAME'])),
                      DataCell(Text(department['DEPT_SHORT_NAME'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editDepartment(departments.indexOf(department)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteDepartment(departments.indexOf(department)),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

}



class ManageDesignationPage extends StatefulWidget {
  @override
  _ManageDesignationPageState createState() => _ManageDesignationPageState();
}

class _ManageDesignationPageState extends State<ManageDesignationPage> {
  Future<List<Map<String, dynamic>>> _fetchDesignations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/managedesign'),
      );
    
      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve designation details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve designation details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void _editDesignation(int index) {
    // Implement edit designation functionality
    print('Edit designation at index: $index');
  }

  void _deleteDesignation(int index) {
    // Implement delete designation functionality
    print('Delete designation at index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Designation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchDesignations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final designations = snapshot.data!;
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('DESIGN_ID')),
                      DataColumn(label: Text('DESIGN_NAME')),
                      DataColumn(label: Text('DESIGN_DESC ')),
                      DataColumn(label: Text('MIN_EXP ')),
                      DataColumn(label: Text('MAX_EXP ')),
                      DataColumn(label: Text('QUALIFICATION  ')),
                      DataColumn(label: Text('Action')), // Added action column
                    ],
                    rows: designations.map((designation) {
                      return DataRow(cells: [
                        DataCell(Text(designation['DESIGN_ID'].toString())),
                        DataCell(Text(designation['DESIGN_NAME'])),
                        DataCell(Text(designation['DESIGN_DESC'])),
                        DataCell(Text(designation['MIN_EXP'].toString())),
                        DataCell(Text(designation['MAX_EXP'].toString())),
                        DataCell(Text(designation['QUALIFICATION'])),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editDesignation(designations.indexOf(designation)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteDesignation(designations.indexOf(designation)),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['DEPT_ID'],
      name: json['DEPT_NAME'],
    );
  }
}

class Designation {
  final int id;
  final String name;

  Designation({required this.id, required this.name});

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      id: json['DESIGN_ID'],
      name: json['DESIGN_NAME'],
    );
  }
}




class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  String? _selectedGender;
  late Future<List<Department>> department;
  late Future<List<Designation>> designation;
  String? selectedDepartmentName;
  String? selectedDesignationName;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    department = fetchDepartments();
    designation = fetchDesignations();
  }

  Future<List<Department>> fetchDepartments() async {
    final response = await http.get(Uri.parse('http://192.168.1.211:3000/api/managedept'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Department.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<List<Designation>> fetchDesignations() async {
    final response = await http.get(Uri.parse('http://192.168.1.211:3000/api/managedesign'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Designation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load designations');
    }
  }

  Future<void> _submitForm(
    String firstName, String middleName, String lastName, String age,
    String email, String contact, String username, String password,
    String departmentName, String designationName, String gender) async {
    // Retrieve the ID corresponding to the selected department name
    final selectedDepartment = (await department).firstWhere(
      (dept) => dept.name == departmentName,
      orElse: () => throw Exception('Department not found'),
    );
    final selectedDepartmentId = selectedDepartment.id;

    // Retrieve the ID corresponding to the selected designation name
    final selectedDesignation = (await designation).firstWhere(
      (desig) => desig.name == designationName,
      orElse: () => throw Exception('Designation not found'),
    );
    final selectedDesignationId = selectedDesignation.id;

    final response = await http.post(
      Uri.parse('http://192.168.1.211:3000/api/addemp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'age': age,
        'email': email,
        'phno': contact,
        'DEPT_ID': selectedDepartmentId,
        'DESIGN_ID': selectedDesignationId,
        'gender':_selectedGender,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('Employee inserted successfully');
    } else {
      throw Exception('Failed to insert employee');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Employee',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Middle Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _middleNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(width: 20),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            items: ['Male', 'Female', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
  
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<List<Department>>(
                      future: department,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Department>? departmentList = snapshot.data;
                          return DropdownButtonFormField<String>(
                            value: selectedDepartmentName,
                            items: departmentList!.map((Department department) {
                              return DropdownMenuItem<String>(
                                value: department.name,
                                child: Text(department.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartmentName = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Designation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<List<Designation>>(
                      future: designation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Designation>? designationList = snapshot.data;
                          return DropdownButtonFormField<String>(
                            value: selectedDesignationName,
                            items: designationList!.map((Designation designation) {
                              return DropdownMenuItem<String>(
                                value: designation.name,
                                child: Text(designation.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDesignationName = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedDepartmentName != null &&
                  selectedDesignationName != null &&
                  _selectedGender!=null &&
                  _firstNameController.text.isNotEmpty &&
                  _middleNameController.text.isNotEmpty &&
                  _lastNameController.text.isNotEmpty &&
                  _ageController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty &&
                  _contactController.text.isNotEmpty &&
                  _usernameController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty) {
                _submitForm(
                  _firstNameController.text,
                  _middleNameController.text,
                  _lastNameController.text,
                  _ageController.text,
                  _emailController.text,
                  _contactController.text,
                  _usernameController.text,
                  _passwordController.text,
                  selectedDepartmentName!,
                  selectedDesignationName!,
                  _selectedGender!,
                );
              } else {
                // Show a message or take appropriate action when any field is not selected/filled
              }
            },
            child: Text('Save Employee'),
          ),
        ],
      ),
    );
  }
}

class ManageEmployeePage extends StatefulWidget {
  @override
  _ManageEmployeePageState createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
  Future<List<Map<String, dynamic>>> _fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/manageemp'),
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse is List<dynamic>) {
          return List<Map<String, dynamic>>.from(parsedResponse);
        } else {
          print('Failed to retrieve employee details: Invalid response format');
          return [];
        }
      } else {
        print('Failed to retrieve employee details: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void _editEmployee(int index) {
    // Implement edit employee functionality
    print('Edit employee at index: $index');
  }

  void _deleteEmployee(int index) {
    // Implement delete employee functionality
    print('Delete employee at index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Employee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final employees = snapshot.data!;
                  return DataTable(
                    columns: [
                      DataColumn(label: Text('EMPLOYEE_ID')),
                      DataColumn(label: Text('FIRST_NAME')),
                      DataColumn(label: Text('LAST_NAME')),
                      DataColumn(label: Text('AGE')),
                      DataColumn(label: Text('EMAIL')),
                      DataColumn(label: Text('PHONE')),
                      DataColumn(label: Text('DEPARTMENT')),
                      DataColumn(label: Text('DESIGNATION')),
                      DataColumn(label: Text('GENDER')),
                      DataColumn(label: Text('USERNAME')),
                      DataColumn(label: Text('Action')), // Added action column
                    ],
                    rows: employees.map((employee) {
                      return DataRow(cells: [
                        DataCell(Text(employee['employee_id'].toString())),
                        DataCell(Text(employee['first_name'])),
                        DataCell(Text(employee['last_name'])),
                        DataCell(Text(employee['age'].toString())),
                        DataCell(Text(employee['email'])),
                        DataCell(Text(employee['phno'])),
                        DataCell(Text(employee['DEPT_ID'].toString())),
                        DataCell(Text(employee['DESIGN_ID'].toString())),
                        DataCell(Text(employee['gender'])),
                        DataCell(Text(employee['username'])),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editEmployee(employees.indexOf(employee)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteEmployee(employees.indexOf(employee)),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
                }
              },
            ),
          ],
          
        ),
      ),
    );
  }
}







class Requirement {
  final int id;
  final String jobTitle;
  final int nov;
  final String priority;
  final String role;
  final DateTime openingDate;
  final DateTime closingDate;
  final int departmentId;
  String approvedBy; // Changed to non-final for updating
  String approvedBy1;
  String approvedBy2;

  Requirement({
    required this.id,
    required this.jobTitle,
    required this.nov,
    required this.priority,
    required this.role,
    required this.openingDate,
    required this.closingDate,
    required this.departmentId,
    required this.approvedBy,
    required this.approvedBy1,
    required this.approvedBy2,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      id: json['JOB_ID'] ?? 0,
      jobTitle: json['JOB_TITLE'] ?? "",
      nov: json['NOV'] ?? 0,
      priority: json['priority'] ?? "",
      role: json['role'] ?? "",
      openingDate: DateTime.parse(json['OPENING_DATE'] ?? ""),
      closingDate: DateTime.parse(json['CLOSING_DATE'] ?? ""),
      departmentId: json['DEPT_ID'] ?? 0,
      approvedBy: json['APPROVED_BY_MANAGER'] ?? "", // Updated field name
      approvedBy1: json['APPROVED_BY_HR'] ?? "",
      approvedBy2: json['post'] ?? "",
    );
  }
}

class ApprovedRequirementsPage extends StatefulWidget {
  @override
  _ApprovedRequirementsPageState createState() =>
      _ApprovedRequirementsPageState();
}

class _ApprovedRequirementsPageState extends State<ApprovedRequirementsPage> {
  late Future<List<Requirement>> approvedRequirements;

  @override
  void initState() {
    super.initState();
    approvedRequirements = fetchApprovedRequirements();
  }

  Future<List<Requirement>> fetchApprovedRequirements() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.211:3000/api/approvedRequirements'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<Requirement> allRequirements =
          list.map((model) => Requirement.fromJson(model)).toList();
      return allRequirements;
    } else {
      throw Exception('Failed to load requirements');
    }
  }

  Future<void> updateRequirementApproval(
      int requirementId, String action) async {
    String actionText = action == 'Approved' ? 'Approved' : 'Rejected';
    try {
      final response = await http.put(
        Uri.parse(
            'http://192.168.1.211:3000/api/${action.toLowerCase()}/$requirementId'),
        body: json.encode({'APPROVED_BY_HR': action}), // Update APPROVED_BY_HR
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$actionText successfully'),
            backgroundColor: action == 'Approved' ? Colors.green : Colors.red,
          ),
        );
        setState(() {
          approvedRequirements = fetchApprovedRequirements();
          // Store approval status in SharedPreferences
          storeApprovalStatus(requirementId, action);
        });
      } else {
        throw Exception('Failed to update requirement');
      }
    } catch (error) {
      throw Exception('Failed to update requirement: $error');
    }
  }

  Future<void> storeApprovalStatus(
      int requirementId, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('$requirementId', action);
  }

  Future<String?> getApprovalStatus(int requirementId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('$requirementId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requirements List'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade100,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: FutureBuilder<List<Requirement>>(
          future: approvedRequirements,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Requirement> requirementList = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Job ID')),
                    DataColumn(label: Text('Job Title')),
                    DataColumn(label: Text('No of Vacancies')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Opening Date')),
                    DataColumn(label: Text('Closing Date')),
                    DataColumn(label: Text('Department ID')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: requirementList.map((requirement) {
                    return DataRow(
                      cells: [
                        DataCell(Text(requirement.id.toString())),
                        DataCell(Text(requirement.jobTitle)),
                        DataCell(Text(requirement.nov.toString())),
                        DataCell(Text(requirement.role)),
                        DataCell(Text(DateFormat('dd-MM-yyyy')
                            .format(requirement.openingDate))),
                        DataCell(Text(DateFormat('dd-MM-yyyy')
                            .format(requirement.closingDate))),
                        DataCell(Text(requirement.departmentId.toString())),
                        DataCell(
                          FutureBuilder<String?>(
                            future: getApprovalStatus(requirement.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.data == null) {
                                return Text(requirement.approvedBy); // Show the current approval status
                              } else {
                                String? approvalStatus = snapshot.data;
                                return Text(approvalStatus!);
                              }
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    updateRequirementApproval(requirement.id, 'Approved'),
                                child: Text('Approve'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    updateRequirementApproval(requirement.id, 'Rejected'),
                                child: Text('Reject'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}




class JobPostingForm extends StatefulWidget {
  @override
  _JobPostingFormState createState() => _JobPostingFormState();
}

class _JobPostingFormState extends State<JobPostingForm> {
  late Future<List<Requirement>> approvedRequirements1;

  @override
  void initState() {
    super.initState();
    approvedRequirements1 = fetchApprovedRequirements1();
  }

  Future<List<Requirement>> fetchApprovedRequirements1() async {
    final response = await http.get(Uri.parse('http://192.168.1.211:3000/api/approvedRequirementss'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<Requirement> allRequirements = list.map((model) => Requirement.fromJson(model)).toList();
      List<Requirement> approvedRequirements = allRequirements.where((req) => req.approvedBy1 == 'Approved').toList();
      return approvedRequirements;
    } else {
      throw Exception('Failed to load requirements');
    }
  }

 Future<void> updateRequirementApproval2(int requirementId, String action) async {
  try {
    final response = await http.put(
      Uri.parse('http://192.168.1.211:3000/api/${action.toLowerCase()}/$requirementId'),
      body: json.encode({'post': action}), // Use the action (approved or rejected) to update APPROVED_BY_HR
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Posted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        approvedRequirements1 = fetchApprovedRequirements1();
      });
    } else {
      throw Exception('Failed to update requirement');
    }
  } catch (error) {
    throw Exception('Failed to update requirement: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Form'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 211, 191, 214), // Light purple
              Color.fromARGB(255, 211, 186, 215), // Purple
            ],
          ),
        ),
        child: FutureBuilder<List<Requirement>>(
          future: approvedRequirements1,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Requirement> requirementList = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Job ID')),
                    DataColumn(label: Text('Job Title')),
                    DataColumn(label: Text('No of Vacancies')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Opening Date')),
                    DataColumn(label: Text('Closing Date')),
                    DataColumn(label: Text('Department ID')),
                    DataColumn(label: Text('Approved By')),
                  ],
                  rows: requirementList.map((requirement) {
                    return DataRow(
                      cells: [
                        DataCell(Text(requirement.id.toString())),
                        DataCell(Text(requirement.jobTitle)),
                        DataCell(Text(requirement.nov.toString())),
                        DataCell(Text(requirement.role)),
                        DataCell(Text(requirement.openingDate.toString())),
                        DataCell(Text(requirement.closingDate.toString())),
                        DataCell(Text(requirement.departmentId.toString())),
                        //DataCell(Text(requirement.approvedBy)),
                        DataCell(Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => updateRequirementApproval2(requirement.id, 'post'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue, // Button color
                                onPrimary: Colors.white, // Text color
                              ),
                              child: Text('Post'),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}


class ViewApplicationsPage extends StatefulWidget {
  @override
  _ViewApplicationsPageState createState() => _ViewApplicationsPageState();
}

class _ViewApplicationsPageState extends State<ViewApplicationsPage> {
  List<dynamic> applications = []; // List to store application data

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch application data when the widget is initialized
  }

  Future<void> fetchData() async {
    try {
      // Fetch application data from the server
      var response = await http.get(
        Uri.parse('http://192.168.1.211:3000/api/applicants'), // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        setState(() {
          // Update the applications list with the retrieved data
          applications = jsonDecode(response.body);
        });
      } else {
        // Handle failed API call
        print('Failed to fetch applications');
      }
    } catch (e) {
      print('Error fetching applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications'),
      ),
      body: applications.isEmpty
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator while fetching data
            )
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Candidate: ${application['full_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Candidate ID: ${application['candidate_id']}'),
                        Text('Job ID: ${application['JOB_ID']}'),
                        Text('Job Title: ${application['JOB_TITLE']}'),
                        Text('DEPT ID: ${application['DEPT_ID']}'),
                        Text('Qualification: ${application['qualification']}'),

                        GestureDetector(
                          onTap: () {
                            _launchURL(application['resume']);
                          },
                          child: Text(
                            'Resume: ${application['resume']}',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to application details page or perform other actions
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle selecting the applicant
                            _handleSelection(application['candidate_id'], application['JOB_ID'], true);
                          },
                          child: Text('Select'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Handle rejecting the applicant
                            _handleSelection(application['candidate_id'], application['JOB_ID'], false);
                          },
                          child: Text('Reject'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _handleSelection(int candidateId, int jobId, bool isSelected) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.211:3000/api/${isSelected ? 'selecta' : 'rejecta'}/$candidateId/$jobId'),
        body: json.encode({'status': isSelected ? 'selected' : 'rejected'}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Handle success response
        print('Job $jobId of candidate $candidateId is ${isSelected ? 'selected' : 'rejected'}');
      } else {
        throw Exception('Failed to update status');
      }
    } catch (error) {
      // Handle error
      throw Exception('Failed to update status: $error');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}




class InterviewPage extends StatefulWidget {
  @override
  _InterviewPageState createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  List<dynamic> approvedApplications = [];

  @override
  void initState() {
    super.initState();
    fetchApprovedApplications();
  }

  Future<void> fetchApprovedApplications() async {
    // Replace the URL with your API endpoint
    final response = await http.get(Uri.parse('http://192.168.1.211:3000/interview?status=Approved'));

    if (response.statusCode == 200) {
      setState(() {
        approvedApplications = json.decode(response.body);
      });
    } else {
      print('Failed to fetch approved applications: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved Applications'),
        actions: [
          IconButton(
            icon: Icon(Icons.schedule), // Schedule interview icon
            onPressed: () {
              // Add logic to navigate to schedule interview page
            },
          ),
        ],
      ),
      body: approvedApplications.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Candidate ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Application ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Job Title', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Department ID', style: TextStyle(fontWeight: FontWeight.bold))),

                  DataColumn(label: Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold))), // Schedule button column
                  // Add more DataColumn as needed
                ],
                rows: approvedApplications.map((application) {
                  return DataRow(cells: [
                    DataCell(Row(
                      children: [
                        Icon(Icons.person), // Candidate ID icon
                        SizedBox(width: 5),
                        Text('${application['candidate_id']}'),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        Icon(Icons.assignment), // Application ID icon
                        SizedBox(width: 5),
                        Text('${application['app_id']}'),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        Icon(Icons.person), // Full Name icon
                        SizedBox(width: 5),
                        Text('${application['full_name']}'),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        Icon(Icons.work), // Job Title icon
                        SizedBox(width: 5),
                        Text('${application['JOB_TITLE']}'),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        Icon(Icons.assignment), // ID icon
                        SizedBox(width: 5),
                        Text('${application['DEPT_ID']}'),
                      ],
                    )),
                    DataCell(ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleInterview(
                              candidateId: application['candidate_id'],
                              applicationId: application['app_id'],
                              fullName: application['full_name'],
                              jobTitle: application['JOB_TITLE'],
                              departmentId: application['DEPT_ID'],
                            ),),);
                        // Add logic to schedule interview
                      },
                      icon: Icon(Icons.calendar_today), // Schedule icon
                      label: Text('Schedule'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set button color
                      ),
                    )),
                    // Add more DataCell as needed
                  ]);
                }).toList(),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}


class ScheduleInterview extends StatefulWidget {
  final int candidateId;
  final int applicationId;
  final String fullName;
  final String jobTitle;
  final int departmentId;

  ScheduleInterview({
    required this.candidateId,
    required this.applicationId,
    required this.fullName,
    required this.jobTitle,
    required this.departmentId,
  });

  @override
  _ScheduleInterviewState createState() => _ScheduleInterviewState();
}

class _ScheduleInterviewState extends State<ScheduleInterview> {
  String interviewLevel = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String formFieldMessage = '';

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null) {
    setState(() {
      selectedDate = pickedDate;
    });
  }
}





  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (pickedTime != null) {
    setState(() {
      selectedTime = pickedTime;
    });
  }
}


  Future<void> _scheduleInterview() async {
    final String apiUrl = 'http://192.168.1.211:3000/api/addinterview';

    final Map<String, dynamic> interviewData = {
      'candidate_id': widget.candidateId,
      'app_id': widget.applicationId,
      'full_name': widget.fullName,
      'JOB_TITLE': widget.jobTitle,
      'interview_level': interviewLevel,
      'DEPT_ID': widget.departmentId,
    };

    if (selectedDate != null && selectedTime != null) {
  final formattedDate = selectedDate!.toIso8601String().split('T')[0];
  final formattedTime = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
  interviewData['interview_date'] = formattedDate;
  interviewData['interview_time'] = formattedTime;
}


    try {
      if (interviewData.containsValue(null)) {
        throw Exception('One or more values in interviewData are null');
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(interviewData),
      );

      if (response.statusCode == 200) {
        setState(() {
          formFieldMessage = 'Interview scheduled successfully!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(formFieldMessage)),
        );
      } else if (response.statusCode == 400) {
        setState(() {
          formFieldMessage = 'Interview already scheduled!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(formFieldMessage)),
        );
      } else {
        setState(() {
          formFieldMessage = 'Failed to schedule interview';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(formFieldMessage)),
        );
      }
    } catch (error) {
      setState(() {
        formFieldMessage = 'Error scheduling interview: $error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(formFieldMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'Schedule Interview',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.lightGreen,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.candidateId.toString(),
                            decoration: InputDecoration(
                              labelText: 'Candidate ID',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.card_membership),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.applicationId.toString(),
                            decoration: InputDecoration(
                              labelText: 'Application ID',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.fullName,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.work),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: widget.jobTitle,
                            decoration: InputDecoration(
                              labelText: 'Job Title',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.timeline),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          interviewLevel = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Interview Level',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: selectedDate != null
                              ? 'Interview Date: ${selectedDate!.toLocal()}'
                              : 'Select Interview Date',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
  onTap: () => _selectTime(context),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Row(
      children: [
        Icon(Icons.access_time),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: selectedTime != null && selectedTime != TimeOfDay(hour: 0, minute: 0)
                  ? 'Interview Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                  : 'Select Interview Time',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
            ),
            readOnly: true,
          ),
        ),
      ],
    ),
  ),
),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _scheduleInterview();
                  },
                  icon: Icon(Icons.event_available),
                  label: Text('Schedule'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20),
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