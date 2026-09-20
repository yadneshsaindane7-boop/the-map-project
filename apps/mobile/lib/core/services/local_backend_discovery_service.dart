import 'package:multicast_dns/multicast_dns.dart';

import '../constants/app_constants.dart';

class LocalBackendDiscoveryService {
  static const String serviceName = '_maargsaarthi._tcp';

  static String? _cachedUrl;

  Future<String> getBackendUrl() async {
    if (_cachedUrl != null) {
      return _cachedUrl!;
    }

    final discoveredUrl = await _discover();

    if (discoveredUrl != null) {
      _cachedUrl = discoveredUrl;
      return discoveredUrl;
    }

    return AppConstants.routingBackendUrl;
  }

  Future<String?> _discover() async {
    final client = MDnsClient();

    try {
      await client.start();

      await for (final PtrResourceRecord ptr
          in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceName),
      )) {
        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName),
        )) {
          await for (final IPAddressResourceRecord address
              in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target),
          )) {
            return 'http://${address.address.address}:${srv.port}';
          }
        }
      }
    } finally {
      client.stop();
    }

    return null;
  }

  static void clearCache() {
    _cachedUrl = null;
  }
}