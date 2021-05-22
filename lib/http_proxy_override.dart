import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

MethodChannel _channel = MethodChannel('com.littlegnal.http_proxy_override');

Future<String?> _getProxyHost() async {
  return await _channel.invokeMethod('getProxyHost');
}

Future<String?> _getProxyPort() async {
  return await _channel.invokeMethod('getProxyPort');
}

class HttpProxyOverride extends HttpOverrides {
  late final String? host;
  late final String? port;

  HttpProxyOverride._(this.host, this.port);

  static Future<HttpProxyOverride> createHttpProxy() async {
    return HttpProxyOverride._(await _getProxyHost(), await _getProxyPort());
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    var client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
    return client;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? environment) {
    if (host == null) {
      return super.findProxyFromEnvironment(url, environment);
    }

    if (environment == null) {
      environment = {};
    }

    if (port != null) {
      environment['http_proxy'] = '$host:$port';
      environment['https_proxy'] = '$host:$port';
    } else {
      environment['http_proxy'] = '$host:8888';
      environment['https_proxy'] = '$host:8888';
    }

    return super.findProxyFromEnvironment(url, environment);
  }
}
