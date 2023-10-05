import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/blog_info_screen.dart';
import 'package:flutter_blog_explorer/database.dart';
import 'package:flutter_blog_explorer/favorites_screen.dart';
import 'package:flutter_blog_explorer/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';



class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  @override
  void initState() {
    final blogProvider = Provider.of<BlogsProvider>(context,listen: false);
    blogProvider.getDataFromApi();
    super.initState();
  }

  final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 5),
  ));

DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Blog Explorer'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
                  icon: Icon(Icons.favorite,
                  color: Colors.white,
                    size: 40,
                  )
              ),
            )
          ],
        ),
        body: blogProvider.isLoading ? getLoadingUi()
            : blogProvider.error.isNotEmpty ? getErrorUi(blogProvider.error)
            : getBodyUi(blogProvider.blogs)
    );
  }

  Widget getLoadingUi() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitRotatingPlain(
            color: Colors.deepOrangeAccent,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget getErrorUi(String error) {
    return Center(
      child: Card(
color: Colors.deepOrangeAccent,
        child: SizedBox(
          height: 150,
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sorry For The Inconvenience',
              style: TextStyle(color: Colors.white,
                fontSize: 18,
              ),
              ),
              Text('Error Code :- $error',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBodyUi(BlogsModel blogs) {
    return ListView.builder(
        itemCount: blogs.blogs.length,
        itemBuilder: (context, index) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: ()async{
              final blogProvider = Provider.of<BlogsProvider>(context, listen: false);
await blogProvider.blogInfo(
    blogs.blogs[index].id,
    blogs.blogs[index].title,
    blogs.blogs[index].image_Url);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlogInfoScreen()));
            },
            onDoubleTap: () async {
                final blogProvider = Provider.of<BlogsProvider>(context, listen: false);
                await blogProvider.insertOrUpdateFavorite(
    Blog( id: blogs.blogs[index].id,
    image_Url: blogs.blogs[index].image_Url,
    title: blogs.blogs[index].title),
    true);

                if (blogProvider.error1.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 12,
                      backgroundColor: Colors.deepOrangeAccent,
                      duration: Duration(seconds: 3),
                      content: Center(child: Text(blogProvider.error1)),
                    ),
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 12,
                      backgroundColor: Colors.deepOrangeAccent,
                      duration: Duration(seconds: 3),
                      content: Center(child: Text("Added As Favorites")),
                    ),
                  );
                }
            },
            child: Container(
              child: Column(
                children: [
                CachedNetworkImage(
                    imageUrl: blogs.blogs[index].image_Url,
                  cacheManager: customCacheManager,
                  placeholder: (context,url) => Center(
                    child: SpinKitThreeInOut(
                        color: Colors.blue,
                        size: 20.0
                    )
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fadeInCurve: Curves.bounceIn,
                  fadeInDuration: Duration(milliseconds: 300),
                  imageBuilder: (context,imageProvider) => Image(
                    image: imageProvider,
                  ),
                ),
                  Text(
                      blogs.blogs[index].title
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
