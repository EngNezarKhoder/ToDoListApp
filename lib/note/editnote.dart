import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/categories/mybutton.dart';
import 'package:fluttercourse/mainpage.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.oldnote, required this.docid});
  final String oldnote;
  final String docid;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  // GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  GlobalKey<FormState> formstate = GlobalKey();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("categories");
  @override
  void initState() {
    note.text = widget.oldnote;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: formstate,
            child: SafeArea(
                child: Scaffold(
              backgroundColor: Colors.grey[100],
              // key: scaffoldkey,
              drawer: const Drawer(),
              body: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
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
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Edit Your Note ? ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        validator: (val) {
                          if (val == "") {
                            return "The Field Is Empty";
                          }
                          return null;
                        },
                        controller: note,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Insert Your Note",
                          icon: const Icon(
                            Icons.note,
                            color: Colors.orange,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyMaterialButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(widget.docid)
                                  .update({"note": note.text});
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()),
                                  (route) => false);
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              // ignore: avoid_print
                              print("Error");
                            }
                          }
                        },
                        height: 40,
                        minWidth: 200,
                        color: Colors.orange,
                        title: "Save Note")
                  ],
                ),
              ),
            )));
  }
}
