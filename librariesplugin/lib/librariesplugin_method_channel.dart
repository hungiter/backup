import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'librariesplugin_platform_interface.dart';

/// An implementation of [LibrariespluginPlatform] that uses method channels.
class MethodChannelLibrariesplugin extends LibrariespluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('librariesplugin');

  @override
  Future<String?> getPingResult(String address, int ttl) async {
    var dataToPass = <String, dynamic>{'address': address, 'ttl': ttl};
    final pingResult =
        await methodChannel.invokeMethod<String>('getPingResult', dataToPass);
    return pingResult;
  }

  @override
  @override
  Future<String?> getPageLoadResult(String address) async {
    return await methodChannel
        .invokeMethod<String>('getPageLoadResult', {'address': address});
  }

  @override
  Future<String?> getDnsLookupResult(String address) async {
    var dataToPass = <String, dynamic>{'address': address};
    final pageLoadResult = await methodChannel.invokeMethod<String>(
        'getDnsLookupResult', dataToPass);
    return pageLoadResult;
  }

  @override
  Future<String?> getPortScanResult(int port, String address) async {
    var dataToPass = <String, dynamic>{
      'address': address,
      'port': port,
    };
    final getPortScanResult = await methodChannel.invokeMethod<String>(
        'getPortScanResult', dataToPass);
    return getPortScanResult;
  }
}
