import 'dart:convert';
import 'package:http/http.dart' as http;
 
class GooglePlacesService {
  final String apiKey;
 
  GooglePlacesService(this.apiKey);
 
  Future<List<dynamic>> searchPlaces(String input) async {
    final response = await http.post(
      Uri.parse("https://places.googleapis.com/v1/places:autocomplete"),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
      },
      body: jsonEncode({
        "input": input,
      }),
    );
 
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json["suggestions"] ?? [];
    }
 
    return [];
  }
 
  Future<Map<String, dynamic>> getPlaceDetail(String placeId) async {
    final response = await http.get(
      Uri.parse("https://places.googleapis.com/v1/places/$placeId"),
      headers: {
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask":
            "displayName,formattedAddress,location",
      },
    );
 
    return jsonDecode(response.body);
  }
}