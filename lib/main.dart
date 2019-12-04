import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:martialme/locator.dart';
import 'package:martialme/model/userLocation.dart';
import 'package:martialme/pages/home_page.dart';
import 'package:martialme/pages/loginTest.dart';
import 'package:martialme/provider/LocationService.dart';
import 'package:martialme/provider/groupProvider.dart';
import 'package:martialme/provider/placesProvider.dart';
import 'package:martialme/provider/userProvider.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(ChangeNotifierProvider(
      builder: (_) => UserProvider.initialize(),child: new MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(builder: (_) => locator<PlacesProvider>()),
      ChangeNotifierProvider(builder: (_) => locator<GroupProvider>()),
      StreamProvider<UserLocation>(builder: (context) => LocationService().locationStream)
    ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.white,
            disabledColor: Colors.grey,
            appBarTheme: AppBarTheme(elevation: 0.0)),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: Consumer(
            builder: (context, UserProvider user, _) {
              switch (user.status) {
                case Status.Unitialized:
                case Status.Unauthenticated:
                case Status.Authenticating:
                  return LoginTest();
                case Status.Authenticated:
                return HomePage(users: user.user, currentUserid: user.user.uid);
                default: return LoginTest();
              }
            },
           
          ),
    );
  }
}
