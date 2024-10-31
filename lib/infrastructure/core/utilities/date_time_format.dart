String? toUtcIso8601String(DateTime? data) {
  return data?.toUtcIso8601String();
}

DateTime? dateTimeOrNull(dynamic data) {
  if (data is String) return DateTime.tryParse(data);
  return null;
}

extension DateTimeX on DateTime {
  String toUtcIso8601String() => toUtc().toIso8601String();
}
