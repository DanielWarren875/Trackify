import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:spotify_stats_3/main.dart';

class Auth {
  final String access_token;
  final String token_type;
  final String scope;
  final int expires_in;
  final String refresh_token;

  const Auth(
      {required this.access_token,
      required this.token_type,
      required this.scope,
      required this.expires_in,
      required this.refresh_token});
  factory Auth.fromJson(Map<String, dynamic> json) {
    Auth hold = Auth(
        access_token: json['access_token'],
        token_type: json['token_type'],
        scope: json['scope'],
        refresh_token: json['refresh_token'],
        expires_in: json['expires_in']);
    return hold;
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreen createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  late StreamSubscription _onDestroy;
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  late Future<Auth> data;
  late String token;
  late Auth authData;
  Future<Auth> auth(String code) async {
    String hold = base64Url.encode(utf8.encode(
        'bf9fd0131e0a4c56ab5ec69dc87befc3:9ab7c1a94f2841d6bb97102680edd97d'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      body: <String, String>{
        "grant_type": "authorization_code",
        'code': code,
        'redirect_uri': 'http://localhost:80'
      },
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic $hold'
      },
    );
    if (response.statusCode == 200) {
      return Auth.fromJson(jsonDecode(response.body));
    } else {
      throw (Exception('Failed'));
    }
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authData = Auth(
        access_token: 'access_token',
        token_type: 'token_type',
        scope: 'scope',
        expires_in: 0,
        refresh_token: 'refresh_token');
    //flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      //print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      //print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith('http://localhost/?code=')) {
            String code = url.substring(23);
            data = auth(code);
            setAuthData(data);
          }
        });
      }
    });
  }

  Future<void> setAuthData(data) async {
    this.authData = await data;
    flutterWebviewPlugin.close();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => myApp(auth: authData)));
  }

  @override
  Widget build(BuildContext context) {
    String scope =
        'user-read-playback-state,user-top-read,user-read-recently-played,user-read-private';
    String loginUrl =
        "https://accounts.spotify.com/authorize?response_type=code&client_id=bf9fd0131e0a4c56ab5ec69dc87befc3&scope=$scope&redirect_uri=http://localhost:80";
    return WebviewScaffold(
        url: loginUrl,
        appBar: AppBar(
          title: const Text("Login to Spotify"),
        ));
  }
}
