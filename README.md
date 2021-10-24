# http_proxy_override

[![Build Status](https://api.cirrus-ci.com/github/littleGnAl/http_proxy_override.svg)](https://cirrus-ci.com/github/littleGnAl/http_proxy_override)
[![pub package](https://img.shields.io/pub/v/http_proxy_override.svg)](https://pub.dev/packages/http_proxy_override)

**http_proxy_override** gets the proxy settings from the platform, so you can set up the proxy for
[http](https://pub.dev/packages/http). E.g., this allows you to use Charles, mitm-proxy or other proxy tools in Flutter.

## Usage

You should set up before performing [http](https://pub.dev/packages/http) requests, typically before `runApp()`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxyOverride httpProxyOverride = await HttpProxyOverride.create();
  HttpOverrides.global = httpProxyOverride;
  runApp(MyApp());
}
```

## TLS Certificates

In some scenarios, proxy servers provide unexpected certificates that are not included in the platforms trusted CA
certificates. E.g. when inspecting HTTPS requests with Charles, the received server certificate is a self-signed
certificate created by Charles.

The library provides two options to handle such cases:

**`ignoreBadCertificates`**

```dart
void main() async {
  HttpProxyOverride httpProxyOverride = 
    await HttpProxyOverride.create(ignoreBadCertificates: true);
}
```

This sets a [`badCertificateCallback`](https://api.flutter.dev/flutter/dart-io/HttpClient/badCertificateCallback.html) 
that always returns `true` on created `HttpClient`s. This will bypass certificate checks and always allow the 
connection. This can be useful for development, when certificates aren't final or to avoid the setup hassle of 
certificates.
Be aware, that **this makes [Man-in-the-Middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) 
possible** as non-matching certificates are ignored. This should very likely never be used in production.

## License

    Copyright (C) 2021 littlegnal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
