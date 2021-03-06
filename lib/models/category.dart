// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
    Category({
        this.label,
        this.imgUrl,
    });

    String label;
    String imgUrl;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        label: json["label"],
        imgUrl: json["imgUrl"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "imgUrl": imgUrl,
    };
}
