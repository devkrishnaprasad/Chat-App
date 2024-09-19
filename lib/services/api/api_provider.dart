import 'dart:developer';
import 'package:dio/dio.dart';

class ApiProvider {
  var dio = Dio();

// GET Api request without token
  getRequest(apiEndpoint) async {
    log('Api endpoint $apiEndpoint');

    var response = await dio.request(
      apiEndpoint,
      options: Options(
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      log(response.statusMessage.toString());
      return response.data;
    }
  }
}
