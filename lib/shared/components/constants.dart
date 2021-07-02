import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

var nameVideo, linkVideo, typeVideo, levelVideo;
var nameHospital, addressHospital, phoneHospital, videoref;
var drugVideo, gamesVideo, suxalVideo;
String valueChose1, valueChose2;
YoutubePlayerController _controller;
TextEditingController _idController = linkVideo;
TextEditingController _seekToController;

PlayerState _playerState;
YoutubeMetaData _videoMetaData;
double _volume = 100;
bool _muted = false;
bool _isPlayerReady = false;
