import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:campus_ease/models/user.dart';

import '../../apis/allAPIs.dart';

class UpdateUserDetails extends StatefulWidget {
  final String id;
  const UpdateUserDetails({super.key, required this.id});

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  User user = User();
  bool nameUpdate = false;
  bool emailUpdate = false;
  bool phoneUpdate = false;
  bool branchUpdate = false;
  bool courseUpdate = false;
  bool hostelNameUpdate = false;
  bool roomNoUpdate = false;
  bool enrollNoUpdate = false;
  bool admissionYearUpdate = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEnrollNo = TextEditingController();
  final TextEditingController _controllerAdmissionYear =
      TextEditingController();
  final TextEditingController _controllerBranch = TextEditingController();
  final TextEditingController _controllerCourse = TextEditingController();
  final TextEditingController _controllerHostelName = TextEditingController();
  final TextEditingController _controllerRoomNo = TextEditingController();
  final roles = [
    'user',
    'admin',
    'canteen',
    'faculty',
    'worker',
    'guard',
    'librarian',
    'warden',
  ];
  String? selectedRole;

  int money = 0;

  fetch() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('users');

    await itemRef.doc(widget.id).get().then((value) {
      setState(() {
        _controllerName.text = value['displayName'] ?? "";
        _controllerEmail.text = value['email'] ?? "";
        _controllerPassword.text = value['password'] ?? "";
        _controllerPhone.text = value['phone'] ?? "";
        _controllerEnrollNo.text = value['enroll_no'].toString();
        _controllerAdmissionYear.text = value['admission_year'] ?? "";
        _controllerBranch.text = value['branch'] ?? "";
        _controllerCourse.text = value['course'] ?? "";
        _controllerHostelName.text = value['hostel_name'] ?? "";
        _controllerRoomNo.text = value['room_no'] ?? "";
        selectedRole = value['role'] ?? "";
        user.displayName = value['displayName'] ?? "";
        user.email = value['email'] ?? "";
        user.password = value['password'] ?? "";
        user.phone = value['phone'] ?? "";
        user.enrollNo = value['enroll_no'] ?? "";
        user.admissionYear = value['admission_year'] ?? "";
        user.branch = value['branch'] ?? "";
        user.course = value['course'] ?? "";
        user.hostelName = value['hostel_name'] ?? "";
        user.roomNo = value['room_no'] ?? "";
        user.role = value['role'] ?? "";
        user.uuid = value['uuid'] ?? "";
        user.balance = value['balance'] ?? 0;
        user.photoUrl = value['photo_url'] ?? "";
        user.deviceToken = value['device_token'] ?? "";
      });
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileInfoListTile(
                    leading: 'Name',
                    label: _controllerName.text,
                    keyboardType: TextInputType.name,
                    controller: _controllerName,
                    iconData: (nameUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: nameUpdate,
                    validator: (val) =>
                        val != "" && val!.length > 2 ? null : "Invalid Name",
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (nameUpdate == true) {
                          user.displayName = _controllerName.text;
                          await updateUserProfile(user);
                          setState(() {
                            nameUpdate = false;
                          });
                        } else {
                          setState(() {
                            nameUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Email',
                    label: _controllerEmail.text,
                    keyboardType: TextInputType.name,
                    controller: _controllerEmail,
                    iconData: (emailUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: emailUpdate,
                    validator: (val) => val != "" &&
                            val!.length > 2 &&
                            (RegExp(r'\S+@\S+\.\S+')).hasMatch(val)
                        ? null
                        : "Invalid Last Name",
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (emailUpdate == true) {
                          user.email = _controllerEmail.text;
                          await updateUserProfile(user);
                          setState(() {
                            emailUpdate = false;
                          });
                        } else {
                          setState(() {
                            emailUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Password',
                    label: _controllerPassword.text,
                    keyboardType: TextInputType.text,
                    controller: _controllerPassword,
                    iconData: const Icon(
                      null,
                    ),
                    isEditable: false,
                    validator: (val) => val != "" &&
                            val!.length > 2 &&
                            (RegExp(r"^[a-zA-Z][a-zA-Z\s]*$")).hasMatch(val)
                        ? null
                        : "Invalid Password",
                  ),
                  ProfileInfoListTile(
                    leading: 'Mobile Number',
                    label: _controllerPhone.text,
                    controller: _controllerPhone,
                    iconData: (phoneUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: phoneUpdate,
                    validator: (val) {
                      return val != "" &&
                              RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                  .hasMatch(val!)
                          ? null
                          : "Invalid Mobile Number";
                    },
                    keyboardType: TextInputType.phone,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (phoneUpdate == true) {
                          user.phone = _controllerPhone.text;
                          await updateUserProfile(user);
                          setState(() {
                            phoneUpdate = false;
                          });
                        } else {
                          setState(() {
                            phoneUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Enrollment Number',
                    label: _controllerEnrollNo.text,
                    controller: _controllerEnrollNo,
                    iconData: (enrollNoUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: enrollNoUpdate,
                    validator: (val) {
                      return val!.length == 14
                          ? null
                          : "Invalid Enrollment Number";
                    },
                    keyboardType: TextInputType.phone,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (enrollNoUpdate == true) {
                          user.enrollNo = int.parse(_controllerEnrollNo.text);
                          await updateUserProfile(user);
                          setState(() {
                            enrollNoUpdate = false;
                          });
                        } else {
                          setState(() {
                            enrollNoUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Admission Year',
                    label: _controllerAdmissionYear.text,
                    controller: _controllerAdmissionYear,
                    iconData: (admissionYearUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: admissionYearUpdate,
                    validator: (val) {
                      return val!.length == 4 ? null : "Invalid Admission Year";
                    },
                    keyboardType: TextInputType.phone,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (admissionYearUpdate == true) {
                          user.admissionYear = _controllerAdmissionYear.text;
                          await updateUserProfile(user);
                          setState(() {
                            admissionYearUpdate = false;
                          });
                        } else {
                          setState(() {
                            admissionYearUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Course',
                    label: _controllerCourse.text,
                    controller: _controllerCourse,
                    iconData: (courseUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: courseUpdate,
                    validator: (val) {
                      return val != "" ? null : "Invalid Course";
                    },
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (courseUpdate == true) {
                          user.course = _controllerCourse.text;
                          await updateUserProfile(user);
                          setState(() {
                            courseUpdate = false;
                          });
                        } else {
                          setState(() {
                            courseUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Branch',
                    label: _controllerBranch.text,
                    controller: _controllerBranch,
                    iconData: (branchUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: branchUpdate,
                    validator: (val) {
                      return val != "" ? null : "Invalid Branch";
                    },
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (branchUpdate == true) {
                          user.branch = _controllerBranch.text;
                          await updateUserProfile(user);
                          setState(() {
                            branchUpdate = false;
                          });
                        } else {
                          setState(() {
                            branchUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Hostel Name',
                    label: _controllerHostelName.text,
                    controller: _controllerHostelName,
                    iconData: (hostelNameUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: hostelNameUpdate,
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (hostelNameUpdate == true) {
                          user.hostelName = _controllerHostelName.text;
                          await updateUserProfile(user);
                          setState(() {
                            hostelNameUpdate = false;
                          });
                        } else {
                          setState(() {
                            hostelNameUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  ProfileInfoListTile(
                    leading: 'Room No',
                    label: _controllerRoomNo.text,
                    controller: _controllerRoomNo,
                    iconData: (roomNoUpdate == false)
                        ? const Icon(Icons.edit)
                        : const Text(
                            "Update",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                    isEditable: roomNoUpdate,
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (roomNoUpdate == true) {
                          user.roomNo = _controllerRoomNo.text;
                          await updateUserProfile(user);
                          setState(() {
                            roomNoUpdate = false;
                          });
                        } else {
                          setState(() {
                            roomNoUpdate = true;
                          });
                        }
                      } else {}
                    },
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Role: ",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedRole,
                            items: roles.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              user.role = newValue;
                              await updateUserProfile(user);
                              setState(() {
                                selectedRole = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoListTile extends StatelessWidget {
  const ProfileInfoListTile(
      {this.label,
      this.labelColor = Colors.black,
      this.subtitle,
      this.iconData,
      this.onIconTap,
      this.leading,
      this.isEditable,
      this.keyboardType,
      Key? key,
      this.controller,
      this.validator})
      : super(key: key);
  final String? label;
  final Color labelColor;
  final String? subtitle;
  final Widget? iconData;
  final Function? onIconTap;
  final String? leading;
  final bool? isEditable;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          leading != null
              ? Expanded(
                  flex: 2,
                  child: Text(
                    leading!,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                )
              : Container(),
          const SizedBox(width: 10),
          Expanded(
            flex: label != null ? 3 : 1,
            child: label != null
                ? (isEditable == true)
                    ? TextFormField(
                        keyboardType: keyboardType,
                        validator: validator,
                        cursorColor: Colors.black,
                        // scrollPadding: EdgeInsets.zero,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          // border: InputBorder.none,
                        ),
                        // enabled: false,
                        controller: controller,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500),
                      )
                    : Text(
                        label!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500),
                      )
                : Container(),
          ),
          const SizedBox(width: 10),
          iconData != null
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: onIconTap as void Function()?,
                    child: iconData,
                  ),
                )
              : const Icon(
                  null,
                ),
        ]),
        const Divider(
          thickness: .75,
          color: Colors.black,
        ),
      ],
    );
  }
}
