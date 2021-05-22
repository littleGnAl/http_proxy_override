import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_proxy_override/http_proxy_override.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxyOverride httpProxyOverride =
      await HttpProxyOverride.createHttpProxy();
  HttpOverrides.global = httpProxyOverride;
  runApp(MyApp(
    httpProxyOverride.host,
    httpProxyOverride.port,
  ));
}

class MyApp extends StatefulWidget {
  MyApp(this.host, this.port);
  late final String? host;
  late final String? port;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Host: ${widget.host}'),
              Text('Port: ${widget.port}'),
            ],
          ),
        ),
      ),
    );
  }
}
