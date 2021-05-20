import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lbwBDFace/lbwBDFace.dart';

void main() {
  const MethodChannel channel = MethodChannel('lbwBDFace');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LbwBDFace.platformVersion, '42');
  });
}
