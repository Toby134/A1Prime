import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, String>>> fetchBranchNames() async {
  // Retrieve the saved IP from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final serverIp = prefs.getString('server_ip');

  // Check if the server IP is null or empty
  if (serverIp == null || serverIp.isEmpty) {
    throw Exception("Server IP not set. Please set the IP address first.");
  }

  // Construct the URL with the dynamic IP
  final url = 'http://$serverIp/A1Prime/get_branches.php';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Parse the response body
    List<dynamic> data = jsonDecode(response.body);
    List<Map<String, String>> branches = [];

    // Loop through the response and extract branch name and branch code
    for (var item in data) {
      branches.add({
        'BranchName': item['BranchName'],  // Branch name
        'BranchCode': item['BranchID'],    // Branch code
      });
    }

    return branches;
  } else {
    throw Exception('Failed to load branches');
  }
}
