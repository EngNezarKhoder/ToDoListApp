import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/auth/login.dart';
import 'package:fluttercourse/auth/register.dart';
import 'package:fluttercourse/categories/textformfieldsearch.dart';
import 'package:fluttercourse/note/addnote.dart';
import 'package:fluttercourse/note/editnote.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  Stream<QuerySnapshot> _getNotesStream() {
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection("categories").snapshots();
    }
    return FirebaseFirestore.instance
        .collection("categories")
        .where("note", isGreaterThanOrEqualTo: searchQuery)
        .where("note", isLessThan: '${searchQuery}z')
        .snapshots();
  }

  Stream<QuerySnapshot> notes =
      FirebaseFirestore.instance.collection("categories").snapshots();
  void onSearchChanged(String val) {
    setState(() {
      searchQuery = val.toLowerCase();
    });
  }

  void _signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignIn()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
          child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                _signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (route) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.exit_to_app),
                  Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Register()),
                    (route) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.person),
                  Text(
                    "Create New Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Addnote()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: const Color.fromARGB(255, 95, 98, 244),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      scaffoldkey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                    )),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(3),
                  child: Image.asset(
                    "images/dating-app-logo-example.jpg",
                    width: 30,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormFiledSearch(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
            const SizedBox(
              height: 35,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "All ToDos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 500,
                width: double.infinity,
                child: StreamBuilder(
                    stream: _getNotesStream(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.hasError) {
                        // ignore: avoid_print
                        print("Error ");
                      }
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var noteDoc = snapshots.data!.docs[index];
                            if (noteDoc['id'] !=
                                FirebaseAuth.instance.currentUser!.uid) {
                              return const SizedBox.shrink();
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditNote(
                                          oldnote: noteDoc['note'],
                                          docid: noteDoc.id,
                                        )));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                          value: noteDoc['status'],
                                          onChanged: (val) {
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection("categories")
                                                  .doc(noteDoc.id)
                                                  .update(
                                                      {"status": val ?? false});
                                            });
                                          }),
                                      noteDoc['status']
                                          ? SizedBox(
                                            width: 200,
                                              child: Text(
                                              noteDoc['note'],
                                              style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            )
                                          )
                                          : SizedBox(
                                              width: 200,
                                              child: Text(
                                              noteDoc['note'],
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection("categories")
                                              .doc(noteDoc.id)
                                              .delete();
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.all(2),
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }))
          ],
        ),
      ),
    ));
  }
}
