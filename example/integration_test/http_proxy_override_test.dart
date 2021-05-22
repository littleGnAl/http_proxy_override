import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_proxy_override/http_proxy_override.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http_proxy_override_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannel channel;

  setUp(() {
    channel = MethodChannel('com.littlegnal.http_proxy_override.test');
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  testWidgets(
    "Should get null proxy host, proxy port when http proxy not set",
    (WidgetTester tester) async {
      HttpProxyOverride httpProxyOverride =
          await HttpProxyOverride.createHttpProxy();
      HttpOverrides.global = httpProxyOverride;

      await tester.pumpWidget(app.MyApp(
        httpProxyOverride.host,
        httpProxyOverride.port,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Host: null'), findsOneWidget);
      expect(find.text('Port: null'), findsOneWidget);
    },
  );

  testWidgets(
    "Should get correct proxy host, proxy port when http proxy set",
    (WidgetTester tester) async {
      await channel.invokeMethod(
        'enableMockProxy',
        {'host': '127.0.0.1', 'port': '7890'},
      );

      HttpProxyOverride httpProxyOverride =
          await HttpProxyOverride.createHttpProxy();
      HttpOverrides.global = httpProxyOverride;

      await tester.pumpWidget(app.MyApp(
        httpProxyOverride.host,
        httpProxyOverride.port,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Host: 127.0.0.1'), findsOneWidget);
      expect(find.text('Port: 7890'), findsOneWidget);

      await channel.invokeMethod(
        'disableProxy',
      );
    },
  );
}
