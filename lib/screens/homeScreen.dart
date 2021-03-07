import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:online_news_app/middleware/data.dart';
import 'package:online_news_app/middleware/news.dart';
import 'package:online_news_app/models/article.dart';
import 'package:online_news_app/models/category.dart';
import 'package:online_news_app/widgets/categoryTile.dart';
import 'package:online_news_app/widgets/newsTile.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = List<Category>();
  List<Article> articles = List<Article>();
  // List<dynamic> stringList = List<dynamic>();
  String fetchTime;
  bool _enabled = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;

  News news = News();

  getAndSetNews() async {
    await news.getNewsHeadlines("in");
    articles = news.articles;
    setState(() {
      fetchTime = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var fetchVal = prefs.getBool('fetch');
    if (fetchVal != null) {
      _enabled = fetchVal;
    } else {
      _enabled = false;
    }
    var fetchTimeString = prefs.getString('time');

    if (_enabled == true && fetchTimeString != null) {
      fetchTime = fetchTimeString;
    }
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: false,
            requiresBatteryNotLow: false,
            requiresCharging: true,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.CELLULAR), (String taskId) async {
      // <-- Event handler

      String jsonArticles = jsonEncode(articles);
      prefs.setString("article", jsonArticles);
      prefs.setString('time', fetchTime);

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    if (!mounted) return;
  }

  @override
  void initState() {
    categories = getCategoryData();
    getAndSetNews();
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Online News App"),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            Switch(
              value: _enabled,
              onChanged: (enabled) {
                setState(() {
                  _enabled = enabled;
                });
                if (enabled) {
                  BackgroundFetch.start().then((int status) {
                    print('[BackgroundFetch] start success: $status');
                  }).catchError((e) {
                    print('[BackgroundFetch] start FAILURE: $e');
                  });
                } else {
                  BackgroundFetch.stop().then((int status) {
                    print('[BackgroundFetch] stop success: $status');
                  });
                }
                prefs.setBool('fetch', enabled);
                String val = enabled == true ? 'enabled' : 'disbaled';
                final snackBar = SnackBar(
                  content: Text('Background fetch $val'),
                  duration: Duration(seconds: 2),
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              },
              activeColor: Colors.white,
            ),
          ]),
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
              fetchTime != null
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 10.0),
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
                    )
                  : Container(),
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
