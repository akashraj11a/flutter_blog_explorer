import 'package:flutter/widgets.dart';
import 'package:flutter_blog_explorer/model.dart';
import 'package:http/http.dart' as http;

import 'database.dart';

class BlogsProvider extends ChangeNotifier{

   DatabaseHelper databaseHelper = DatabaseHelper.instance;
String id ="";
   String title ="";
   String url ="";

  bool isLoading = true;
  String error = '';
   String error1 = '';
   var data;
  BlogsModel blogs = BlogsModel(blogs: []);
   BlogsModel favBlogs = BlogsModel(blogs: []);


   getDataFromApi()async{
    try{
       http.Response response = await http.get(Uri.parse("https://intent-kit-16.hasura.app/api/rest/blogs"),
       headers: {
         'x-hasura-admin-secret': "32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6"
       }
       );
       if(response.statusCode == 200){
         blogs =  blogsModelFromJson(response.body);
       }
else{
  error = response.statusCode.toString();
       }
    }
    catch(e){
error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }


   loadFavoriteBlogs() async {
     final List<Map<String, dynamic>> rows = await databaseHelper.fetchData();

     favBlogs = BlogsModel(blogs: rows.map((row) {
       return Blog(
         id: row['id'] as String,
         image_Url: row['imageUrl'] as String,
         title: row['title'] as String,
       );
     }).toList());

     notifyListeners();
   }
   Future<void> insertOrUpdateFavorite(Blog blog, bool isFavorite) async {
     final db = await databaseHelper.database;
     final blogExists = favBlogs.blogs.any((favBlog) => favBlog.id == blog.id);

     if (blogExists) {
       error1 = 'Data is already added.';
     } else {
       await databaseHelper.insertFavorite(blog, isFavorite);
       favBlogs.blogs.add(blog);
       error1 = '';
     }

     notifyListeners();
   }

   Future<void> deleteFavoriteBlog(String id) async {
     await databaseHelper.deleteBlog(id);
     favBlogs.blogs.removeWhere((blog) => blog.id == id);
     notifyListeners();
   }
   Future blogInfo(String id, String title, String url) async {
     this.id = id;
     this.title=title;
     this.url = url;
     notifyListeners();
   }
}























/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'database.dart';
import 'http_request.dart';
import 'model.dart';

import 'package:flutter/material.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> _favoriteBlogs = [];

  List<Blog> get blogs => _blogs;
  List<Blog> get favoriteBlogs => _favoriteBlogs;

  final BlogApi _api;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  BlogProvider(this._api);

  Future<void> fetchBlogs() async {
    try {
      final response = await _api.fetchBlogs();
      print('API Response: $response'); // Add this line to check the API response
      if (response is List) {
        // If the response is a list, assume it's an array of blog objects
        _blogs = response.map((data) {
          return Blog(
            id: data['id'] is String ? int.tryParse(data['id']) ?? 0 : data['id'],
            title: data['title'] is String ? data['title'] : '',
            image: data['image_url'] is String ? data['image_url'] : '',
          );
        }).toList();
      } else if (response is Map<String, dynamic> && response.containsKey('blogs')) {
        // If the response is a map with a "blogs" key, extract the list from there
        final List<dynamic> blogDataList = response['blogs'];
        _blogs = blogDataList.map((data) {
          return Blog(
            id: data['id'] is String ? int.tryParse(data['id']) ?? 0 : data['id'],
            title: data['title'] is String ? data['title'] : '',
            image: data['image_url'] is String ? data['image_url'] : '',
          );
        }).toList();
      } else {
        throw Exception('Invalid API response format');
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching blogs: $e');
      // Return an empty list in case of an exception
      _blogs = [];
    }
  }

  Future<void> toggleFavoriteStatus(int blogId) async {
    final blog = _blogs.firstWhere((b) => b.id == blogId);
    blog.isFavorite = !blog.isFavorite;
    notifyListeners();

    if (blog.isFavorite) {
      await _databaseHelper.insertFavorite(blogId, true);
    } else {
      await _databaseHelper.removeFavorite(blogId);
    }
  }

  Future<void> loadFavoriteBlogs() async {
    final favoriteBlogIds = await _databaseHelper.getFavoriteBlogIds();

    _favoriteBlogs = _blogs.where((blog) {
      return favoriteBlogIds.contains(blog.id);
    }).toList();

    notifyListeners();
  }
}

*/
