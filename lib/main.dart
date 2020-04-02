import 'package:flutter/material.dart';
import 'package:polymaker/core/viewmodels/map_provider.dart';
import 'package:polymaker/ui/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        )
      ],
      child: MaterialApp(
        title: "Polymaker",
        theme: ThemeData(
          fontFamily: 'Proxima-Regular',
          accentColor: Colors.orange,
          primaryColor: Colors.orange
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}