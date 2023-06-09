import 'package:campus_ease/models/faculty_details_model.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/faculty_details/faculty_details_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacultyDetailsTableScreen extends StatefulWidget {
  const FacultyDetailsTableScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FacultyDetailsTableScreen> createState() =>
      _FacultyDetailsTableScreenState();
}

class _FacultyDetailsTableScreenState extends State<FacultyDetailsTableScreen> {
  List<FacultyDetailsModel> _faculty = <FacultyDetailsModel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Details'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('faculty_details')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              _faculty = <FacultyDetailsModel>[];
              for (var item in snapshot.data!.docs) {
                _faculty.add(FacultyDetailsModel(
                  facultyId: item.id,
                  facultyName: item['facultyName'],
                  facultyEmail: item['facultyEmail'],
                  facultyMobile: item['facultyMobile'],
                  facultyBranch: item['facultyBranch'],
                ));
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable2(
                    border: const TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.black, width: .1),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: .75,
                      ),
                    ),
                    columnSpacing: 0,
                    showCheckboxColumn: false,
                    horizontalMargin: 0,
                    columns: [
                      const DataColumn2(
                        size: ColumnSize.M,
                        label: Text("Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      const DataColumn2(
                        size: ColumnSize.S,
                        label: Text("Phone",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      DataColumn2(
                        size: ColumnSize.S,
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: const Text(
                            "Designation",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(
                      snapshot.data!.docs.length,
                      (index) => recentFileDataRow(context, _faculty[index]),
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Text("No Items to display"),
              );
            }
          },
        ),
      ),
    );
  }
}

DataRow recentFileDataRow(BuildContext context, FacultyDetailsModel fileInfo) {
  AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  return DataRow(
    onSelectChanged: (value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FacultyDetailsAddScreen(
                    id: fileInfo.facultyId,
                  )));
    },
    onLongPress: () {
      if (authNotifier.userDetails!.role == 'admin') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete ${fileInfo.facultyName}"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('faculty_details')
                            .doc(fileInfo.facultyId)
                            .delete();
                        Navigator.pop(context);
                      },
                      child: const Text("Delete")),
                ],
              );
            });
      }
    },
    cells: [
      DataCell(Text(
        fileInfo.facultyName!,
        style: const TextStyle(fontWeight: FontWeight.w500),
      )),
      DataCell(Text(fileInfo.facultyMobile!)),
      DataCell(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
          child: Text(
            fileInfo.facultyBranch!,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    ],
  );
}
