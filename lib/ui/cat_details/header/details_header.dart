import 'dart:async';

import 'package:cat_adoption/models/cat.dart';
import 'package:cat_adoption/services/api.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cat_adoption/ui/cat_details/header/cat_colored_image.dart';

class CatDetailHeader extends StatefulWidget {
  final Cat cat;
  final Object avatarTag;

  CatDetailHeader(this.cat, {@required this.avatarTag});

  @override
  _CatDetailHeaderState createState() => _CatDetailHeaderState();

}

class _CatDetailHeaderState extends State<CatDetailHeader> {

  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';
  bool _likeDisabled = true;
  String _likeText = "";
  int _likeCounter = 0;
  StreamSubscription _watcher;

  Future<CatApi> _api;


  @override
  void initState() {
    super.initState();
    _likeCounter = widget.cat.likeCounter;
    _api = CatApi.signInWithEmail("sam@ok.com", "samiam123");
    updateLikeState();
  }

  void likeCat() async {
    final api = await _api;
    if (await api.hasLikedCat(widget.cat)) {
      api.unlikeCat(widget.cat);
      setState(() {
        _likeCounter -= 1;
        _likeText = "LIKE";
      });
    } else {
      api.likeCat(widget.cat);
      setState(() {
        _likeCounter += 1;
        _likeText = "UNLIKE";
      });
    }
  }

  void updateLikeState() async {
    final api = await _api;

    _watcher = api.watch(widget.cat, (cat) {
      if (mounted) {
        setState(() {
          _likeCounter = cat.likeCounter;
        });
      }
    });

    bool liked = await api.hasLikedCat(widget.cat);
    if(mounted) {
      setState(() {
        _likeDisabled = false;
        _likeText = liked ? "UNLIKE": "LIKE";
      });
    }
  }


  @override
  void dispose() {
    if(_watcher != null) {
      _watcher.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

    var diagonalBackground = DiagonallyCutColoredImage(
      Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB42A5F5),
    );

    var avatar = Hero(
      tag: widget.avatarTag,
      child: CircleAvatar(
        backgroundImage: NetworkImage(widget.cat.avatarUrl),
        radius: 75.0,
      ),
    );

    var likeInfo = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            color: Colors.white,
            size: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              _likeCounter.toString(),
              style: textTheme.subhead.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );


    var actionButtons = Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: MaterialButton(
              minWidth: 140.0,
                color: theme.accentColor,
                textColor: Colors.white,
                onPressed: () async {

                },
              child: Text("ADOPT ME"),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: RaisedButton(
              color: Colors.lightGreen,
                disabledColor: Colors.grey,
                textColor: Colors.white,
                onPressed: _likeDisabled ? null: likeCat,
              child: Text(_likeText),
            )

          )
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        diagonalBackground,
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: Column(
            children: <Widget>[
              avatar,
              likeInfo,
              actionButtons,
            ],
          ),
        ),
        Positioned(
          top: 26.0,
          left: 4.0,
          child: BackButton(color: Colors.white),
        )
      ],
    );
  }

}