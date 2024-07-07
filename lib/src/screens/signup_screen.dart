import 'package:flutter/material.dart';
import 'package:notesjot_app/src/screens/home_screen.dart';
import 'package:notesjot_app/src/services/storage_service.dart';
import 'package:notesjot_app/src/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();

  final ApiService apiService = ApiService();
  bool isPasswordHidden = true;
  bool isConfPasswordHidden = true;
  bool isLoading = false;

  void initState() {
    isPasswordHidden = true;
    isConfPasswordHidden = true;
    isLoading = false;
  }

  void toggleShowPassword() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  void toggleShowConfPassword() {
    setState(() {
      isConfPasswordHidden = !isConfPasswordHidden;
    });
  }

  Future<void> onSubmitPress() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        String name = nameController.text;
        String email = emailController.text;
        String password = passwordController.text;

        Map<String, dynamic> payload = {
          'fullName': name,
          'email': email,
          'password': password,
        };

        var responseValue = await apiService.postData('auth/register', payload);

        dynamic responseSuccess = responseValue['success'];

        if (responseValue != null && responseSuccess == true) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${responseValue['message']}')));

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen()));
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
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: confPasswordController,
                    obscureText: isConfPasswordHidden,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            toggleShowConfPassword();
                          },
                          icon: Icon(!isConfPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      } else if (value != passwordController.text) {
                        return "Passwords Do Not Match!";
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
      ),
    );
  }
}
