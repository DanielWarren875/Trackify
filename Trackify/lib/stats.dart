import 'package:flutter/rendering.dart';
import 'package:spotify_stats_3/listening_stats.dart';
import 'package:spotify_stats_3/uifunctions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:spotify_stats_3/uidata.dart';

class Stats extends StatelessWidget {
  final auth;
  const Stats({super.key, required this.auth});

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
      home: MyHomePage(
        title: 'Spotify Statistics',
        auth: auth,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final auth;
  const MyHomePage({super.key, required this.title, required this.auth});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Data {
  final isActive;
  final trackName;
  final artistNames;
  final imageUrl;
  final topTracks;
  final topArtists;
  final obscurity;
  final avgTime;
  final streak;
  final recommendations;
  final genres;
  final songsListened;
  final recentlyPlayed;
  Data(
      {required this.isActive,
      required this.trackName,
      required this.artistNames,
      required this.imageUrl,
      required this.topTracks,
      required this.topArtists,
      required this.obscurity,
      required this.avgTime,
      required this.streak,
      required this.recommendations,
      required this.genres,
      required this.songsListened,
      required this.recentlyPlayed});
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Data> data;
  late List<Widget> tracks;
  String timeRange = '1D';
  late functions func;
  Future<Data> _fetchData() async {
    func = functions(widget.auth);
    Users user = await func.getUser();

    String userId = user.userId;
    int streak = await func.getStreak(userId);

    int songsListened = await func.getSongsListened(userId, timeRange);

    List<Track> topTracks =
        await func.getTrackData(userId, timeRange, 'tracks');

    PlayState b = await func.getPlayState();

    List<Artist> topArtists = await func.getArtistData(userId, timeRange);

    List<Track> recentlyPlayed = await func.getListenHistory(userId);

    List<Track> rec = await func.getRecommendations();

    List<genreData> heh = [];
    var d = Data(
        isActive: b.isActive,
        trackName: b.trackName,
        artistNames: b.artistNames,
        imageUrl: b.imageUrl,
        topTracks: topTracks,
        topArtists: topArtists,
        obscurity: 0,
        avgTime: 0,
        streak: streak,
        recommendations: rec,
        recentlyPlayed: recentlyPlayed,
        genres: heh,
        songsListened: songsListened);

    return d;
  }

  String calcListen(String dateListened) {
    DateTime listenedAt = DateTime.parse(dateListened);
    DateTime curr = DateTime.now();

    int diff = curr.difference(listenedAt).inMinutes;
    String timeType = "minute";

    while (diff > 30 && timeType != "day") {
      switch (timeType) {
        case "minute":
          diff = curr.difference(listenedAt).inHours;
          timeType = "hour";
          break;
        case "hour":
          diff = curr.difference(listenedAt).inDays;
          timeType = "day";
          break;
      }
    }

    if (diff > 1) {
      return "$diff ${timeType}s ago";
    } else {
      return "$diff $timeType ago";
    }
  }

  void nextScreen() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute(builder: (context) => ls()));
  }

