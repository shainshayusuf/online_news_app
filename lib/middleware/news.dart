import 'dart:convert';

import 'package:online_news_app/models/article.dart';
import 'package:http/http.dart' as http;

class News {
  List<Article> articles = List<Article>();

  Future<void> getNewsHeadlines(String country) async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=$country&apiKey=2c72cee771bd441f8147f103df72c817";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["description"] != null && element["urlToImage"] != null) {
          Article article = Article();
          article.title = element["title"];
          article.description = element["description"];
          article.url = element["url"];
          article.urlToImage = element["urlToImage"];
          article.publishedTime = element["publishedAt"];
          articles.add(article);
        }
      });
    }
  }

  Future<void> getNewsByCategory(String country, String category) async {
    String url =
        "http://newsapi.org/v2/top-headlines?category=$category&country=$country&apiKey=2c72cee771bd441f8147f103df72c817";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["description"] != null && element["urlToImage"] != null) {
          Article article = Article();
          article.title = element["title"];
          article.description = element["description"];
          article.url = element["url"];
          article.urlToImage = element["urlToImage"];
          article.publishedTime = element["publishedAt"];
          articles.add(article);
        }
      });
    }
  }
}
