// ignore_for_file: avoid_print

import 'package:alakhbar/Utils/translation_key.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../widgets/custom_text_widget.dart';

class ApiService extends GetxService {
  static final ApiService _apiUtil = ApiService._();
  ApiService._() {
    init();
  }
  factory ApiService() {
    return _apiUtil;
  }

  Dio dio = Dio();

  void init() {
    dio.options.baseUrl = "http://sprinkles-qa.com/api/";
    dio.options.connectTimeout = const Duration(milliseconds: 600000) ;
    dio.options.receiveTimeout =  const Duration(milliseconds: 600000) ;
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      compact: true,
    ));
  }

  Future<dynamic> request<T>(
    String endPoint,
    String method, {
    dynamic data,
        Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParamters,
    String contentType = "application/json",
    Function(String errorMsg)? errorDialog,
    Function(String? successMsg)? onSuccess,
    Function(String errorMsg)? errorMessage,
  }) async {

    try {
      Response response = await dio.request<T>(endPoint,
          data: data ?? {},
          queryParameters: queryParamters,
          options: Options(
            method: method,
            contentType: contentType,
             headers: headers,
          ));
      if (response.statusCode != 200) {
        throw "${response.statusMessage}\n${response.statusCode}";
      }
      //Parse response

      if (response.statusCode != 200 || response.data == null) {
        throw "${response.statusMessage}";
      }
      if (onSuccess != null) {
        print('ApiService.request msg= ${response.statusMessage}');
        onSuccess(response.statusMessage);
      }
      return response.data;
    } catch (e) {
      print("Error: $e");
      if (errorDialog == null && errorMessage == null) {
        await Get.defaultDialog(
          title: error.tr,
          content: CustomText(error.tr),
          middleText: "",
        );
      }
      if (errorDialog != null) {
        await errorDialog(e.toString());
      }
      if (errorMessage != null) {
        errorMessage(e.toString());
      }
      return null;
    }
  }
}
