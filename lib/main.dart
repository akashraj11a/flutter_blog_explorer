import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_explorer/provider.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';

void main(){
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => BlogsProvider(),
      child: MaterialApp(
theme: ThemeData(
  appBarTheme:AppBarTheme(
    color: Colors.deepOrangeAccent
  )
),
        title: 'Blog Explorer',
        debugShowCheckedModeBanner: false,
        home: BlogListScreen(),
      ),

    );
  }
}
