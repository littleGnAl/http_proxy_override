import 'dart:io';

/// A PEM or PKCS12 file containting X509 certificates that might be password
/// protected.
class Certificate {
  /// The bytes of a PEM or PKCS12 file containing X509 certificates.
  ///
  /// Example:
  /// ```dart
  /// Certificate(
  ///   await new File('some-certificate.pem').readAsBytes()
  /// );
  /// ```
  final List<int> certificateBytes;

  /// An optional password required to read the contents of [certificateBytes].
  /// The password is passed to [SecurityContext.setTrustedCertificatesBytes].
  final String? password;

  Certificate(this.certificateBytes, {this.password});
}
