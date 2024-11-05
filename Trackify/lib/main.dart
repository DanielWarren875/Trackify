import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spotify_stats_3/auth.dart';
import 'package:spotify_stats_3/firebase_options.dart';
import 'package:spotify_stats_3/social.dart';
import 'package:spotify_stats_3/start.dart';
import 'package:spotify_stats_3/stats.dart';
import 'package:spotify_stats_3/top.dart';
import 'package:spotify_stats_3/uifunctions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const start());
}

class myApp extends StatelessWidget {
  final auth;
  const myApp({super.key, required this.auth});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: home(auth: auth),
    );
  }
}

class home extends StatefulWidget {
  final auth;
  const home({super.key, required this.auth});
  @override
  State<StatefulWidget> createState() => _home();
}

class _home extends State<home> {
  int curr = 0;
  late Auth auth;
  late List<Widget> options;
  void onTapped(int index) {
    setState(() {
      curr = index;
    });
  }

  @override
  void initState() {
    super.initState();
    auth = widget.auth;
    options = <Widget>[
      Stats(auth: auth),
      const Social(),
      TopScreen(auth: auth),
      const Placeholder()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
              child: options.elementAt(curr),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTapped,
              currentIndex: curr,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Stats'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: 'Social'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Top'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: 'Activity'),
              ],
            )));
  }
}
