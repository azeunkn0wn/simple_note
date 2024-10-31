import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_note/environmental_variables.dart';
import 'package:simple_note/injection.dart';
import 'package:simple_note/presentation/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'env/.env.mock');

  await configureInjection(Env.current);

  runApp(AppWidget());
}
