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
  final String? host;
  final String? port;
  final bool ignoreBadCertificates;
  final List<Certificate>? trustedCertificates;

  HttpProxyOverride._(this.host, this.port, this.ignoreBadCertificates,
      this.trustedCertificates);

  static Future<HttpProxyOverride> createHttpProxy(
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

class Certificate {
  /// The bytes of a PEM or PKCS12 file containing X509 certificates.
  ///
  /// Example:
  /// ```
  ///    Certificate(
  ///        await new File('some-certificate.pem').readAsBytes()
  ///    );
  /// ```
  final List<int> certificateBytes;

  /// An optional password required to read the contents of [certificateBytes].
  final String? password;

  Certificate(this.certificateBytes, {this.password});
}
