import 'package:flutter/material.dart';
import '../models/auth.dart' as a;
enum AuthState { Login, Signup }

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  AuthState _authState = AuthState.Login;
  late FocusNode myFocusNode;

  final Map<String, String?> _user = {
    "email": null,
    "password": null,
  };

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  Future _tryToLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_authState == AuthState.Login) {
        try {
          await a.Auth.login(_user);
        } catch (err) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                    err.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
            ),
          );
        }
      } else {
        try {
          await a.Auth.signup(_user);
        } catch (err) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                    err.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
            ),
          );
        }

      }
      setState(() {
        _isLoading = false;
      });
    }
  }
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      } else if (!value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user['email'] = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 5) {
                        return "Your Password should be at least 5 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user['password'] = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password),
                    ),
                    textInputAction: _authState == AuthState.Login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    obscureText: true,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                //Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: _isLoading ? null : () async {
                          await _tryToLogin();
                        },
                        child: _isLoading ? const CircularProgressIndicator() : Text(
                          _authState == AuthState.Login ? "Login" : "Signup",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    Text(_authState == AuthState.Login
                        ? "Don't have an account ? "
                        : "Already have an account"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _authState = _authState == AuthState.Login
                              ? AuthState.Signup
                              : AuthState.Login;
                        });
                      },
                      child: Text(
                        _authState == AuthState.Login ? "Signup" : "Login",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
