# http_proxy_override
[![Build Status](https://api.cirrus-ci.com/github/littleGnAl/http_proxy_override.svg)](https://cirrus-ci.com/github/littleGnAl/http_proxy_override) 
[![pub package](https://img.shields.io/pub/v/http_proxy_override.svg)](https://pub.dev/packages/http_proxy_override)

**http_proxy_override** get the proxy settings from system, so you can set up proxy for [http](https://pub.dev/packages/http), that allow you to use Charles or other proxy tools in Flutter.

## Usage

You should set up before the [http](https://pub.dev/packages/http) request, typically before `runApp()`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxyOverride httpProxyOverride =
      await HttpProxyOverride.createHttpProxy();
  HttpOverrides.global = httpProxyOverride;
  runApp(MyApp());
}
```

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