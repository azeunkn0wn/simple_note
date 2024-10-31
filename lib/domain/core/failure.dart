import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const Failure._();
  const factory Failure.api(String? errorMessage, [int? statusCode]) = _Api;
  const factory Failure.unexpected(String? errorMessage) = _Unexpected;
  const factory Failure.connectivity(String? errorMessage) = _Connectivity;
  const factory Failure.client(String? errorMessage) = _Client;
  // const factory Failure.storage(String? errorMessage) = _Storage;
  // const factory Failure.auth(String? errorMessage) = _Auth;
  // const factory Failure.permission(String? errorMessage) = _Permission;
  // const factory Failure.inAppPurchase(String? errorMessage) = _InAppPurchase;
}
