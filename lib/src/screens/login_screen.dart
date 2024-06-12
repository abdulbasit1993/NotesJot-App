import 'package:flutter/material.dart';
import 'package:notesjot_app/src/services/storage_service.dart';
import 'package:notesjot_app/src/constants/route_names.dart';
import 'package:notesjot_app/src/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isPasswordHidden = true;
  bool isLoading = false;

  void initState() {
    isPasswordHidden = true;
    isLoading = false;
  }

  void toggleShowPassword() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  Future<void> onSubmitPress() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        String email = emailController.text;
        String password = passwordController.text;

        Map<String, dynamic> payload = {
          'email': email,
          'password': password,
        };

        var responseValue = await apiService.postData('auth/login', payload);

        dynamic responseSuccess = responseValue['success'];

        if (responseValue != null && responseSuccess == true) {
          setState(() {
            isLoading = false;
          });

          String token = responseValue['data']['token'];

          await StorageService().saveToLocal("token", token);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${responseValue['message']}')));

          Navigator.of(context).pushReplacementNamed(homeRoute);
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${responseValue['message']}')));
        }
      } catch (error) {
        print('Error $error');
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all inputs")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text('Welcome to NotesJot!',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text('Please Login to Continue',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          toggleShowPassword();
                        },
                        icon: Icon(!isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmitPress();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xff597cff))),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
