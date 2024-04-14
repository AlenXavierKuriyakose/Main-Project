import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login/userlogin.dart';

class Requirement {
  final int id;
  final String jobTitle;
  final int nov;
  final String priority;
  final String role;
  final DateTime openingDate;
  final DateTime closingDate;
  final int departmentId;
  String approvalStatus;

  Requirement({
    required this.id,
    required this.jobTitle,
    required this.nov,
    required this.priority,
    required this.role,
    required this.openingDate,
    required this.closingDate,
    required this.departmentId,
    required this.approvalStatus,
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
      approvalStatus: json['APPROVAL_STATUS'] ?? "Pending",
    );
  }
}

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  late Future<List<Requirement>> requirements;
  List<Requirement> requirementList = [];
  String approvalMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRequirements();
  }

  Future<void> fetchRequirements() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.211:3000/api/requirements'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      setState(() {
        requirementList = list
            .map((model) => Requirement.fromJson(model))
            .toList();
      });
    } else {
      throw Exception('Failed to load requirements');
    }
  }

  Future<void> updateRequirementApproval(
      int requirementId, String action) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://192.168.1.211:3000/api/${action.toLowerCase()}/$requirementId'),
        body: json.encode({'APPROVED_BY_MANAGER': action}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        setState(() {
          approvalMessage = action == 'approve' ? 'Approved' : 'Rejected';
          // Update the approvedBy field in the corresponding Requirement object
          int index = requirementList
              .indexWhere((req) => req.id == requirementId);
          if (index != -1) {
            requirementList[index].approvalStatus =
                action == 'approve' ? 'Approved' : 'Rejected';
            // Store approval status in SharedPreferences
            storeApprovalStatus(requirementId, action);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(approvalMessage),
          ),
        );
      } else {
        throw Exception('Failed to update requirement');
      }
    } catch (error) {
      throw Exception('Failed to update requirement: $error');
    }
  }

  Future<void> storeApprovalStatus(int requirementId, String action) async {
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
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 155, 172, 186),
              Color.fromARGB(255, 154, 172, 187),
              const Color.fromARGB(255, 159, 186, 206),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Requirements',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
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
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.08);
                          }
                          return null;
                        },
                      ),
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
                                return Text(requirement.approvalStatus); // Show the current approval status
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
                                    updateRequirementApproval(requirement.id, 'approve'),
                                child: Text('Approve'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    updateRequirementApproval(requirement.id, 'reject'),
                                child: Text('Reject'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManagerPage(),
  ));
}
