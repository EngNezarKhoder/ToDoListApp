import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercourse/auth/register.dart';
import 'package:fluttercourse/categories/logo.dart';
import 'package:fluttercourse/categories/mybutton.dart';
import 'package:fluttercourse/categories/mytextformfiled.dart';
import 'package:fluttercourse/mainpage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;

  Future signInWithGoogle() async {
    setState(() {});
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    // Obtain the auth details from the request

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      isLoading = false;
      setState(() {});
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Falied Sign In", e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> _resetPassword() async {
    if (email.text.isEmpty) {
      _showErrorDialog("Error", "Please enter your email.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      AwesomeDialog(
        // ignore: use_build_context_synchronously
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Check your email',
        desc: 'We have sent a reset link to your email.',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      _showErrorDialog("Error", "Failed to send reset email.");
    }
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
                          "Sign In",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
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
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () async {
                                _resetPassword();
                              },
                              child: const Text("Forgot Password ?")),
                        ),
                        MyMaterialButton(
                          color: const Color.fromARGB(255, 201, 67, 163),
                          minWidth: double.infinity,
                          height: 45,
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text);
                                if (credential.user!.emailVerified) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage()));
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (e.code == 'user-not-found') {
                                  _showErrorDialog(
                                      "Error", "No user found for that email.");
                                } else if (e.code == 'wrong-password') {
                                  _showErrorDialog("Error",
                                      "Wrong password provided for that user.");
                                }
                              }
                            } else {
                              return;
                            }
                          },
                          title: "Sign In",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Expanded(
                                child: Divider(
                              thickness: 1,
                            )),
                            Text(
                              "   OR   ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 1,
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100)),
                              child:
                                  SvgPicture.asset("assets/icons/facebook.svg"),
                            ),
                            InkWell(
                                onTap: () async {
                                  await signInWithGoogle();
                                },
                                child: Container(
                                  width: 70,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(100)),
                                  child: SvgPicture.asset(
                                    "assets/icons/google-plus.svg",
                                    width: 30,
                                  ),
                                )),
                            Container(
                              width: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100)),
                              child: SvgPicture.asset(
                                "assets/icons/twitter.svg",
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Dont Have An Account ?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Register()));
                                },
                                child: const Text("Register"))
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
