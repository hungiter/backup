import 'package:flutter_test/flutter_test.dart';
import 'package:librariesplugin/librariesplugin.dart';
import 'package:librariesplugin/librariesplugin_platform_interface.dart';
import 'package:librariesplugin/librariesplugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLibrariespluginPlatform
    with MockPlatformInterfaceMixin
    implements LibrariespluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LibrariespluginPlatform initialPlatform = LibrariespluginPlatform.instance;

  test('$MethodChannelLibrariesplugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLibrariesplugin>());
  });

  test('getPlatformVersion', () async {
    LibrariesPlugin librariesPlugin = LibrariesPlugin();
    MockLibrariespluginPlatform fakePlatform = MockLibrariespluginPlatform();
    LibrariespluginPlatform.instance = fakePlatform;

    expect(await librariesPlugin.getPlatformVersion(), '42');
  });
}
