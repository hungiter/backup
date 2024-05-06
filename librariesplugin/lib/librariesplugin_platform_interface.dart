import 'dart:ffi';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'librariesplugin_method_channel.dart';

abstract class LibrariespluginPlatform extends PlatformInterface {
  /// Constructs a LibrariespluginPlatform.
  LibrariespluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LibrariespluginPlatform _instance = MethodChannelLibrariesplugin();

  /// The default instance of [LibrariespluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelLibrariesplugin].
  static LibrariespluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LibrariespluginPlatform] when
  /// they register themselves.
  static set instance(LibrariespluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPingResult(String address, int ttl) {
    throw UnimplementedError('pingResult() has not been implemented.');
  }

  Future<String?> getPageLoadResult(String address) {
    throw UnimplementedError('pageLoadResult() has not been implemented.');
  }

  Future<String?> getDnsLookupResult(String address) {
    throw UnimplementedError('dnsLookupResult() has not been implemented.');
  }

  Future<String?> getPortScanResult(int port, String address) {
    throw UnimplementedError('portScanResult() has not been implemented.');
  }
}
