import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../Utils/custom_widget.dart';
import '../Utils/storage.dart';

class ApiProvider {
  // final String lang = LocalizeAndTranslate.getLanguageCode() ?? 'fr';
  Future<dynamic> postRequest(
      {required apiUrl, data = const <String, String>{}, token}) async {
    var response = await http.post(Uri.parse('$apiUrl'), body: data, headers: {
      'Content-Type': 'application/json',
      // 'Accept-Language': lang,
      'Authorization': 'Bearer $token',
    });
    log("statusCode + apiUrl ${response.statusCode}  $apiUrl");
    log("Response ${jsonDecode(response.body)}");
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res;
    } else if (response.statusCode == 201) {
      return res;
    } else if (response.statusCode == 202) {
      return res;
    } else if (response.statusCode == 400) {
      return res;
    } else if (response.statusCode == 401) {
      handleSessionExpire();
      return res;
    } else if (response.statusCode == 403) {
      return res;
    } else if (response.statusCode == 404) {
      return res;
    } else if (response.statusCode == 422) {
      return res;
    } else if (response.statusCode == 429) {
      return res;
    } else if (response.statusCode == 500) {
      return res;
    } else if (response.statusCode == 502) {
      return res;
    } else if (response.statusCode == 503) {
      return res;
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> deleteRequest(
      {required apiUrl, data = const <String, String>{}, token}) async {
    var response = await http.delete(Uri.parse('$apiUrl'), body: data, headers: {
      // 'Content-Type': 'application/json',
      // 'Accept-Language': lang,
      'Authorization': 'Bearer $token',
    });
    log("statusCode + apiUrl ${response.statusCode}  $apiUrl");
    log("Response ${jsonDecode(response.body)}");
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res;
    } else if (response.statusCode == 201) {
      return res;
    } else if (response.statusCode == 202) {
      return res;
    } else if (response.statusCode == 400) {
      return res;
    } else if (response.statusCode == 401) {
      handleSessionExpire();
      return res;
    } else if (response.statusCode == 403) {
      return res;
    } else if (response.statusCode == 404) {
      return res;
    } else if (response.statusCode == 422) {
      return res;
    } else if (response.statusCode == 429) {
      return res;
    } else if (response.statusCode == 500) {
      return res;
    } else if (response.statusCode == 502) {
      return res;
    } else if (response.statusCode == 503) {
      return res;
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> postRequest1(
      {
        required apiUrl, data = const <String, String>{},
        token
      })
  async
  {
    var response = await http.post(Uri.parse('$apiUrl'), body: data,
        headers: {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });

    
    var res = jsonDecode(response.body);
    log("data $data");
    log("statusCode + apiUrl ${response.statusCode}  $apiUrl  $res" );
    if (response.statusCode == 200) {
      return res;
    } else if (response.statusCode == 201) {
      return res;
    } else if (response.statusCode == 202) {
      return res;
    } else if (response.statusCode == 400) {
      return res;
    } else if (response.statusCode == 401) {
      // handleSessionExpire();
      return res;
    } else if (response.statusCode == 403) {
      return res;
    } else if (response.statusCode == 404) {
      return res;
    } else if (response.statusCode == 422) {
      return res;
    } else if (response.statusCode == 429) {
      return res;
    } else if (response.statusCode == 500) {
      return res;
    } else if (response.statusCode == 502) {
      return res;
    } else if (response.statusCode == 503) {
      return res;
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> putRequest(
      {required apiUrl, body = const <String, String>{}, token}) async {
    var response = await http.put(Uri.parse('$apiUrl'), body: body, headers: {
      'Content-Type': 'application/json',
      // 'Accept-Language': lang,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });

    log("data ${jsonEncode(body)}");
    log("statusCode + apiUrl ${response.statusCode}  $apiUrl");
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return res;
    } else if (response.statusCode == 201) {
      return res;
    } else if (response.statusCode == 202) {
      return res;
    } else if (response.statusCode == 400) {
      return res;
    } else if (response.statusCode == 401) {
      handleSessionExpire();
      return res;
    } else if (response.statusCode == 403) {
      return res;
    } else if (response.statusCode == 404) {
      return res;
    } else if (response.statusCode == 422) {
      return res;
    } else if (response.statusCode == 429) {
      return res;
    } else if (response.statusCode == 500) {
      return res;
    } else if (response.statusCode == 502) {
      return res;
    } else if (response.statusCode == 503) {
      return res;
    } else {
      return Future.error('Network Problem');
    }
  }

  Future<dynamic> getRequest({required apiUrl, token}) async {
    var response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      // 'Accept-Language': lang,
      'Authorization': 'Bearer $token',
    });
    log("statusCode + apiUrl ${getToken()}  $apiUrl");

    var res = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return res;
    } else if (response.statusCode == 401) {
      handleSessionExpire();
      return res;
    } else if (response.statusCode == 400) {
      return res;
    } else if (response.statusCode == 404) {
      return res;
    } else if (response.statusCode == 422) {
      return res;
    } else if (response.statusCode == 500) {
      return res;
    } else if (response.statusCode == 502) {
      return res;
    } else if (response.statusCode == 503) {
      return res;
    } else {
      return Future.error('Network Problem');
    }
  }
  Future<dynamic> getRequestWithBody({
    required String apiUrl,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      var request = http.Request('GET', Uri.parse(apiUrl));

      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.body = jsonEncode(body);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("GET WITH BODY => $apiUrl");
      log("BODY => ${jsonEncode(body)}");

      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return res;
      } else if (response.statusCode == 401) {
        handleSessionExpire();
        return res;
      } else if (response.statusCode == 400) {
        return res;
      } else if (response.statusCode == 404) {
        return res;
      } else if (response.statusCode == 422) {
        return res;
      } else if (response.statusCode == 500) {
        return res;
      } else if (response.statusCode == 502) {
        return res;
      } else if (response.statusCode == 503) {
        return res;
      } else {
        return Future.error('Network Problem');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
  Future<dynamic> PostRequestProfile({
    required String apiUrl,
    required Map<String, dynamic> fields,
    required Rx<File?> userImage,
    required String imageKey,
    required String token,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(apiUrl),
      );

      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (userImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            imageKey,
            userImage.value!.path,
          ),
        );
      }

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      print("FIELDS => ${request.fields}");

      for (var file in request.files) {
        print("FILE => ${file.field}");
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      print("STATUS => ${response.statusCode}");
      print("BODY => $body");

      return jsonDecode(body);
    } catch (e) {
      print("ERROR => $e");
    }
  }
  Future<dynamic> putRequestProfile(
      {required apiUrl,
      required Map<String, dynamic> fields,
      imageKey,
      required Rx<File?> userImage}) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      if (userImage.value != null) {
        final extension =
            path.extension(userImage.value!.path).replaceFirst('.', '');

        request.files.add(
          await http.MultipartFile.fromPath(
            imageKey,
            userImage.value!.path,
            contentType: MediaType('image', extension),
          ),
        );
      }
      request.headers.addAll({
        "Accept": "application/json",
        // 'Accept-Language': lang,
        "Authorization": 'Bearer ${getToken()}',
      });

      print(request.files);
      //  print( userImage.value!.path);
      print(request.fields);

      var response = await request.send();
      var res = await response.stream.toBytes();
      var alldata = String.fromCharCodes(res);
      var res2 = jsonDecode(alldata);
      log("Pawan $res2");

      if (response.statusCode == 200) {
        return res2;
      } else if (response.statusCode == 201) {
        return res2;
      } else if (response.statusCode == 202) {
        return res2;
      } else if (response.statusCode == 400) {
        return res2;
      } else if (response.statusCode == 401) {
        handleSessionExpire();
        return res2;
      } else if (response.statusCode == 403) {
        return res2;
      } else if (response.statusCode == 404) {
        return res2;
      } else if (response.statusCode == 422) {
        return res2;
      } else if (response.statusCode == 429) {
        return res2;
      } else if (response.statusCode == 500) {
        return res2;
      } else if (response.statusCode == 502) {
        return res2;
      } else if (response.statusCode == 503) {
        return res2;
      } else {
        return Future.error('Network Problem');
      }
    } catch (e) {
      log("catch ${e.toString()}");
    }
  }
  Future<dynamic> putRequestProfileWithDocuments({
    required String apiUrl,
    required Map<String, dynamic> fields,

    required Map<String, File?> documents,

  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(apiUrl),
      );

      /// Text fields
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      /// Documents
      for (final entry in documents.entries) {
        if (entry.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              entry.value!.path,
            ),
          );
        }
      }

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${getToken()}",
      });

      var response = await request.send();
      var res = await response.stream.bytesToString();
      final res2= jsonDecode(res);
      if (response.statusCode == 200) {
        return res2;
      } else if (response.statusCode == 201) {
        return res2;
      } else if (response.statusCode == 202) {
        return res2;
      } else if (response.statusCode == 400) {
        return res2;
      } else if (response.statusCode == 401) {
        handleSessionExpire();
        return res2;
      } else if (response.statusCode == 403) {
        return res2;
      } else if (response.statusCode == 404) {
        return res2;
      } else if (response.statusCode == 422) {
        return res2;
      } else if (response.statusCode == 429) {
        return res2;
      } else if (response.statusCode == 500) {
        return res2;
      } else if (response.statusCode == 502) {
        return res2;
      } else if (response.statusCode == 503) {
        return res2;
      } else {
        return Future.error('Network Problem');
      }

    } catch (e) {
      log("catch ${e.toString()}");
    }
  }
  Future<dynamic> putRequestProfileWithDocuments2({
    required String apiUrl,
    required Map<String, dynamic> fields,
    required Map<String, File?> documents,
    Map<String, List<File>>? multipleDocuments,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(apiUrl),
      );

      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      /// Single Files
      for (final entry in documents.entries) {
        if (entry.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              entry.value!.path,
            ),
          );
        }
      }

      /// Multiple Files
      if (multipleDocuments != null) {
        for (final entry in multipleDocuments.entries) {
          for (final file in entry.value) {
            request.files.add(
              await http.MultipartFile.fromPath(
                "${entry.key}[]",
                file.path,
              ),
            );
          }
        }
      }

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${getToken()}",
      });

      var response = await request.send();
      var res = await response.stream.bytesToString();

      return jsonDecode(res);
    } catch (e) {
      log(e.toString());
    }
  }
  void handleSessionExpire() {
    userBox.clear();
    CustomWidget().showCustomToast(
      message: "Session expired, please login again.",
    );
  }

  void showErrorFromResponse(Map<String, dynamic> response) {
    String errorMessage = 'An error occurred';

    if (response.containsKey('errors') &&
        response['errors'] is List &&
        response['errors'].isNotEmpty) {
      errorMessage = response['errors'][0]['msg'] ?? errorMessage;
    } else if (response.containsKey('errors') &&
        response['errors'] is Map &&
        (response['errors']['files'] is List &&
            response['errors']['files'].isNotEmpty)) {
      errorMessage = response['errors']['files'][0];
    } else if (response.containsKey('message')) {
      if ((response['message'].toString().contains("ClientException") ||
          response['message'].toString().contains("SocketException"))) {
        errorMessage =
            "Connection error! Please check your internet or server.";
      } else {
        errorMessage = response['message'];
      }
    } else if (response.containsKey('error')) {
      errorMessage = response['error'];
    }

    CustomWidget().showCustomToast(message: errorMessage);
  }

  void handleApiError(Object e) {
    if (e is SocketException) {
      if (e.message.contains("No route to host")) {
        CustomWidget().showCustomToast(
          message: "Server is not reachable. Please check backend server.",
        );
      } else {
        CustomWidget().showCustomToast(
          message: "No internet connection. Please check your network.",
        );
      }
    } else if (e is http.ClientException) {
      if (e.message.contains("No route to host")) {
        CustomWidget().showCustomToast(
          message: "Server is not reachable. Please check backend connection.",
        );
      } else {
        CustomWidget().showCustomToast(
          message: "Network error occurred. Please try again.",
        );
      }
    } else if (e is TimeoutException) {
      CustomWidget().showCustomToast(
        message: "Request timed out. Please try again.",
      );
    } else if (e is FormatException) {
      CustomWidget().showCustomToast(
        message: "Invalid server response. Please check server status.",
      );
    } else if (e is HttpException) {
      CustomWidget().showCustomToast(
        message: "Server error occurred. Please try again later.",
      );
    } else {
      CustomWidget().showCustomToast(
        message: "Something went wrong. Please try again.",
      );
    }
  }
}
