import 'package:flutter/material.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/hide_ContactProvider.dart';
import 'package:mycontacts/Provider/imageProvider.dart';
import 'package:mycontacts/Provider/search_contactProvider.dart';
import 'package:mycontacts/Provider/stepper_provider.dart';
import 'package:mycontacts/Provider/themeProvider.dart';
import 'package:mycontacts/View/detailPage.dart';
import 'package:mycontacts/View/hideContact.dart';
import 'package:mycontacts/View/homePage.dart';
import 'package:mycontacts/View/searchPage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => StepperProvider()),
        ChangeNotifierProvider(create: (context) => HideContactProvider()),
        ChangeNotifierProvider(create: (context) => imageProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: myApp(),
    ),
  );
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: (Provider.of<ThemeProvider>(context).appTheme.isDark)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        "detailPage": (context) => DetailPage(),
        "hidePage": (context) => hidePage(),
        "search": (context) => SearchPage(),
      },
    );
  }
}
