import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_stats_3/auth.dart';
import 'package:spotify_stats_3/firestore_manager.dart';
import 'package:spotify_stats_3/uidata.dart';

class functions {
  var a;
  final fire = FirestoreManager();
  late Map<String, String> headers;

  functions(Auth auth) {
    headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ${auth.access_token}'
    };
  }

  DateTime getCutOff(String timeRange) {
    DateTime cutOff;
    switch (timeRange) {
      case '1D':
        cutOff = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        break;
      case '1M':
        cutOff = DateTime(
            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
        break;
      case '1Y':
        cutOff = DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
        break;
      default:
        cutOff = DateTime(DateTime.now().year - 10);
    }

    return cutOff;
  }

  Future<int> getSongsListened(String userId, String timeRange) async {
    DateTime cutOff = getCutOff(timeRange);
    var url = 'http://localhost:8888/get.php';
    final response = await http.post(Uri.parse(url), body: {
      'user': userId,
      'cutOff': cutOff.toString(),
      'query': 'songsListened'
    });

    dynamic hold = jsonDecode(response.body);
    if (hold.runtimeType == String) {
      return 0;
    }
    int count = hold.length;
    for (var i in hold) {
      if (i['count'] > 1) {
        count = count + i['count'] as int;
      } else {
        return count;
      }
    }

    return count;
  }

  Future<int> getStreak(String userId) async {
    var url = 'http://localhost:8888/get.php';
    final response = await http
        .post(Uri.parse(url), body: {'user': userId, 'query': 'streak'});
    int streak = 1;
    List<dynamic> hold = jsonDecode(response.body);
    Set<DateTime> dates = Set();
    for (var i in hold) {
      dates.add(DateTime.parse(i['dateListened']
          .toString()
          .substring(0, i['dateListened'].toString().indexOf(' '))));
    }
    List<DateTime> vals = dates.toList();
    if (vals[0] !=
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      return 0;
    }
    for (int i = 1; i < vals.length; i++) {
      if (vals[i].difference(vals[i - 1]).inDays == 1) {
        streak++;
      } else {
        return streak;
      }
    }
    return streak;
  }

  Future<List<Track>> getListenHistory(String userId) async {
    var url = 'http://localhost:8888/get.php';
    final response = await http
        .post(Uri.parse(url), body: {'user': userId, 'query': 'listenHistory'});
    List<dynamic> val = jsonDecode(response.body);
    List<Track> ret = [];
    List<String> trackIds = [];
    for (var i in val) {
      Track hold = Track.fromJson(i);
      if (!trackIds.contains(hold.trackId)) {
        hold.date = i['dateListened'];
        ret.add(hold);
        trackIds.add(hold.trackId);
      }
    }
    return ret;
  }

  Future<List<Artist>> getArtistData(String userId, String timeRange) async {
    DateTime cutOff = getCutOff(timeRange);
    var url = 'http://localhost:8888/get.php';
    final response = await http.post(Uri.parse(url), body: {
      'user': userId,
      'cutOff': cutOff.toString(),
      'query': 'artists'
    });
    if (response.body == 'The records were not found!') {
      return [];
    }
    var data = jsonDecode(response.body);
    if (data.runtimeType == String) {
      return [];
    }
    List<Artist> ret = [];
    for (var i in data) {
      Artist hold = Artist.fromJson(i);
      hold.count = i['artistCount'];
      ret.add(hold);
    }
    return ret;
  }

  Future<List<Track>> getTrackData(
      String userId, String timeRange, String query) async {
    DateTime cutOff = getCutOff(timeRange);
    var url = 'http://localhost:8888/get.php';
    final response = await http.post(Uri.parse(url),
        body: {'user': userId, 'cutOff': cutOff.toString(), 'query': query});
    if (response.body == 'The records were not found!') {
      return [];
    }
    var data = jsonDecode(response.body);
    if (data.runtimeType == String) {
      return [];
    }
    List<Track> ret = [];
    List<String> trackIds = [];
    for (var i in data) {
      Track hold = Track.fromJson(i);
      if (!trackIds.contains(hold.trackId)) {
        hold.count = i['trackCount'];
        ret.add(hold);
        trackIds.add(hold.trackId);
      }
    }
    return ret;
  }

  Future<PlayState> getPlayState() async {
    String url = 'https://api.spotify.com/v1/me/player';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      a = PlayState.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 204) {
      RecentlyPlayed b =
          RecentlyPlayed.fromJson(jsonDecode(await getRecentlyPlayed()));
      a = PlayState(
          isActive: 'Currently Paused',
          trackName: b.trackName,
          artistNames: b.artistNames,
          imageUrl: b.imageUrl,
          played_at: b.played_at);
    }
    return a;
  }

  Future<String> getRecentlyPlayed() async {
    String url = 'https://api.spotify.com/v1/me/player/recently-played?limit=1';
    final response = await http.get(Uri.parse(url), headers: headers);
    return response.body;
  }

  Future<Users> getUser() async {
    String url = 'https://api.spotify.com/v1/me';
    final response = await http.get(Uri.parse(url), headers: headers);

    dynamic info = json.decode(response.body);
    return Users.fromJson(info);
  }

  Future<dynamic> getGenSeeds() async {
    String url =
        'https://api.spotify.com/v1/recommendations/available-genre-seeds';
    final response = await http.get(Uri.parse(url), headers: headers);
    return json.decode(response.body)['genres'];
  }

  Future<List<String>> getTrackSeeds() async {
    String url =
        'https://api.spotify.com/v1/me/top/tracks?time_range=long_term&limit=5&offset=0';
    final response = await http.get(Uri.parse(url), headers: headers);
    List<dynamic> trackData = jsonDecode(response.body)['items'];
    List<String> ids = [];
    for (var i in trackData) {
      ids.add(i['id']);
    }

    return ids;
  }

  Future<List<Track>> getRecommendations() async {
    List<String> trackSeedIds = await getTrackSeeds();
    String url =
        'https://api.spotify.com/v1/recommendations?limit=10&seed_tracks=';
    for (var i in trackSeedIds) {
      url = '$url$i,';
    }
    url = url.substring(0, url.length - 1);
    final response = await http.get(Uri.parse(url), headers: headers);
    List<dynamic> arr = jsonDecode(response.body)['tracks'];
    List<Track> ret = [];
    for (var i in arr) {
      ret.add(Track.fromJson1(i));
    }

    return ret;
  }

  List<info> countTracks(List<Track> tracks) {
    List<info> ret = [];
    List<String> trackIds = [];
    for (int i = 0; i < tracks.length; i++) {
      if (trackIds.contains(tracks[i].trackId)) {
        ret[trackIds.indexOf(tracks[i].trackId)].count++;
      } else {
        info hold = info();
        hold.count = 1;
        hold.track = tracks[i];
        ret.add(hold);
      }
    }

    return ret;
  }
}

class info {
  late int count;
  late Track track;
}
