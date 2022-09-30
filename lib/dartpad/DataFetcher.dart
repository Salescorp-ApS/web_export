import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'DataFetcher.g.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class DataItem {
  DateTime startTime;
  double value;
  DataItem(
      {required this.startTime, required this.value});
}

List<DataItem> parseRows(String responseBody, int dk1) {
  final rows = jsonDecode(responseBody)['data']['Rows'];
  rows.removeWhere((x) => !x['Name'].contains('nbsp'));
  rows.removeWhere((x) => x['Columns'][0]['Value'].replaceAll(' ','').replaceAll(',', '.') == '-');
  final res = rows.map<DataItem>((x) => DataItem(startTime: DateTime.parse(x['StartTime']), value: double.parse(x['Columns'][dk1]['Value'].replaceAll(' ','').replaceAll(',', '.'))));
  return res.toList();
}

// Alternative API service

Future<List<DataItem>> fetchDataAlt(int region) async{
  var formatter = DateFormat('yyyy-MM-dd');
  String now = formatter.format(DateTime.now().add(const Duration(days: 2)));
  String date = formatter.format(DateTime.now().subtract(const Duration(days: 5)));
  String url = 'https://api.energidataservice.dk/dataset/Elspotprices?offset=0&start=${date}T00:00&end=${now}T00:00&filter=%7B%22PriceArea%22:%22DK${region}%22%7D&sort=HourDK%20ASC&timezone=dk';
  final response = await http
      .get(Uri.parse(url), headers: {'Accept': 'text/json'});
  return parseRowsAlt(response.body, region);
}

List<DataItem> parseRowsAlt(String responseBody, int region) {
  final rows = jsonDecode(responseBody)['records'];
  final res = rows.map<DataItem>((x) => DataItem(startTime: DateTime.parse(x['HourDK']), value: x['SpotPriceDKK']));
  return res.toList();
}