import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/screens/login/forgotPassword.dart';
import 'package:campus_ease/screens/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:campus_ease/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final User _user = User();
  bool isSignedIn = false, showPassword = true;

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    super.initState();
  }

  void toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  void _submitForm() {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    RegExp regExp =
        RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    if (!regExp.hasMatch(_user.email!)) {
      toast("Enter a valid Email ID");
    } else if (_user.password!.length < 8) {
      toast("Password must have atleast 8 characters");
    } else {
      login(_user, authNotifier, context);
    }
  }

  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 120,
        ),
        // Email Text Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.email = value!;
            },
            cursorColor: const Color(0xFF8CBBF1),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Email',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CBBF1),
              ),
              icon: Icon(
                Icons.email,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ), //EMAIL TEXT FIELD
        const SizedBox(
          height: 20,
        ),
        // Password Text Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            obscureText: showPassword,
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.password = value!;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: const Color(0xFF8CBBF1),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                    (showPassword) ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF8CBBF1),
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  }),
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CBBF1),
              ),
              icon: const Icon(
                Icons.lock,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Forgot Password Line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 154, 247),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ForgotPasswordPage();
                  },
                ));
              },
              child: const Text(
                'Reset here',
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 154, 247),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        //LOGIN BUTTON
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              "Log In",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        // SignUp Line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Not a registered user?',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 154, 247),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const SignupPage();
                  },
                ));
              },
              child: const Text(
                'Sign Up here',
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 154, 247),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8CBBF1),
              Color(0xFF8CBBF1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.only(top: 60),
                  child: const Text(
                    'CampusEase',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'MuseoModerno',
                    ),
                  ),
                ),
              ),
              _buildLoginForm()
            ],
          ),
        ),
      ),
    );
  }
}
