import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login.dart';
import 'package:fluttercourse/categories/logo.dart';
import 'package:fluttercourse/categories/mybutton.dart';
import 'package:fluttercourse/categories/mytextformfiled.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;
  void showWarningMessage(String title, String content) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: title,
      desc: content,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  void showErrorMessage(String title, String content) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: content,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: formstate,
            child: Scaffold(
              body: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const MyLogo(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 150,
                                height: 50,
                                child: MyTextFormFiled(
                                  validator: (val) {
                                    if (val == "") {
                                      return "The Field Is Empty";
                                    }
                                    if (val!.length <= 2) {
                                      return "Is Too Small";
                                    }
                                    return null;
                                  },
                                  controller: fname,
                                  label: "First Name",
                                )),
                            SizedBox(
                                width: 150,
                                height: 50,
                                child: MyTextFormFiled(
                                  validator: (val) {
                                    if (val == "") {
                                      return "The Field Is Empty";
                                    }
                                    if (val!.length <= 2) {
                                      return "Is Too Small";
                                    }
                                    return null;
                                  },
                                  controller: lname,
                                  label: "Last Name",
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 1000,
                          height: 50,
                          child: MyTextFormFiled(
                            validator: (val) {
                              if (val == "") {
                                return "The Field Is Empty";
                              }
                              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                  .hasMatch(val!)) {
                                return "Enter a valid email address.";
                              }
                              return null;
                            },
                            label: "Email Address",
                            controller: email,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 1000,
                          height: 50,
                          child: MyTextFormFiled(
                            validator: (val) {
                              if (val == "") {
                                return "The Field Is Empty";
                              }
                              if (val!.length < 6) {
                                return "Password should be at least 6 characters.";
                              }
                              return null;
                            },
                            label: "Password",
                            controller: password,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MyMaterialButton(
                          color: const Color.fromARGB(255, 46, 99, 242),
                          minWidth: double.infinity,
                          height: 45,
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              try {
                                isLoading = true;
                                setState(() {});
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                credential.user!.sendEmailVerification();
                                setState(() {
                                  isLoading = false;
                                });
                                showWarningMessage("warning",
                                    "Please Go To The Email For Verfied Your Account And Then Log To The Account");
                              } on FirebaseAuthException catch (e) {
                                isLoading = false;
                                setState(() {});
                                if (e.code == 'weak-password') {
                                  showErrorMessage("Error",
                                      "The password provided is too weak.");
                                } else if (e.code == 'email-already-in-use') {
                                  showErrorMessage("Error",
                                      "The account already exists for that email.");
                                }
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              }
                            } else {
                              return;
                            }
                          },
                          title: "Register",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already Registed ?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignIn()));
                                },
                                child: const Text("Log In"))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
