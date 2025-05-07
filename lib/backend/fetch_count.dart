// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<int> fetchBranchCount(String itemNo, String branchNo) async {
//   // Retrieve the saved IP from SharedPreferences
//   final prefs = await SharedPreferences.getInstance();
//   final serverIp = prefs.getString('server_ip');

//   // Check if the server IP is null or empty
//   if (serverIp == null || serverIp.isEmpty) {
//     throw Exception("Server IP not set. Please set the IP address first.");
//   }

//   // Construct the URL with the dynamic IP and parameters
//   var url = Uri.parse('http://$serverIp/A1Prime/fetch_count.php?Item_No=$itemNo&Bra_No=$branchNo');

//   // Make the GET request with the parameters
//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     // Parse the response body
//     var data = jsonDecode(response.body);

//     // Check if inventory counts exist and match the item and branch
//     for (var item in data['inventory_counts']) {
//       if (item['Item_No'] == itemNo && item['Bra_No'] == branchNo) {
//         return item['Count']; // Return the count
//       }
//     }

//     // If no matching item found, return 0
//     return 0;
//   } else {
//     throw Exception('Failed to fetch count');
//   }
// }