  List<Widget> childr(snapshot) {
    List<Widget> ret = [];
    int len;
    if (snapshot.data?.recentlyPlayed.length >= 20) {
      len = 20;
    } else {
      len = snapshot.data?.recentlyPlayed.length;
    }
    for (int i = 0; i < len; i++) {
      ret.add(Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
              height: 100,
              width: 600,
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {},
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Image.network(
                              snapshot.data?.recentlyPlayed[i].albumImageUrl)),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data?.recentlyPlayed[i].trackName,
                                  style: TextStyle(color: Colors.white)),
                              Text(snapshot.data?.recentlyPlayed[i].artistName,
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                  calcListen(
                                      snapshot.data?.recentlyPlayed[i].date),
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ))
                    ]),
                  ))
                ],
              ))));
    }

    return ret;
  }

  void setTime(String val) {
    timeRange = val;
    setState(() {
      data = _fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    func = functions(widget.auth);
    data = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              )),
          title: const Text(
            'Statify',
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder<Data>(
            future: data,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Colors.green),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(2, 5, 0, 0),
                                          child: Text('Time Range',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setTime('1D');
                                                    },
                                                    child: const Text('1D',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setTime('1M');
                                                    },
                                                    child: const Text(
                                                        'Last Month',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 0, 10, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setTime('1Y');
                                                    },
                                                    child: const Text('Year',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 0, 10, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setTime('All');
                                                    },
                                                    child: const Text(
                                                      'All',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    )))
                          ],
                        ),
                        Expanded(
                            child: ListView(children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            height: 120,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: 325,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ))),
                                        onPressed: () {},
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.network(
                                                  '${snapshot.data?.imageUrl}'),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                      '${snapshot.data?.isActive}'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                      '${snapshot.data?.trackName}'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                            height: 200,
                                            width: 100,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        const WidgetStatePropertyAll(
                                                            Colors.grey),
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ))),
                                                onPressed: () {},
                                                child: const Icon(
                                                  Icons.circle,
                                                  color: Colors.white,
                                                ))))
                                  ],
                                ))
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 15, 15, 7.5),
                              height: 150,
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Listening Stats',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          Colors.grey[500])),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5, right: 1),
                                                      child: Icon(
                                                          Icons.fireplace)),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${snapshot.data?.streak}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                      Text('Day Streak',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[800]))
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
                                                    WidgetStatePropertyAll(
                                                        Colors.grey)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.music_note),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${snapshot.data?.songsListened}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text('Songs Listened',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800]))
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
                                      GestureDetector(
                                        onTap: () {
                                          nextScreen();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, bottom: 5),
                                          child: Text('View All',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: ElevatedButton(
                                              onPressed: () {},
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          Colors.grey)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(1),
                                                      child: Icon(
                                                          Icons.timelapse)),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('2 Hours',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Text('Spent',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[800]))
                                                    ],
                                                  )
                                                ],
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Colors.grey)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.pause),
                                                Column(
                                                  children: [
                                                    Text(
                                                        '${snapshot.data?.avgTime}',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text('Avg. Duration',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[800]))
                                                  ],
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                )
                              ])),
                          const Divider(),
                          const Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text('Top Artists',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('View All',
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: 250,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data?.topArtists.length,
                                    itemBuilder: (context, int index) {
                                      return Column(children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 15),
                                            child: SizedBox(
                                              width: 125,
                                              child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                      shape: WidgetStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ))),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Image.network(
                                                              snapshot
                                                                  .data
                                                                  ?.topArtists[
                                                                      index]
                                                                  .imageUrl),
                                                        ),
                                                      ),
                                                      Text(
                                                          '${index + 1}. ${snapshot.data?.topArtists[index].artistName}'),
                                                      Text(
                                                          '${snapshot.data?.topArtists[index].count} listens')
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: SizedBox(
                                              height: 10,
                                              width: 125,
                                              child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                      shape: WidgetStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ))),
                                                  child: const Placeholder()),
                                            ))
                                      ]);
                                    }),
                              ))
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.all(15), child: Divider()),
                          const Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text('Top songs',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('View All',
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data?.topTracks.length,
                                  itemBuilder: (context, int index) {
                                    return Column(children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 15),
                                          child: SizedBox(
                                            width: 125,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ))),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: Image.network(
                                                            snapshot
                                                                .data
                                                                ?.topTracks[
                                                                    index]
                                                                .albumImageUrl),
                                                      ),
                                                    ),
                                                    Text(
                                                        '${index + 1}. ${snapshot.data?.topTracks[index].trackName}'),
                                                    Text(
                                                        '${snapshot.data?.topTracks[index].count} Listens')
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: SizedBox(
                                            height: 10,
                                            width: 125,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ))),
                                                child: const Placeholder()),
                                          ))
                                    ]);
                                  },
                                ),
                              ))
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Divider(),
                          ),
                          const Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text('Recommendations',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('Play',
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      snapshot.data?.recommendations.length,
                                  itemBuilder: (context, int index) {
                                    return Column(children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 15),
                                          child: SizedBox(
                                            width: 125,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ))),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: Image.network(
                                                            snapshot
                                                                .data
                                                                ?.recommendations[
                                                                    index]
                                                                .albumImageUrl),
                                                      ),
                                                    ),
                                                    Text(
                                                        '${index + 1}. ${snapshot.data?.recommendations[index].trackName}'),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: SizedBox(
                                            height: 10,
                                            width: 125,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    shape: WidgetStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ))),
                                                child: const Placeholder()),
                                          ))
                                    ]);
                                  },
                                ),
                              ))
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Divider(),
                          ),
                          const Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text('Graphs',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('View All',
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: SizedBox(
                                    width: 350,
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: SizedBox(
                                              height: 200,
                                              width: 250,
                                              child: SfCartesianChart(
                                                primaryXAxis:
                                                    const CategoryAxis(),
                                                series: <CartesianSeries<
                                                    genreData, String>>[
                                                  ColumnSeries<genreData,
                                                          String>(
                                                      dataSource:
                                                          snapshot.data?.genres,
                                                      xValueMapper:
                                                          (genreData, _) =>
                                                              genreData.genre,
                                                      yValueMapper:
                                                          (genreData, _) =>
                                                              genreData.count)
                                                ],
                                              ),
                                            )),
                                        const Padding(
                                            padding: EdgeInsets.all(15),
                                            child: SizedBox(
                                              height: 200,
                                              width: 250,
                                              child: Placeholder(),
                                            )),
                                        const Padding(
                                            padding: EdgeInsets.all(15),
                                            child: SizedBox(
                                              height: 100,
                                              width: 200,
                                              child: Placeholder(),
                                            )),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.all(15), child: Divider()),
                          const Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text('Recently Played',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text('View All',
                                          style:
                                              TextStyle(color: Colors.green)))
                                ],
                              )),
                            ],
                          ),
                          Column(
                            children: childr(snapshot),
                          )
                        ])),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            }));
  }
}
