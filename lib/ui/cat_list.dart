import 'package:flutter/material.dart';
import 'package:cat_adoption/models/cat.dart';
import 'package:cat_adoption/services/api.dart';
import 'dart:async';
import 'package:cat_adoption/utils/routes.dart';
import 'package:cat_adoption/ui/cat_details/details_page.dart';

class CatList extends StatefulWidget {
  @override
  _CatListState createState() => new _CatListState();
}

class _CatListState extends State<CatList> {
  List<Cat> _cats = [];
  CatApi _api;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
        tooltip: _api != null ? "Signed-in ${_api.firebaseUser.email}" : "Signed-out",
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.person
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFromFirebase();
  }

  _loadFromFirebase() async {
    final api = await CatApi.signInWithEmail("Sam@ok.com", "samiam123");
    final cats = await api.getAllCats();
    setState(() {
      _api = api;
      _cats = cats;
    });
  }

  _reloadCats() async {
    if (_api != null) {
      final cats = await _api.getAllCats();
      setState(() {
        _cats = cats;
      });
    }
  }

  _navigateToCatDetails(Cat cat, Object avatarTag) {
    Navigator.of(context).push(
      FadePageRoute(
        builder: (context) {
          return CatDetailsPage(cat, avatarTag: avatarTag);
        },
        settings: RouteSettings()
      )
    );
  }
  
  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      'Cats',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }

  Widget _buildCatItem(BuildContext context, int index) {
    Cat cat = _cats[index];

    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () => _navigateToCatDetails(cat, index),
              leading: Hero(
                tag: index,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(cat.avatarUrl),
                ),
              ),
              title: Text(
                cat.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: Text(cat.description),
              isThreeLine: true,
              dense: false,
            )
          ],
        ),
      ),

    );
  }

  Future<Null> refresh() {
   _reloadCats();
   return Future<Null>.value();
  }

  Widget _getListViewWidget() {
    return Flexible(
      child: RefreshIndicator(
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _cats.length,
              itemBuilder: _buildCatItem
          ),
          onRefresh: refresh
      ),
    );
  }

}