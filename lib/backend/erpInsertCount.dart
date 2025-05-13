import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addInventoryCount(
    String itemNo, String braNo, double count, String user) async {

  final String url = 'http://192.168.86.31/A1PrimeInventory/erpInsertCount.php';

  try {
    // Send the POST request to the PHP backend
    final response = await http.post(
      Uri.parse(url),
      body: {
        'item_no': itemNo,
        'bra_no': braNo,
        'count': count.toString(), // Ensure count is converted to string
        'user': user,
      },
    );

    if (response.statusCode == 200) {
      // Successful response from the backend
      final data = json.decode(response.body);
      if (data['message'] == 'Insert successful') {
        // Handle successful insert
        print('Insert successful!');
      } else {
        // Handle error from backend
        print('Error: ${data['error']}');
      }
    } else {
      // Handle any network-related error
      print('Failed to connect to the backend');
    }
  } catch (e) {
    // Handle any exception that occurs during the request
    print('Error: $e');
  }
}