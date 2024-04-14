import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:login/dhead1.dart';
import 'package:intl/intl.dart';
import 'package:login/userlogin.dart';
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


class RequirementPage extends StatefulWidget {
  @override
  _RequirementPageState createState() => _RequirementPageState();
}

class _RequirementPageState extends State<RequirementPage> {
  late Future<List<Department>> department;
  late Future<List<Designation>> designation;
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController novController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController experiencecontroller = TextEditingController();
  TextEditingController jobDescController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  String? selectedPriority;
  String? selectedRole;
  DateTime? selectedOpeningDate;
  DateTime? selectedClosingDate;
  String? selectedDepartmentName;
  String? selectedDesignationName;

  @override
  void initState() {
    super.initState();
    department = fetchDepartments();
    designation = fetchDesignations();
  }

  Future<List<Department>> fetchDepartments() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.211:3000/api/managedept'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Department.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<List<Designation>> fetchDesignations() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.211:3000/api/managedesign'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Designation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load designations');
    }
  }

  Future<void> insertRequirement(
      String jobTitle,
      String qualification,
      String experience,
      int nov,
      String priority,
      String role,
      DateTime openingDate,
      DateTime closingDate,
      String departmentName,
      String designationName,
      String jobDesc,
      String skills) async {
    final selectedDepartment = (await department).firstWhere(
      (dept) => dept.name == departmentName,
      orElse: () => throw Exception('Department not found'),
    );
    final selectedDepartmentId = selectedDepartment.id;

    final selectedDesignation = (await designation).firstWhere(
      (desig) => desig.name == designationName,
      orElse: () => throw Exception('Designation not found'),
    );
    final selectedDesignationId = selectedDesignation.id;

    final response = await http.post(
      Uri.parse('http://192.168.1.211:3000/api/requirements'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'JOB_TITLE': jobTitle,
        'qualification': qualification,
        'experience': experience,
        'NOV': nov,
        'priority': priority,
        'role': role,
        'OPENING_DATE': openingDate.toString(),
        'CLOSING_DATE': closingDate.toString(),
        'DEPT_ID': selectedDepartmentId,
        'DESIGN_ID': selectedDesignationId,
        'JOB_DESC': jobDesc,
        'skills': skills,
      }),
    );

    if (response.statusCode == 201) {
      print('Requirement inserted successfully');
    } else {
      throw Exception('Failed to insert requirement');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Requirement'),
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
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Job Requirements'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Interview Status'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InterviewStatusPage(),
                  ),
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
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: jobTitleController,
                    decoration: InputDecoration(
                      labelText: 'Job Title',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                      prefixIcon: Icon(Icons.work),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: novController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Number of Vacancies',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                      prefixIcon: Icon(Icons.people),
                    ),
                  ),
                ),
              ],
            ),

            Column(
  children: [
    SizedBox(height: 16.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: jobDescController,
            decoration: InputDecoration(
              labelText: 'Job Description',
              border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              prefixIcon: Icon(Icons.description),
            ),
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: skillsController,
            decoration: InputDecoration(
              labelText: 'Skills',
              border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              prefixIcon: Icon(Icons.star),
            ),
          ),
        ),
      ],
    ),SizedBox(width: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: qualificationController,
                    decoration: InputDecoration(
                      labelText: 'Qualification',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: experiencecontroller,
                    decoration: InputDecoration(
                      labelText: 'Experience',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                      prefixIcon: Icon(Icons.work_outline),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedPriority,
                    items: ['Urgent', 'Minor'].map((String priority) {
                      return DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPriority = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: ['Temporary', 'Permanent'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedOpeningDate) {
                        setState(() {
                          selectedOpeningDate = picked;
                        });
                      }
                    },
                    child: Text(selectedOpeningDate == null
                        ? 'Select Opening Date'
                        : 'Opening Date: ${selectedOpeningDate.toString().substring(0, 10)}'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedClosingDate) {
                        setState(() {
                          selectedClosingDate = picked;
                        });
                      }
                    },
                    child: Text(selectedClosingDate == null
                        ? 'Select Closing Date'
                        : 'Closing Date: ${selectedClosingDate.toString().substring(0, 10)}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Department>>(
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
                            labelText: 'Select Department',
                            border: OutlineInputBorder(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: FutureBuilder<List<Designation>>(
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
                            labelText: 'Select Designation',
                            border: OutlineInputBorder(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                RegExp stringPattern = RegExp(r'^[a-zA-Z\s]+$');
                bool isJobTitleValid = stringPattern.hasMatch(jobTitleController.text);
                bool isQualificationValid = stringPattern.hasMatch(qualificationController.text);
                bool isNovValid = int.tryParse(novController.text) != null;
                bool isExperienceValid = int.tryParse(experiencecontroller.text) != null;

                if (selectedDepartmentName != null &&
                    selectedDesignationName != null &&
                    selectedPriority != null &&
                    selectedRole != null &&
                    selectedOpeningDate != null &&
                    selectedClosingDate != null &&
                    isJobTitleValid &&
                    isQualificationValid &&
                    isNovValid &&
                    isExperienceValid) {
                  await insertRequirement(
                    jobTitleController.text,
                    qualificationController.text,
                    experiencecontroller.text,
                    int.parse(novController.text),
                    selectedPriority!,
                    selectedRole!,
                    selectedOpeningDate!,
                    selectedClosingDate!,
                    selectedDepartmentName!,
                    selectedDesignationName!,
                    jobDescController.text,
                    skillsController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Successfully registered requirement'),
                    ),
                  );

                  jobTitleController.clear();
                  qualificationController.clear();
                  experiencecontroller.clear();
                  novController.clear();
                  jobDescController.clear();
                  skillsController.clear();
                  setState(() {
                    selectedPriority = null;
                    selectedRole = null;
                    selectedOpeningDate = null;
                    selectedClosingDate = null;
                    selectedDepartmentName = null;
                    selectedDesignationName = null;
                  });
                } else {
                  String errorMessage = '';
                  if (!isJobTitleValid) errorMessage += 'Please enter a valid job title.\n';
                  if (!isQualificationValid) errorMessage += 'Please enter a valid qualification.\n';
                  if (!isNovValid) errorMessage += 'Please enter a valid number of vacancies.\n';
                  if (!isExperienceValid) errorMessage += 'Please enter a valid experience.\n';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid or Missing Fields"),
                        content: Text(errorMessage),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                'Save Requirement',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ]),
    ));
  }
}





class InterviewStatusPage extends StatefulWidget {
  @override
  _InterviewStatusPageState createState() => _InterviewStatusPageState();
}

class _InterviewStatusPageState extends State<InterviewStatusPage> {
  List<Map<String, dynamic>> interviewData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.211:3000/api/interviews1'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        setState(() {
          interviewData = List<Map<String, dynamic>>.from(decodedData);
        });
      } else {
        print('Failed to fetch interview data');
      }
    } catch (err) {
      print('Error occurred while fetching interview data: $err');
    }
  }

  void _handleSelection(int candidateId, int interviewId, bool isSelected) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.211:3000/api/${isSelected ? 'pass' : 'fail'}/$candidateId/$interviewId'),
        body: json.encode({'pass_fail': isSelected ? 'passed' : 'failed'}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Handle success response
        print('Interview $interviewId of candidate $candidateId is ${isSelected ? 'passed' : 'failed'}');
      } else {
        throw Exception('Failed to update status');
      }
    } catch (error) {
      // Handle error
      throw Exception('Failed to update status: $error');
    }
  }

  bool isInterviewFinished(DateTime? interviewDateTime) {
    // Check if the interview has occurred
    if (interviewDateTime == null) {
      return false; // Interview date and time not available
    }
    DateTime currentDateTime = DateTime.now();
    return currentDateTime.isAfter(interviewDateTime);
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        Text(
          '$label: $value',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Status'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: interviewData.length,
        itemBuilder: (context, index) {
          final interview = interviewData[index];

          // Parse interview date and time
          DateTime? interviewDate =
              interview['interview_date'] != null ? DateTime.parse(interview['interview_date']) : null;
          TimeOfDay? interviewTime = interview['interview_time'] != null
              ? TimeOfDay.fromDateTime(DateTime.parse(interview['interview_time']))
              : null;

          // Format date string using DateFormat
          String formattedDate = interviewDate != null ? DateFormat('dd-MM-yyyy').format(interviewDate) : 'N/A';

          // Format time string using DateFormat in 24-hour format
          String formattedTime = interviewTime != null
              ? DateFormat('HH:mm').format(DateTime.parse(interview['interview_time']))
              : 'N/A';

          // Determine color for interview
          Color interviewColor = index.isEven ? Colors.blue[100]! : Colors.green[100]!;

          // Determine if interview is finished
          bool isFinished = isInterviewFinished(interviewDate!);

          // Determine if buttons should be enabled
          bool buttonsEnabled = isFinished; // Buttons are enabled only if the interview is finished

          return GestureDetector( // Wrap with GestureDetector to enable onTap
            onTap: () {
              // Handle tap event, navigate to details page or perform other action
            },
            child: SizedBox(
              width: 600,
              child: Container(
                height: 300,
                width: 500,
                color: interviewColor,
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('Interview ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildDetailRow(icon: Icons.person, label: 'Candidate ID', value: interview['candidate_id']?.toString() ?? 'N/A'),
                        _buildDetailRow(icon: Icons.article, label: 'Application ID', value: interview['app_id']?.toString() ?? 'N/A'),
                        _buildDetailRow(icon: Icons.person, label: 'Full Name', value: interview['full_name']?.toString() ?? 'N/A'),
                        _buildDetailRow(icon: Icons.work, label: 'Job Title', value: interview['JOB_TITLE']?.toString() ?? 'N/A'),
                        _buildDetailRow(icon: Icons.layers, label: 'Interview Level', value: interview['interview_level']?.toString() ?? 'N/A'),
                        _buildDetailRow(icon: Icons.calendar_today, label: 'Interview Date', value: formattedDate),
                        _buildDetailRow(icon: Icons.access_time, label: 'Interview Time', value: formattedTime),
                        SizedBox(height: 16),
                        if (!isFinished)
                          Text(
                            'Interview not finished yet',
                            style: TextStyle(color: Colors.red),
                          ),
                        if (isFinished)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: buttonsEnabled
                                    ? () {
                                        // Handle selecting the applicant
                                        _handleSelection(interview['candidate_id'], interview['interview_id'], true); // Corrected 'interviewId' to 'interview_id'
                                      }
                                    : null, // Disable button if interview is not finished
                                child: Text('Pass'),
                              ),
                              ElevatedButton(
                                onPressed: buttonsEnabled
                                    ? () {
                                        // Handle rejecting the applicant
                                        _handleSelection(interview['candidate_id'], interview['interview_id'], false); // Corrected 'interviewId' to 'interview_id'
                                      }
                                    : null, // Disable button if interview is not finished
                                child: Text('Fail'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

void main() {
  runApp(MaterialApp(
    home: RequirementPage(),
    debugShowCheckedModeBanner: false, // Remove debug banner
  ));
}