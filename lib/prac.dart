import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  String studentName = "", studentID = "", courseCode = "";
  double studentGPA = 0.0;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentID(id) {
    this.studentID = id;
  }

  getCourseCode(coursecode) {
    this.courseCode = coursecode;
  }

  getStudentGPA(gpa) {
    this.studentGPA = double.parse(gpa);
  }

  createData() {
    print("Data Created");
    CollectionReference colref =
        FirebaseFirestore.instance.collection('MyStudents');

    //create map
    Map<String, dynamic> students_map = {
      "studentName": studentName,
      "studentID": studentID,
      "courseCode": courseCode,
      "studentGPA": studentGPA
    };

    colref
        .doc(studentName)
        .set(students_map)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void readData() async {
    try {
      CollectionReference students =
          FirebaseFirestore.instance.collection('MyStudents');
      final snapshot = await students.doc(studentName).get();
      final data = snapshot.data() as Map<String, dynamic>;
      print("Reading Data...");
      print(data['studentName']);
      print(data['studentID']);
      print(data['courseCode']);
      print(data['studentGPA']);
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  updateData() {
    print("Data Updated");
    
    CollectionReference colref =
        FirebaseFirestore.instance.collection('MyStudents');

    //create map
    Map<String, dynamic> students_map = {
      "studentName": studentName,
      "studentID": studentID,
      "courseCode": courseCode,
      "studentGPA": studentGPA
    };

    colref
        .doc(studentName)
        .set(students_map)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    
  }

  deleteData() {
    print("Data Deleted");

    CollectionReference colref =
        FirebaseFirestore.instance.collection('MyStudents');
    
    colref.doc(studentName).delete().then((colref) => print("Document Deleted"),
      onError: (e) => print("Error deleting user: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Airbase inc."),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Student Name",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0))),
                    onChanged: (String name) {
                      getStudentName(name);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Student ID",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0))),
                    onChanged: (String id) {
                      getStudentID(id);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Course Code",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0))),
                    onChanged: (String coursecode) {
                      getCourseCode(coursecode);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "GPA",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0))),
                    onChanged: (String gpa) {
                      getStudentGPA(gpa);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        createData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        readData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        "Read",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
