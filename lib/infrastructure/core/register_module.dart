import 'dart:async';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_client/http_client_factory.dart'
    if (dart.library.js_interop) 'http_client_factory_web.dart' as http_factory;

@module
abstract class RegisterModule {
  @LazySingleton(dispose: disposeDataSource)
  Client get client => http_factory.httpClient();
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

FutureOr disposeDataSource(Client client) {
  client.close();
}
