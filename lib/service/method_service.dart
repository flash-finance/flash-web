import 'package:dio/dio.dart';

Future requestGet(String url, {token}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType = 'application/json;charset=UTF-8';
    if(token != null) {
      dio.options.headers['authorization'] = 'Bearer ' + token;
    }
    response = await dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('service error');
    }
  } catch (e) {
    return print('error: ${e.toString()}');
  }
}

Future requestPost(String url, {formData, token}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType = 'application/json;charset=UTF-8';
    if(token != null) {
      dio.options.headers['authorization'] = 'Bearer ' + token;
    }
    if (formData == null) {
      response = await dio.post(url);
    } else {
      response = await dio.post(url, data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('service error');
    }
  } catch (e) {
    return print('error: ${e.toString()}');
  }
}