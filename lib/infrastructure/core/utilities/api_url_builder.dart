import 'package:simple_note/environmental_variables.dart';

abstract class EndpointBuilder {
  String get endpoint;

  Uri apiUrl([
    String? id,
    Map<String, dynamic>? queryParameters,
  ]) {
    final url =
        Uri.https(Env.baseURL, "${Env.prefix}$endpoint", queryParameters);

    if (id == null) return url;
    return url.replace(path: "${url.path}/$id");
  }
}
