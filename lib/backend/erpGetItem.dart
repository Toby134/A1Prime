import 'dart:convert';
import 'package:http/http.dart' as http;

// Existing function to fetch all items from the inventory table
Future<List<Item>> fetchItems() async {

  final response = await http.get(Uri.parse('http://192.168.86.31/A1PrimeInventory/erpGetItem.php'));

   print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}'); 

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData["status"] == "success" && responseData["data"] is List) {
      List<dynamic> itemList = responseData["data"];
      return itemList.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception("No items found or invalid response format");
    }
  } else {
    throw Exception("Failed to load items");
  }
}

// fetches the count for recently inserted by the app user
Future<int> fetchCount(String itemNo, String branchNo) async {
  var url = Uri.parse('http://192.168.86.31/A1PrimeInventory/erpGetItem.php');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    if (data['status'] == 'success' && data['data'] is List) {
      for (var item in data['data']) {
        if (item['Item_No'].toString() == itemNo) {
          var counts = item['Inventory_Counts'];
          if (counts != null && counts is Map<String, dynamic>) {
            if (counts.containsKey(branchNo)) {
              return int.tryParse(counts[branchNo].toString()) ?? 0;
            }
          }
        }
      }
    }
    return 0; // default if not found
  } else {
    throw Exception('Failed to fetch count');
  }
}

//fetches the count for each inventory, cannot be changed by the app user, only in ERP
Future<int> fetchInventoryBranchCount(String itemNo, String branchNo) async {
  final response = await http.get(
    Uri.parse('http://192.168.86.31/A1PrimeInventory/fetch_inventory_branch.php')
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData["status"] == "success" && responseData["data"] is Map) {
      // Find the specific item and branch count
      if (responseData["data"][itemNo] is Map) {
        final branchData = responseData["data"][itemNo] as Map;
        if (branchData.containsKey(branchNo)) {
          return int.tryParse(branchData[branchNo].toString()) ?? 0;
        }
      }
      return 0; // Return 0 if not found
    } else {
      throw Exception("No branch inventory data found or invalid format");
    }
  } else {
    throw Exception("Failed to load branch inventory data: ${response.statusCode}");
  }
}

class Item {
  final String itemNo;
  final String itemDesc;
  final double itemPrice;
  final double qty;
  final String barcode;
 
  final DateTime? lastOrderDate;
  final DateTime? dateCreated;
  final DateTime? dateModified;

  Item({
    required this.itemNo,
    required this.itemDesc,
    required this.itemPrice,
    required this.qty,
    required this.barcode,
   
    this.lastOrderDate,
    this.dateCreated,
    this.dateModified,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null || value.toString().isEmpty) return null;
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        return DateTime.tryParse(value.toString());
      }
    }

    return Item(
      itemNo: json['Item_No'] ?? '',
      itemDesc: json['Item_Desc'] ?? '',
      itemPrice: json['Item_Price'] != null ? double.tryParse(json['Item_Price'].toString()) ?? 0.0 : 0.0,
      qty: json['Qty'] != null ? double.tryParse(json['Qty'].toString()) ?? 0.0 : 0.0,
      barcode: json['Barcode'] ?? '',
      
      lastOrderDate: parseDate(json['Last_Order_Date']),
      dateCreated: parseDate(json['DateCreated']),
      dateModified: parseDate(json['DateModified']),
    );
  }
}