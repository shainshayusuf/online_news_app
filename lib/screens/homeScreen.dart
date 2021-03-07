import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_news_app/middleware/data.dart';
import 'package:online_news_app/middleware/news.dart';
import 'package:online_news_app/models/article.dart';
import 'package:online_news_app/models/category.dart';
import 'package:online_news_app/widgets/categoryTile.dart';
import 'package:online_news_app/widgets/newsTile.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = List<Category>();
  List<Article> articles = List<Article>();
  String fetchTime;
  bool _enabled = true;
  // SharedPreferences prefs;

  News news = News();

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if(enabled){
       print("Background fetch enabled");
    }
    else{
     print("Background fetch disabled");
    }
  }


    

  // initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   fetch = jsonDecode(prefs.getString("fetchEnabled"));
  //   if(fetch == null){
  //     print("Fetch not");
  //   }
  //   else{
  //     print("Fetch available");
  //   }
  // }
  getAndSetNews() async {
    await news.getNewsHeadlines("in");
    articles = news.articles;
    fetchTime = DateFormat('h:mm a').format(DateTime.now());
    setState(() {});
  }

  @override
  void initState() {
    categories = getCategoryData();
    getAndSetNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online News App"),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable,activeColor: Colors.white,),
          ]
      ),
     
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                        categories[index].imgUrl, categories[index].label);
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Last fetched:' + fetchTime,
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            articles = [];
                          });
                          getAndSetNews();
                        },
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ),
              articles.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: articles.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return NewsTile(article: article);
                      })
            ],
          ),
        ),
      ),
    );
  }
}
