import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacultyDetailsAddScreen extends StatefulWidget {
  final String? id;
  const FacultyDetailsAddScreen({super.key, this.id});

  @override
  State<FacultyDetailsAddScreen> createState() =>
      _FacultyDetailsAddScreenState();
}

class _FacultyDetailsAddScreenState extends State<FacultyDetailsAddScreen> {
  bool nameUpdate = false;
  bool emailUpdate = false;
  bool phoneUpdate = false;
  bool branchUpdate = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerBranch = TextEditingController();

  fetch() async {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('faculty_details');
    if (widget.id != null) {
      await itemRef.doc(widget.id).get().then((value) {
        setState(() {
          _controllerName.text = value['facultyName'];
          _controllerEmail.text = value['facultyEmail'];
          _controllerPhone.text = value['facultyMobile'];
          _controllerBranch.text = value['facultyBranch'];
        });
      });
    } else {
      _controllerName.text = "";
      _controllerEmail.text = "";
      _controllerPhone.text = "";
      _controllerBranch.text = "";
    }
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text((authNotifier.userDetails!.role == 'admin')
              ? widget.id != null
                  ? 'Update Faculty Details'
                  : 'Add Faculty Details'
              : 'Faculty Details'),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfileInfoListTile(
                      leading: 'Name',
                      label: _controllerName.text,
                      keyboardType: TextInputType.name,
                      controller: _controllerName,
                      isEditable: (authNotifier.userDetails!.role == 'admin')
                          ? true
                          : false,
                      validator: (val) =>
                          val != "" && val!.length > 2 ? null : "Invalid Name",
                    ),
                    ProfileInfoListTile(
                      leading: 'Email',
                      label: _controllerEmail.text,
                      keyboardType: TextInputType.emailAddress,
                      controller: _controllerEmail,
                      isEditable: (authNotifier.userDetails!.role == 'admin')
                          ? true
                          : false,
                      validator: (val) => val != "" &&
                              val!.length > 2 &&
                              (RegExp(r'\S+@\S+\.\S+')).hasMatch(val)
                          ? null
                          : "Invalid Email",
                    ),
                    ProfileInfoListTile(
                      leading: 'Phone',
                      label: _controllerPhone.text,
                      keyboardType: TextInputType.phone,
                      controller: _controllerPhone,
                      isEditable: (authNotifier.userDetails!.role == 'admin')
                          ? true
                          : false,
                      validator: (val) {
                        return val != "" &&
                                RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                    .hasMatch(val!)
                            ? null
                            : "Invalid Mobile Number";
                      },
                    ),
                    ProfileInfoListTile(
                      leading: 'Designation',
                      label: _controllerBranch.text,
                      keyboardType: TextInputType.text,
                      controller: _controllerBranch,
                      isEditable: (authNotifier.userDetails!.role == 'admin')
                          ? true
                          : false,
                      validator: (val) => val != "" &&
                              val!.length > 1 &&
                              (RegExp(r"^[a-zA-Z][a-zA-Z\s]*$")).hasMatch(val)
                          ? null
                          : "Invalid Designation",
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            if (authNotifier.userDetails!.role == 'admin')
              GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      facultyDetailsUpdate(
                          widget.id,
                          _controllerName.text,
                          _controllerEmail.text,
                          _controllerPhone.text,
                          _controllerBranch.text);

                      Navigator.pop(context);
                    }
                  },
                  child: CustomRaisedButton(
                    buttonText: widget.id != null ? 'Update' : 'Add',
                  )),
          ]),
        )));
  }
}

class ProfileInfoListTile extends StatelessWidget {
  const ProfileInfoListTile(
      {this.label,
      this.labelColor = Colors.black,
      this.subtitle,
      this.onTap,
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
  final Function? onTap;
  final String? leading;
  final bool? isEditable;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
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
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
