import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../apis/foodAPIs.dart';
import '../../notifiers/authNotifier.dart';
import '../../widgets/customRaisedButton.dart';
import '../canteen/orderDetails.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isPersonalInfoVisible = false;
  bool _isSettingsVisible = false;
  bool _isReferVisible = false;
  late bool _pushNotification;
  late bool _emailNotification;
  bool nameUpdate = false;
  bool emailUpdate = false;
  bool phoneUpdate = false;
  bool enrollNoUpdate = false;
  bool admissionYearUpdate = false;
  bool branchUpdate = false;
  bool courseUpdate = false;
  bool uploading = false;
  double rating = 3.0;
  String? feedback;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey globalKey = GlobalKey();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEnrollNo = TextEditingController();
  final TextEditingController _controllerAdmissionYear =
      TextEditingController();
  final TextEditingController _controllerBranch = TextEditingController();
  final TextEditingController _controllerCourse = TextEditingController();

  int money = 0;

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);

    _controllerName.text = authNotifier.userDetails?.displayName ?? "";
    _controllerEmail.text = authNotifier.userDetails?.email ?? "";
    _controllerPhone.text = authNotifier.userDetails?.phone ?? "";
    _controllerEnrollNo.text =
        authNotifier.userDetails?.enrollNo.toString() ?? "";
    _controllerAdmissionYear.text =
        authNotifier.userDetails?.admissionYear ?? "";
    _controllerBranch.text = authNotifier.userDetails?.branch ?? "";
    _controllerCourse.text = authNotifier.userDetails?.course ?? "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateProfileImage() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    setState(() {
      uploading = true;
    });
    String firebaseId = authNotifier.userDetails!.uuid!;

    await pickImageFromGallery().then((pickedFile) async {
      if (pickedFile == null) return;
      try {
        Reference storage =
            FirebaseStorage.instance.ref().child('profiles/$firebaseId');
        UploadTask uploadTask = storage.putFile(File(pickedFile.path));
        String imgUrl = await (await uploadTask).ref.getDownloadURL();
        print(imgUrl);
        authNotifier.userDetails!.photoUrl = imgUrl;
        profileUpdate(authNotifier.userDetails!);
        setState(() {
          uploading = true;
        });
      } catch (e) {
        print("ERROR " + e.toString());
      }
    });
  }

  Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.qr_code_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(child: Text("Scan Me")),
                      content: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  1, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: RepaintBoundary(
                            key: globalKey,
                            child: QrImage(
                              gapless: true,
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: Colors.white,
                              version: 5,
                              semanticsLabel: 'Scan Me',
                              data:
                                  authNotifier.userDetails!.enrollNo.toString(),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: Colors.black,
                              ),
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            (authNotifier.userDetails!.photoUrl != null)
                ? GestureDetector(
                    onTap: () async {
                      updateProfileImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 40,
                      backgroundImage:
                          NetworkImage(authNotifier.userDetails!.photoUrl!),
                    ))
                : GestureDetector(
                    onTap: () async {
                      updateProfileImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      radius: 40,
                      child: Icon(
                        Icons.person,
                        size: 70,
                      ),
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileInfoListTile(
                    leading: 'Name',
                    label: _controllerName.text,
                    keyboardType: TextInputType.name,
                    controller: _controllerName,
                    iconData: (authNotifier.userDetails!.role == "admin")
                        ? (nameUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: nameUpdate,
                    validator: (val) => val != "" &&
                            val!.length > 2 &&
                            (RegExp(r"^[a-zA-Z][a-zA-Z\s]*$")).hasMatch(val)
                        ? null
                        : "Invalid Name",
                    onIconTap: () async {
                      if (authNotifier.userDetails!.role == "admin" &&
                          _formKey.currentState!.validate()) {
                        if (nameUpdate == true) {
                          authNotifier.userDetails!.displayName =
                              _controllerName.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    iconData: (authNotifier.userDetails!.role == "admin")
                        ? (emailUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: emailUpdate,
                    validator: (val) => val != "" &&
                            val!.length > 2 &&
                            (RegExp(r"^[a-zA-Z][a-zA-Z\s]*$")).hasMatch(val)
                        ? null
                        : "Invalid Last Name",
                    onIconTap: () async {
                      if (authNotifier.userDetails!.role == "admin" &&
                          _formKey.currentState!.validate()) {
                        if (emailUpdate == true) {
                          authNotifier.userDetails!.email =
                              _controllerEmail.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    leading: 'Mobile Number',
                    label: _controllerPhone.text,
                    controller: _controllerPhone,
                    iconData: (phoneUpdate == false)
                        ? Icon(Icons.edit)
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
                          authNotifier.userDetails!.phone =
                              _controllerPhone.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    iconData: (authNotifier.userDetails!.role == "admin")
                        ? (enrollNoUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: enrollNoUpdate,
                    validator: (val) {
                      return val!.length == 14
                          ? null
                          : "Invalid Enrollment Number";
                    },
                    keyboardType: TextInputType.phone,
                    onIconTap: () async {
                      if (authNotifier.userDetails!.role == "admin" &&
                          _formKey.currentState!.validate()) {
                        if (enrollNoUpdate == true) {
                          authNotifier.userDetails!.enrollNo =
                              int.parse(_controllerEnrollNo.text);
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    iconData: (authNotifier.userDetails!.role == "admin" ||
                            authNotifier.userDetails!.admissionYear == null)
                        ? (admissionYearUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: admissionYearUpdate,
                    validator: (val) {
                      return val!.length == 4 ? null : "Invalid Admission Year";
                    },
                    keyboardType: TextInputType.phone,
                    onIconTap: () async {
                      if ((authNotifier.userDetails!.role == "admin" ||
                              authNotifier.userDetails!.admissionYear ==
                                  null) &&
                          _formKey.currentState!.validate()) {
                        if (admissionYearUpdate == true) {
                          authNotifier.userDetails!.admissionYear =
                              _controllerAdmissionYear.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    iconData: (authNotifier.userDetails!.role == "admin" ||
                            authNotifier.userDetails!.course == null)
                        ? (courseUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: courseUpdate,
                    validator: (val) {
                      return val != "" ? null : "Invalid Course";
                    },
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if ((authNotifier.userDetails!.role == "admin" ||
                              authNotifier.userDetails!.course == null) &&
                          _formKey.currentState!.validate()) {
                        if (courseUpdate == true) {
                          authNotifier.userDetails!.course =
                              _controllerCourse.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                    iconData: (authNotifier.userDetails!.role == "admin" ||
                            authNotifier.userDetails!.branch == null)
                        ? (branchUpdate == false)
                            ? Icon(Icons.edit)
                            : const Text(
                                "Update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                        : const Icon(
                            null,
                          ),
                    isEditable: branchUpdate,
                    validator: (val) {
                      return val != "" ? null : "Invalid Branch";
                    },
                    keyboardType: TextInputType.text,
                    onIconTap: () async {
                      if ((authNotifier.userDetails!.role == "admin" ||
                              authNotifier.userDetails!.branch == null) &&
                          _formKey.currentState!.validate()) {
                        if (branchUpdate == true) {
                          authNotifier.userDetails!.branch =
                              _controllerBranch.text;
                          await profileUpdate(authNotifier.userDetails!);
                          print("update");
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
                  ListTile(
                    onTap: () {
                      signOutUser();
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500),
                    ),
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
      this.onTap,
      this.leading,
      this.onIconTap,
      this.iconColor,
      this.isEditable,
      this.keyboardType,
      Key? key,
      this.controller,
      this.validator})
      : super(key: key);
  final String? label;
  final Color labelColor;
  final String? subtitle;
  final Function? onTap;
  final Widget? iconData;
  final Function? onIconTap;
  final Color? iconColor;
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
