import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';

import 'Code.dart';
import 'ResultData.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/response_interceptor.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = new Dio(); //
  //http2.0
  // ..httpClientAdapter = Http2Adapter(
  //   ConnectionManager(
  //     idleTimeout: 10000,

  //     /// Ignore bad certificate
  //     onClientCreate: (_, clientSetting) =>
  //         clientSetting.onBadCertificate = (_) => true,
  //   ),
  // ); // 使用默认配置

  // final TokenInterceptors _tokenInterceptors = new TokenInterceptors();

  HttpManager() {
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    _dio.interceptors.add(new HeaderInterceptors());

    // _dio.interceptors.add(_tokenInterceptors);

    _dio.interceptors.add(new LogsInterceptors());

    _dio.interceptors.add(new ErrorInterceptors(_dio));

    _dio.interceptors.add(new ResponseInterceptors());
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  fetch(url, {dynamic params, Options option, noTip = false}) async {
    // Map<String, dynamic> headers = new HashMap();
    // if (header != null) {
    //   headers.addAll(header);
    // }

    if (option != null) {
      // option.headers = headers;
    } else {
      option = new Options(method: "get");
      // option.headers = headers;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      return new ResultData(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }
}

final HttpManager httpManager = new HttpManager();
