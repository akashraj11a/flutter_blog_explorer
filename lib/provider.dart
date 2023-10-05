import 'package:connectivity/connectivity.dart';
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
   bool isConnected = true;


   void setIsConnected(bool value) {
     isConnected = value;
     notifyListeners();
   }


   getDataFromApi()async{
    try{
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        setIsConnected(false);
        return;
      }
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
setIsConnected(false);
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

