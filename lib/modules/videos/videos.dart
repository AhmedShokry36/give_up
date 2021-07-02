import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:give_up_drugs/modules/videos/addVideo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  Future<String> getStringFromSharedPreferences(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  getlikes() async {
    String levelVideo = await getStringFromSharedPreferences('levelVideo');
    String typeVideo = await getStringFromSharedPreferences('typeVideo');
    var videoref = FirebaseFirestore.instance
        .collection('videoLink')
        .where('levelVideo', isEqualTo: levelVideo)
        .where('typeVideo', isEqualTo: typeVideo)
        .get();

    return videoref;
  }

  @override
  CollectionReference userref = FirebaseFirestore.instance.collection('Users');
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: getlikes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsetsDirectional.only(start: 20),
                    child: Container(
                      height: 1.0,
                      width: double.infinity,
                      color: Colors.grey[400],
                    ),
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    return ListVideos(
                      Videos: snapshot.data.docs[i],
                      docid: snapshot.data.docs[i].id,
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}

class ListVideos extends StatelessWidget {
  @override
  final Videos;
  final docid;
  ListVideos({this.Videos, this.docid});

  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: '${Videos['linkVideo']}',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              /*  CircleAvatar(
                radius: 40.0,
                child: Icon(
                  Icons.video_collection_sharp,
                  size: 45.0,
                ),
              ), */
              SizedBox(
                width: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Videos['nameVideo']}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      /*  GestureDetector(
                        onTap: () => launch("https://${Videos['linkVideo']}"),
                        child: Text(
                          "${Videos['linkVideo']}",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ), */
                      Center(
                        child: Container(
                          width: 300,
                          child: YoutubePlayer(
                            controller: _controller,
                            liveUIColor: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
