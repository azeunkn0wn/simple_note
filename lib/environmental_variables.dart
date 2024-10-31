import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get current {
    return dotenv.get('ENV', fallback: 'dev');
  }

  static bool get isProd => current == "prod";
  static bool get isDev => current == "dev";

  static String get baseURL => dotenv.get('BASE_URL');
  static String get prefix => dotenv.get('PREFIX');
}
