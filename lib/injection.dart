import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_note/injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection(String environment) =>
    getIt.init(environment: environment);
