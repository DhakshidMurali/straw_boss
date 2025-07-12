import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Auth/LoginScreen.dart';
import 'package:sp_app/Modules/Shared/Screens/LoadingScreen.dart';
import 'package:sp_app/Modules/Shared/Screens/SHCreateFormScreen.dart';
import 'package:sp_app/Modules/Shared/Screens/SHHomeScreen.dart';
import 'package:sp_app/Modules/Students/Screens/STSubmitFromScreen.dart';

import 'Modules/Students/Screens/Quiz/IntroQuizScreen.dart';
import 'Provider/Data.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Data(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Data(),
        // ),
      ],
      child: MaterialApp(
        title: 'Straw Boss',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Lato',
        ),
        routes: {},
        home: LandingScreen(),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<List> landingPageDecider() async {
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    print(sharedpref.getString('id'));
    if (sharedpref.getString('id') != null) {
      final provider = Provider.of<Data>(context, listen: false);

      await provider.getWorks();
      return ['home', sharedpref.getString('name')];
    }
    if (sharedpref.getString('id') == null) {
      return ['signIn'];
    }
    return ['loading', ''];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: landingPageDecider(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data![0] == 'home')
              return SHHomeScreen(snapshot.data![1]);
            if (snapshot.data![0] == 'signIn') return LoginScreen();
          }

          return LoadingScreen();
        });
  }
}
