/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAdmin extends StatefulWidget {
  @override
  _VideoAdminState createState() => _VideoAdminState();
}

class _VideoAdminState extends State<VideoAdmin> {
  TextEditingController _addItemController = TextEditingController();
  DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Flexible(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: ListView.builder(
            itemCount: videoID.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.all(8),
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                    initialVideoId:
                        YoutubePlayer.convertUrlToId(videoID[index]),
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                    )),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blue,
                progressColors: ProgressBarColors(
                    playedColor: Colors.blue, handleColor: Colors.blueAccent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    linkRef = FirebaseFirestore.instance.collection('links').doc('urls');
    super.initState();
    getData();
    print(videoID);
  }

  _addItemFuntion() async {
    await linkRef.set({
      _addItemController.text.toString(): _addItemController.text.toString()
    }, SetOptions(merge: true));
    Flushbar(
        title: 'Added',
        message: 'updating...',
        duration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline))
      ..show(context);
    setState(() {
      videoID.add(_addItemController.text);
    });
    print('added');
    FocusScope.of(this.context).unfocus();
    _addItemController.clear();
  }

  getData() async {
    await linkRef.get().whenComplete(() => setState(() {
          videoID.shuffle();
          showItem = true;
        }));
  }
}
 */