class Artist {
  final artistName;
  final genre;
  final popularity;
  final imageUrl;
  final artistId;
  late int count;
  Artist({
    required this.artistName,
    required this.genre,
    required this.popularity,
    required this.imageUrl,
    required this.artistId,
  });
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistName: json['artistName'],
      genre: json['genre'],
      popularity: json['popularity'],
      imageUrl: json['imageUrl'],
      artistId: json['artistId'],
    );
  }
}

class Track {
  final trackName;
  final artistName;
  final albumImageUrl;
  final duration;
  final popularity;
  final trackId;
  final artistIds;
  final genres;
  late String date;
  late int count;
  Track(
      {required this.trackName,
      required this.artistName,
      required this.albumImageUrl,
      required this.duration,
      required this.popularity,
      required this.trackId,
      required this.artistIds,
      required this.genres});
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackId: json['trackId'],
      trackName: json['trackName'],
      albumImageUrl: json['albumImageUrl'],
      popularity: json['popularity'],
      artistName: json['artistName'],
      artistIds: json['artistId'],
      duration: json['duration'],
      genres: json['genre'],
    );
  }

  factory Track.fromJson1(Map<String, dynamic> json) {
    List<String> artIds = [];
    List<String> artNames = [];
    for (var i in json['artists']) {
      artIds.add(i['id']);
      artNames.add(i['name']);
    }
    return Track(
        trackId: json['id'],
        trackName: json['name'],
        albumImageUrl: json['album']['images'][0]['url'],
        popularity: json['popularity'],
        artistName: artNames,
        artistIds: artIds,
        duration: json['duration'],
        genres: []);
  }
}

class Users {
  final userId;
  late String accTok;
  late String refreshTok;
  Users({required this.userId});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(userId: json['id']);
  }
}

class genreData {
  String genre;
  int count;

  genreData({required this.genre, required this.count});
}

class PlayState {
  final isActive;
  final trackName;
  final artistNames;
  final imageUrl;
  final played_at;

  const PlayState(
      {required this.isActive,
      required this.trackName,
      required this.artistNames,
      required this.imageUrl,
      required this.played_at});

  factory PlayState.fromJson(Map<String, dynamic> json) {
    List<dynamic> holdArts = json['item']['artists'];
    List<String> artNames = [];
    for (int i = 0; i < holdArts.length; i++) {
      artNames.add(holdArts[i]['name']);
    }
    String hold;
    if (json['device']['is_active'] as bool == true) {
      hold = "Currently Playing";
    } else {
      hold = "Currently Paused";
    }

    return PlayState(
        isActive: hold,
        trackName: json['item']['name'],
        artistNames: artNames,
        imageUrl: json['item']['album']['images'][0]['url'],
        played_at: Null);
  }
}

class RecentlyPlayed {
  final trackName;
  final artistNames;
  final imageUrl;
  static const isActive = 'Currently Paused';
  final played_at;
  RecentlyPlayed(
      {required this.trackName,
      required this.artistNames,
      required this.imageUrl,
      required this.played_at});

  factory RecentlyPlayed.fromJson(Map<String, dynamic> json) {
    var holdArts = json['items'][0]['track']['artists'];
    List<String> artNames = [];
    for (int i = 0; i < holdArts.length; i++) {
      artNames.add(holdArts[i]['name']);
    }

    return RecentlyPlayed(
        trackName: json['items'][0]['track']['name'],
        artistNames: artNames,
        played_at: json['items'][0]['played_at'],
        imageUrl: json['items'][0]['track']['album']['images'][0]['url']);
  }
}
