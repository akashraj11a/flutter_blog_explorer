import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    final blogProvider = Provider.of<BlogsProvider>(context, listen: false);
    blogProvider.loadFavoriteBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogsProvider>(context);
    final favBlogs = blogProvider.favBlogs;

    if (favBlogs.blogs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          centerTitle: true,
        ),
        body: Center(
          child:
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: Image(
                image: AssetImage("images/Screenshot_2023-10-05_141759-removebg-preview.png")),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        centerTitle: true,
      ),
      body: Consumer<BlogsProvider>(
        builder: (context, blogProvider, _) {
        return  ListView.builder(
    itemCount: favBlogs.blogs.length,
    itemBuilder: (context, index) {
    final blog = favBlogs.blogs[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
            if (direction == DismissDirection.endToStart) {
              blogProvider.deleteFavoriteBlog(blog.id);
            }
          },
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.deepOrangeAccent,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          child: Container(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: blog.image_Url,
                  placeholder: (context, url) => Center(
                    child: SpinKitThreeInOut(
                      color: Colors.blue,
                      size: 20.0,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fadeInCurve: Curves.bounceIn,
                  fadeInDuration: Duration(milliseconds: 300),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(blog.title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    },
    );
        }


    ));
  }
}
