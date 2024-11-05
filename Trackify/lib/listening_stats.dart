import 'package:flutter/material.dart';

class ls extends StatelessWidget {
  const ls({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listening Stats',
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
      home: const ListeningStats(title: 'Listening Stats'),
    );
  }
}

class ListeningStats extends StatefulWidget {
  const ListeningStats({super.key, required this.title});

  final String title;

  @override
  State<ListeningStats> createState() => _ListeningStats();
}

class _ListeningStats extends State<ListeningStats> {
  void setTime(String val) {
    print(val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(
                context,
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text('Listening Stats'),
        ),
        body: Column(children: [
          Row(children: [
            Expanded(
                child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.green),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(2, 5, 0, 0),
                          child: Text('Time Range',
                              style: TextStyle(color: Colors.white)),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: GestureDetector(
                                    onTap: () {
                                      setTime('1D');
                                    },
                                    child: const Text('1D',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: GestureDetector(
                                    onTap: () {
                                      setTime('1M');
                                    },
                                    child: const Text('Last Month',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                child: GestureDetector(
                                    onTap: () {
                                      setTime('1Y');
                                    },
                                    child: const Text('Year',
                                        style:
                                            TextStyle(color: Colors.white)))),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                                child: GestureDetector(
                                    onTap: () {
                                      setTime('All');
                                    },
                                    child: const Text(
                                      'All',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          ],
                        ),
                      ],
                    ))),
          ]),
          Expanded(
              child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Overview',
                          style: TextStyle(color: Colors.white)))
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.fireplace),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text('25'), Text('Day Streak')],
                              ))
                        ],
                      ))
                ],
              )
            ],
          ))
        ]));
  }
}
