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
  /// The host part of the proxy address.
  final String? host;

  /// The port part of the proxy address.
  final String? port;

  /// Configures whether a secure connection to a host should be allowed with
  /// a server certificate that cannot be authenticated by any of the trusted
  /// root certificates.
  final bool ignoreBadCertificates;

  final SecurityContext securityContext;

  HttpProxyOverride._(
      this.host, this.port, this.ignoreBadCertificates, this.securityContext);

  /// Create an instance of [HttpProxyOverride].
  ///
  /// Reads the configured proxy host and port from the underlying platform
  /// and configures the [HttpClient] to use the proxy. The proxy settings are
  /// read once at creation time.
  ///
  /// [ignoreBadCertificates] configures whether a secure connection to a host
  /// should be allowed with a server certificate that cannot be authenticated
  /// by any of our trusted root certificates.
  /// For example, this can be useful when using debugging proxies like Charles
  /// or mitmproxy during development.
  /// **Do not enable this in production unless you are 100% sure.** Setting
  /// this enables MITM attacks.
  /// Default: `false`.
  ///
  /// With [securityContext] a [SecurityContext] can be provided that is used to
  /// construct the [HttpClient]. This can be useful to provide a
  /// [SecurityContext] that is configured with certificates that a proxy
  /// server requires.
  ///
  /// Supported platforms to read proxy settings from are **iOS** and
  /// **Android**.
  static Future<HttpProxyOverride> create(
      {bool ignoreBadCertificates = false,
      SecurityContext? securityContext}) async {
    return HttpProxyOverride._(
        await _getProxyHost(),
        await _getProxyPort(),
        ignoreBadCertificates,
        securityContext ?? SecurityContext.defaultContext);
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (context == null) {
      context = this.securityContext;
    }

    var client = super.createHttpClient(context);

    if (ignoreBadCertificates) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    }

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
