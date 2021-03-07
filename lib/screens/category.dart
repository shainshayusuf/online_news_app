import 'package:flutter/material.dart';
import 'package:online_news_app/middleware/news.dart';
import 'package:online_news_app/models/article.dart';
import 'package:online_news_app/widgets/newsTile.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen(this.category);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Article> articles = List<Article>();

  News news = News();

  getAndSetNews() async {
    await news.getNewsByCategory("in", widget.category.toLowerCase());
    articles = news.articles;
    setState(() {});
  }

  @override
  void initState() {
    getAndSetNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} News"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: articles.length == 0
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: articles.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return NewsTile(article: article);
                }),
      ),
    );
  }
}
