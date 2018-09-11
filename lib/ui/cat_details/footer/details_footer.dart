import 'package:cat_adoption/models/cat.dart';
import 'package:cat_adoption/ui/cat_details/footer/showcase_cattributes.dart';
import 'package:cat_adoption/ui/cat_details/footer/showcase_details.dart';
import 'package:cat_adoption/ui/cat_details/footer/showcase_pictures.dart';
import 'package:flutter/material.dart';

class CatShowcase extends StatefulWidget {
  final Cat cat;

  CatShowcase(this.cat);

  @override
  _CatShowcaseState createState() => _CatShowcaseState();

}

class _CatShowcaseState extends State<CatShowcase>
    with TickerProviderStateMixin {

  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      Tab(text: "Pictures",),
      Tab(text: "Details",),
      Tab(text: "Cattributes",)
    ];

    _pages = [
      PicturesShowcase(widget.cat),
      DetailsShowcase(widget.cat),
      CattributesShowcase(widget.cat)
    ];

    _controller = TabController(
        length: _tabs.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.white,
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: TabBarView(
                controller: _controller,
                children: _pages
            ),
          )
        ],
      ),
    );
  }

}