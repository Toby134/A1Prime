  import 'package:a1primeinventory/backend/erpGetBranchSpinner.dart';
import 'package:a1primeinventory/backend/erpGetItem.dart';

import 'package:a1primeinventory/main_page/design.dart';
import 'package:a1primeinventory/main_page/item_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemlistPage extends StatefulWidget {
  @override
  _ItemlistPageState createState() => _ItemlistPageState();
}

class _ItemlistPageState extends State<ItemlistPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  String? selectedBranch;
  String? selectedBranchCode;
  int _currentPage = 0;
  static const int _itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    fetchItems().then((items) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
      });
    }).catchError((error) {
      print("Error fetching items: $error");
    });
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          return item.itemDesc.toLowerCase().contains(query.toLowerCase()) ||
              item.itemNo.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  double getTotalUnitsAll() {
    return _allItems.fold(0.0, (sum, item) => sum + (item.qty));
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 1000;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by item name or number...',
                    border: InputBorder.none,
                    hintStyle:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  ),
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  onChanged: _filterItems,
                )
              : Text(
                  'Inventory List',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filterItems('');
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.qr_code,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                // Scanner functionality
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: isSmallScreen ? 5.0 : 5.0, // Custom top padding
            left: isSmallScreen ? 20.0 : 50.0,
            right: isSmallScreen ? 20.0 : 50.0,
            bottom: isSmallScreen ? 20.0 : 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Map<String, String>>>(
                future: fetchBranchNames(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedBranch,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100, // Soft grey background
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      items: snapshot.data!.map((branch) {
                        return DropdownMenuItem<String>(
                          value: branch['BranchName'],
                          child: Text(branch['BranchName'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBranch = value;
                          selectedBranchCode = snapshot.data!.firstWhere(
                              (branch) =>
                                  branch['BranchName'] == value)['BranchCode'];
                        });
                      },
                      hint: Text("Select Branch",
                          style: GoogleFonts.poppins(fontSize: 14)),
                      dropdownColor: Colors.white,
                    ),
                  );
                },
              ),

              // Summary Section
//               Text(
//                 'Summary',
//                 style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               SizedBox(height: 10),
//               // Helper function to sum the total units from _allItems

// // Summary container in your widget tree:
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.red[900],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Total Items",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "${_allItems.length}",
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 20),
//                     Container(
//                       height: 40,
//                       width: 2,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Total Units",
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "${getTotalUnitsAll()}",
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

              SizedBox(height: 16),

              
                  Text(
                    'Items',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                
              Divider(),
              Expanded(
                child: _filteredItems.isEmpty
                    ? Center(child: Text('No items available'))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: (_filteredItems.length -
                                          (_currentPage * _itemsPerPage)) >
                                      _itemsPerPage
                                  ? _itemsPerPage
                                  : (_filteredItems.length -
                                      (_currentPage *
                                          _itemsPerPage)), // Show max 5 items
                              itemBuilder: (context, index) {
                                int actualIndex =
                                    _currentPage * _itemsPerPage + index;
                                if (actualIndex >= _filteredItems.length)
                                  return SizedBox(); // Prevent out-of-bounds error

                                Item item = _filteredItems[actualIndex];
                                return ListTile(
                                  title: Text(
                                    item.itemDesc,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  subtitle: Text(
                                    'Item No: ${item.itemNo}\nPrice: ${item.itemPrice} | Qty: ${item.qty}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  onTap: () {
                                    if (selectedBranch == null ||
                                        selectedBranchCode == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please select a branch first'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemDetailsPage(
                                          item: item,
                                          selectedBranch: selectedBranch!,
                                          selectedBranchCode:
                                              selectedBranchCode!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _currentPage > 0
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.chevron_left, size: 24),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Page ${_currentPage + 1}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    ((_currentPage + 1) * _itemsPerPage) <
                                            _filteredItems.length
                                        ? () {
                                            setState(() {
                                              _currentPage++;
                                            });
                                          }
                                        : null,
                                icon: Icon(Icons.chevron_right, size: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
