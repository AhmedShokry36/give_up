import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:give_up_drugs/models/helper/Alert.dart';
import 'package:give_up_drugs/modules/home/home_Screen_admin.dart';
import 'package:give_up_drugs/modules/intro/DropDown.dart';
import 'package:give_up_drugs/modules/videos/View.dart';
import 'package:give_up_drugs/shared/components/constants.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  CollectionReference videoref =
      FirebaseFirestore.instance.collection('videoLink');
  CollectionReference userref = FirebaseFirestore.instance.collection('Users');
  TextEditingController _addItemController = TextEditingController();
  DocumentReference linkRef;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  List<String> videoID = [];
  bool showItem = false;
  bool _isPlayerReady = false;

  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  // Reference ref;
  File file;
  var typeVideo = valueChose1;
  var levelVideo = valueChose2;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  AddVideos(context) async {
    if (file == true)
      return AwesomeDialog(
          context: context,
          title: "هام",
          body: Text("please choose Image"),
          dialogType: DialogType.ERROR)
        ..show();
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      showLoading(context);
      formdata.save();
      await videoref
          .add({
            "nameVideo": nameVideo,
            "linkVideo": linkVideo,
            "typeVideo": typeVideo,
            "levelVideo": levelVideo,
            // "phoneHospital": phoneHospital,
            "id": FirebaseAuth.instance.currentUser.uid
          })
          .then((value) => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenAdmin()))
              })
          .catchError((e) {
            print("$e");
          });
    }
  }

  _addItemFuntion() async {
    await linkRef.set({
      _addItemController.text.toString(): _addItemController.text.toString()
    }, SetOptions(merge: true));
    Flushbar(
      title: 'Added',
      message: 'updating...',
      duration: Duration(seconds: 3),
      icon: Icon(Icons.info_outline),
    );
    // ..show(context);
    setState(() {
      videoID.add(_addItemController.text);
    });
    print('added');
    FocusScope.of(this.context).unfocus();
    _addItemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اضافه الفيديو',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${FirebaseAuth.instance.currentUser.email}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          validator: (val) {
                            if (val.length > 100) {
                              return "Title can't to be larger than 30 letter";
                            }
                            if (val.length < 2) {
                              return "Title can't to be less than 2 letter";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            nameVideo = val;
                          },
                          maxLength: 50,
                          decoration: InputDecoration(
                              labelText: " اسم الفيديو",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          validator: (val) {
                            if (val.length > 100) {
                              return "Title can't to be larger than 30 letter";
                            }
                            if (val.length < 2) {
                              return "Title can't to be less than 2 letter";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            linkVideo = val;
                          },
                          maxLength: 100,
                          decoration: InputDecoration(
                            labelText: "الفيديو ",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 400,
                        child: DropDown(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    //style: ButtonStyle(backgroundColor: Color(Colors.accents)),
                    onPressed: () {
                      AddVideos(context);
                    },
                    child: Text(
                      'حفظ البيانات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}