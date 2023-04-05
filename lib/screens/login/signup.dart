import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:flutter/material.dart';
import 'package:campus_ease/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  final User _user = User();
  bool isSignedIn = false, showPassword = true, showConfirmPassword = true;

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
    RegExp regExp =
        RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (_user.displayName!.length < 3) {
      toast("Name must have atleast 3 characters");
    } else if (!regExp.hasMatch(_user.email!)) {
      toast("Enter a valid Email ID");
    } else if (_user.phone!.length != 10) {
      toast("Contact number length must be 10");
    } else if (int.tryParse(_user.phone!) == null) {
      toast("Contact number must be a number");
    } else if (_user.enrollNo.toString().length != 14) {
      toast("Enrollment number length must be 14");
    } else if (_user.password!.length < 8) {
      toast("Password must have atleast 8 characters");
    } else if (_passwordController.text.toString() != _user.password) {
      toast("Confirm password does'nt match your password");
    } else {
      _user.role = "user";
      _user.balance = 0.0;
      signUp(_user, authNotifier, context);
    }
  }

  Widget _buildSignUPForm() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 60,
        ),
        // User Name Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            keyboardType: TextInputType.name,
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.displayName = value!;
            },
            cursorColor: const Color(0xFF8CBBF1),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Full Name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CBBF1),
              ),
              icon: Icon(
                Icons.account_circle,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Email Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.email = value!;
            },
            keyboardType: TextInputType.emailAddress,
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
        ),
        const SizedBox(
          height: 20,
        ),
        //Phone Number Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.phone = value!;
            },
            keyboardType: TextInputType.phone,
            cursorColor: const Color(0xFF8CBBF1),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Contact Number',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CBBF1),
              ),
              icon: Icon(
                Icons.phone,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Enrollment Number Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              return null;
            },
            onSaved: (String? value) {
              _user.enrollNo = int.parse(value!);
            },
            keyboardType: TextInputType.phone,
            cursorColor: const Color(0xFF8CBBF1),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enrollment Number',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CBBF1),
              ),
              icon: Icon(
                Icons.numbers_rounded,
                color: Color(0xFF8CBBF1),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // Password Field
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
        // Confirm Password Field
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            validator: (String? value) {
              return null;
            },
            obscureText: showConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            cursorColor: const Color(0xFF8CBBF1),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                    (showConfirmPassword)
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF8CBBF1),
                  ),
                  onPressed: () {
                    setState(() {
                      showConfirmPassword = !showConfirmPassword;
                    });
                  }),
              border: InputBorder.none,
              hintText: 'Confirm Password',
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
          height: 50,
        ),
        // Sign Up Button
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
              "Sign Up",
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
        // Login Line
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already a registered user?',
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
                Navigator.pop(context);
              },
              child: const Text(
                'Log In here',
                style: TextStyle(
                    color: Color.fromARGB(255, 72, 154, 247),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
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
                _buildSignUPForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
