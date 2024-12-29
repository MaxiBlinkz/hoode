// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

DateTime pocketBaseDateTimeFromJson(String json) => DateTime.parse(json);
String pocketBaseDateTimeToJson(DateTime dateTime) =>
    dateTime.toIso8601String();
DateTime? pocketBaseNullableDateTimeFromJson(String json) =>
    DateTime.tryParse(json);
String pocketBaseNullableDateTimeToJson(DateTime? dateTime) =>
    dateTime?.toIso8601String() ?? '';
