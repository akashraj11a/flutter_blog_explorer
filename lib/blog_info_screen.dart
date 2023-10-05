import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BlogInfoScreen extends StatefulWidget {

  @override
  State<BlogInfoScreen> createState() => _BlogInfoScreenState();
}

class _BlogInfoScreenState extends State<BlogInfoScreen> {
  final customCacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 5), // Adjust as needed.
  ));
  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Details"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          child: Container(
            height: 220,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                      imageUrl: blogProvider.url,
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
                ),
                Row(
                  children: [
                    Text("ID :- ",style: TextStyle(color: Colors.deepOrangeAccent),),
                    Text( blogProvider.id)
                  ],
                ),
                Text("Title :- ${blogProvider.title}")
              ],
            ),
            ),
          ),
        ),

    );
  }
}
