import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pulldata/model/model.dart';

class FetchData {
  var url =
      Uri.parse('https://api.instantwebtools.net/v1/passenger?page=0&size=10');

  Future<PaginationResponse> fetchData() async {
    final response = await http.get(url);

    Map<String, dynamic> res = jsonDecode(response.body);

    PaginationResponse data = PaginationResponse.fromJson(res);

    return data;
    // List<Model> data = [];

    // for (var i = 0; i < res.length; i++) {
    //   print(res[i]['totalPassengers']);
    // }
  }

  Future<PaginationResponse> postdata(int page, int size) async {
    final response = await http.post(Uri.parse(
        'https://api.instantwebtools.net/v1/passenger?page=$page&size=$size'));

    Map<String, dynamic> res = jsonDecode(response.body);

    PaginationResponse data = PaginationResponse.fromJson(res);
    return data;
  }
}
