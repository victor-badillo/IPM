import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';
import 'my_home_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'app_klk',
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            backgroundColor: Colors.grey[200],
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}