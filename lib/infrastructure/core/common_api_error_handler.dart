import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:simple_note/domain/core/failure.dart';
import 'package:simple_note/infrastructure/core/network_exception.dart';

Failure commonErrorHandler(Object error) {
  try {
    throw error;
  } on RestApiException catch (e) {
    return Failure.api(e.message.toString(), e.statusCode);
  } on ClientException catch (e) {
    if (e.message.contains("ERR_INTERNET_DISCONNECTED")) {
      return Failure.connectivity('No Internet Connection');
    }
    return Failure.client(e.message);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return Failure.unexpected(e.toString());
  }
}
