import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  const Social({super.key});

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
      home: const SocialScreen(title: 'Social'),
    );
  }
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key, required this.title});

  final String title;

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings),
        title: const Text('Social'),
        actions: const [Icon(Icons.search)],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('cydawg99',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text('trackify.am/1168371',
                        style: TextStyle(color: Colors.grey)),
                    Text('Joined September 2024',
                        style: TextStyle(color: Colors.grey)),
                    Text('0 Friends', style: TextStyle(color: Colors.grey))
                  ],
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(125, 5, 15, 0),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Placeholder(),
                    ))
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Divider(),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 15, 15, 7.5),
                height: 150,
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Listening Stats',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.grey[500])),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.fireplace)),
                                    Column(
                                      children: [
                                        const Text('Metalcore',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text('Top Genre',
                                            style: TextStyle(
                                                color: Colors.grey[800]))
                                      ],
                                    )
                                  ],
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.grey)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.music_note),
                                  Column(
                                    children: [
                                      const Text('39.3%',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text('Obscurity Rating',
                                          style: TextStyle(
                                              color: Colors.grey[800]))
                                    ],
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10, top: 25),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.grey)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.timelapse)),
                                    Column(
                                      children: [
                                        const Text('2 Hours Ago',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text('Last Listened',
                                            style: TextStyle(
                                                color: Colors.grey[800]))
                                      ],
                                    )
                                  ],
                                ))),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.grey)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.pause),
                                  Column(
                                    children: [
                                      const Text('4:07',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text('Avg. Duration',
                                          style: TextStyle(
                                              color: Colors.grey[800]))
                                    ],
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  )
                ])),
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Divider(),
            ),
            const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text('Friend Suggestions',
                    style: TextStyle(color: Colors.white))),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                                width: 150,
                                height: 200,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: WidgetStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ))),
                                            onPressed: () {},
                                            child: const Column(
                                              children: [
                                                Expanded(
                                                  child: Placeholder(),
                                                ),
                                                Text('Marissa Perez'),
                                                Text(
                                                  'You may know them',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            ))),
                                    SizedBox(
                                      height: 15,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ))),
                                          onPressed: () {},
                                          child: const Placeholder()),
                                    )
                                  ],
                                ))
                          ],
                        )))
              ],
            ),
            const Padding(padding: EdgeInsets.all(5), child: Divider()),
            const Row(
              children: [
                Column(
                  children: [
                    Text('Friends', style: TextStyle(color: Colors.white))
                  ],
                )
              ],
            )
          ]))
        ],
      ),
    );
  }
}
