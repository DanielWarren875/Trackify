import 'package:flutter/material.dart';
import 'package:spotify_stats_3/uidata.dart';
import 'package:spotify_stats_3/uifunctions.dart';

class TopScreen extends StatelessWidget {
  final auth;
  const TopScreen({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Statistics App',
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: TopScreenPage(
        title: 'Spotify Statistics',
        auth: auth,
      ),
    );
  }
}

class TopScreenPage extends StatefulWidget {
  final auth;
  const TopScreenPage({super.key, required this.title, required this.auth});

  final String title;

  @override
  State<TopScreenPage> createState() => _TopScreenPageState();
}

class TrackData {}

class _TopScreenPageState extends State<TopScreenPage> {
  late functions func;
  late dynamic data;
  String timeRange = "4W";
  String dataType = "Tracks";
  int numPerRow = 2;
  Future<dynamic> _fetchData() async {
    Users user = await func.getUser();
    if (dataType == "Tracks") {
      List<Track> tracks = await func.getListenHistory(user.userId);
      print(tracks[0].trackName);
    }
  }

  @override
  void initState() {
    super.initState();
    func = functions(widget.auth);
    data = _fetchData();
  }

  Text setText(String text, Color color) {
    return Text(text, style: TextStyle(color: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToggleButtons(isSelected: [
                    false,
                    true,
                    false,
                    false
                  ], children: [
                    TextButton(
                      onPressed: () {},
                      child: setText('1D', Colors.white),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: setText('4W', Colors.white),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: setText('1Y', Colors.white),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: setText('All', Colors.white),
                    ),
                  ])
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[300])),
                        child: setText('Default', Colors.grey)),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[300])),
                        child: setText('No Border', Colors.grey)),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[300])),
                        child: setText('Art Only', Colors.grey)),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey[300])),
                        child: Icon(Icons.fullscreen)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {}, child: setText('Songs', Colors.grey)),
                  ),
                  Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: setText('Artists', Colors.grey))),
                  Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: setText('Albums', Colors.grey))),
                ],
              ),
            ])));
  }
}
