
import 'package:flutter/material.dart';
import 'package:online_news_app/middleware/data.dart';
import 'package:online_news_app/middleware/news.dart';
import 'package:online_news_app/models/article.dart';
import 'package:online_news_app/models/category.dart';
import 'package:online_news_app/widgets/categoryTile.dart';
import 'package:online_news_app/widgets/newsTile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<Category> categories = List<Category>();
  List<Article> articles = List<Article>();

  News news = News();

  getAndSetNews() async {
    await news.getNewsHeadlines("in");
    articles = news.articles;
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
                                padding: EdgeInsets.only(right: 10.0),
                       child: IconButton(icon: Icon(Icons.refresh),
                       onPressed: () {
                         setState(() {
                           articles = [];
                         });
                         getAndSetNews();
                       },
                       color: Colors.blueAccent,
                       ),
                  ),
              ),
              articles.length == 0?Center(child: CircularProgressIndicator()): ListView.builder(
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return NewsTile(
                        article:article);
                  })
            ],
          ),
        ),
      ),
    );
  }
}



