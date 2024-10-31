// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:simple_note/application/notes/note/note_bloc.dart' as _i384;
import 'package:simple_note/application/notes/note_list/notes_list_bloc.dart'
    as _i735;
import 'package:simple_note/domain/notes/i_note_local_service.dart' as _i353;
import 'package:simple_note/domain/notes/i_note_remote_service.dart' as _i527;
import 'package:simple_note/domain/notes/i_note_repository.dart' as _i304;
import 'package:simple_note/infrastructure/core/register_module.dart' as _i854;
import 'package:simple_note/infrastructure/notes/note_local_service.dart'
    as _i503;
import 'package:simple_note/infrastructure/notes/note_mock_api_service.dart'
    as _i911;
import 'package:simple_note/infrastructure/notes/note_repository.dart' as _i506;

const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i519.Client>(
      () => registerModule.client,
      dispose: _i854.disposeDataSource,
    );
    gh.factory<_i527.INoteRemoteService>(
      () => _i911.NoteMockApiRemoteService(gh<_i519.Client>()),
      registerFor: {_dev},
    );
    gh.factory<_i353.INoteLocalService>(
      () => _i503.NoteLocalService(gh<_i460.SharedPreferences>()),
      registerFor: {_dev},
    );
    gh.factory<_i304.INoteRepository>(
      () => _i506.NoteRepository(
        gh<_i527.INoteRemoteService>(),
        gh<_i353.INoteLocalService>(),
      ),
      registerFor: {_dev},
    );
    gh.factory<_i735.NotesListBloc>(
        () => _i735.NotesListBloc(gh<_i304.INoteRepository>()));
    gh.factory<_i384.NoteBloc>(
        () => _i384.NoteBloc(gh<_i304.INoteRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i854.RegisterModule {}
