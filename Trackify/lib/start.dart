import 'package:flutter/material.dart';
import 'package:spotify_stats_3/auth.dart';
import 'package:spotify_stats_3/main.dart';

//void main() => runApp(const start());

class start extends StatefulWidget {
  const start({super.key});

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {
  late Auth auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/WebViewContainer': (context) => AuthScreen(),
          '/main': (context) => const start(),
        },
        home: Builder(
            builder: (context) => Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(100, 200, 100, 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: Placeholder(),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Text(
                                  'Trackify',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      decoration: TextDecoration.none),
                                )),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 15),
                                child: Text(
                                  'Music analytics for Spotify',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      decoration: TextDecoration.none),
                                )),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 290, 5, 15),
                      child: SizedBox(
                        height: 60,
                        width: 400,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/WebViewContainer');
                            },
                            child: const Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text('Login With Spotify',
                                    style: TextStyle(color: Colors.black)))),
                      ),
                    )
                  ],
                )));
  }
}
