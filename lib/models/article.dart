import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
    Article({
        this.title,
        this.description,
        this.url,
        this.urlToImage,
        this.publishedTime
    });

    String title;
    String description;
    String url;
    String urlToImage;
    String publishedTime;

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedTime:json["publishedTime"]
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedTIme":publishedTime
    };
}
