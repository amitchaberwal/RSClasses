import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsclassesadmin/Pages/Login/Splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(392, 835),
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.grey[50],
            scaffoldBackgroundColor: Colors.grey[100],
            accentColor: Colors.blue[600],
            secondaryHeaderColor: Colors.grey[900],
            cardColor: Colors.grey[200],
            textTheme:TextTheme(
              bodyText1: TextStyle(color: Colors.grey[900],fontSize: 20,letterSpacing: 1.0),
            ),
          ),
          home: Splash(),
        )
    );
  }
}

