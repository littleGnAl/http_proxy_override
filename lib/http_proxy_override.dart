import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'certificate.dart';

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

  /// Certificates added to the set of trusted X509 certificates used by
  /// [SecureSocket] client connections. Servers configured with these
  /// certificates will be trusted and HTTPS connections to the servers will be
  /// allowed.
  final List<Certificate>? trustedCertificates;

  HttpProxyOverride._(this.host, this.port, this.ignoreBadCertificates,
      this.trustedCertificates);

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
  /// [trustedCertificates] is an optional list of [Certificate]s that will be
  /// added to the set of trusted X509 certificates used by [SecureSocket]
  /// client connections. Servers configured with these certificates will be
  /// trusted and HTTPS connections to the servers will be allowed.
  ///
  /// Supported platforms to read proxy settings from are iOS and Android.
  static Future<HttpProxyOverride> create(
      {bool ignoreBadCertificates = false,
      List<Certificate>? trustedCertificates}) async {
    return HttpProxyOverride._(await _getProxyHost(), await _getProxyPort(),
        ignoreBadCertificates, trustedCertificates);
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (trustedCertificates != null &&
        trustedCertificates?.isNotEmpty == true) {
      if (context == null) {
        context = SecurityContext.defaultContext;
      }

      trustedCertificates?.forEach((Certificate cert) {
        context?.setTrustedCertificatesBytes(cert.certificateBytes,
            password: cert.password);
      });
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
