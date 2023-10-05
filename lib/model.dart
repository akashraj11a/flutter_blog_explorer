import 'dart:convert';

BlogsModel blogsModelFromJson(String str) => BlogsModel.fromJson(json.decode(str));

String blogsModelToJson(BlogsModel data) => json.encode(data.toJson());

class BlogsModel {
  List<Blog> blogs;

  BlogsModel({
    required this.blogs,
  });

  factory BlogsModel.fromJson(Map<String, dynamic> json) => BlogsModel(
    blogs: List<Blog>.from(json["blogs"].map((x) => Blog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "blogs": List<dynamic>.from(blogs.map((x) => x.toJson())),
  };
}

class Blog {
  String id;
  String image_Url;
  String title;

  Blog({
    required this.id,
    required this.image_Url,
    required this.title,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    id: json["id"],
    image_Url: json["image_url"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_url": image_Url,
    "title": title,
  };
}
