import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify_stats_3/firebase_options.dart';
import 'package:spotify_stats_3/uidata.dart';

class FirestoreManager {
  late FirebaseFirestore db;

  Future<FirebaseApp> init() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirestoreManager() {
    db = FirebaseFirestore.instance;
  }

  Future<List<String>> getTrackIds(String userId, DateTime cutOff) async {
    DocumentSnapshot<Map<String, dynamic>> ref =
        await db.collection('Users').doc(userId).get();
    List<dynamic> trackRefs = ref['listenData'];
    List<String> tracks = [];
    for (int i = 0; i < trackRefs.length; i++) {
      if (DateTime.parse((trackRefs[i].keys.toList()[0]).toString())
              .compareTo(cutOff) <
          0) {
        return tracks;
      } else {
        tracks.add(trackRefs[i].values.toList()[0].id);
      }
    }
    return tracks;
  }

  Future<Artist> getArtistData(String id) async {
    dynamic hold = await (db.collection('Artists').doc(id)).get();
    Map<String, dynamic> map = hold.data();
    return Artist.fromJson(map);
  }

  Future<Track> getTrackData(String id) async {
    dynamic hold = await (db.collection('Tracks').doc(id)).get();
    Map<String, dynamic> map = hold.data();
    return Track.fromJson(map);
  }
}
