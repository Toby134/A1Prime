
import 'dart:convert';

import 'package:a1primeinventory/Login/signUp/login.dart';
import 'package:a1primeinventory/backend/erpGetBranchSpinner.dart';
import 'package:a1primeinventory/backend/erpGetItem.dart';
import 'package:a1primeinventory/main_page/item_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ItemlistPage extends StatefulWidget {
  const ItemlistPage({super.key});

  @override
  _ItemlistPageState createState() => _ItemlistPageState();
}

enum FilterType { priceRange, highToLow, lowToHigh, alphabetical, itemno }

FilterType _selectedFilterType = FilterType.itemno;

class _ItemlistPageState extends State<ItemlistPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  String? selectedBranch;
  String? selectedBranchCode;
  int _currentPage = 0;
  static const int _itemsPerPage = 5;
  String _searchMode = 'Text';

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
      } else if (_searchMode == 'Text') {
        _filteredItems = _allItems.where((item) {
          return item.itemDesc.toLowerCase().contains(query.toLowerCase()) ||
              item.itemNo.toLowerCase().contains(query.toLowerCase()) ||
              item.barcode.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else if (_searchMode == 'Price') {
        final price = double.tryParse(query);
        if (price != null) {
          _filteredItems = _allItems
              .where((item) => item.itemPrice.toString().contains(query))
              .toList();
        } else {
          _filteredItems = [];
        }
      }
    });
  }

  void _applyFilter() {
    final min = double.tryParse(_minPriceController.text) ?? 0;
    final max = double.tryParse(_maxPriceController.text) ?? double.infinity;

    setState(() {
      switch (_selectedFilterType) {
        case FilterType.priceRange:
          _filteredItems = _allItems.where((item) {
            return item.itemPrice >= min && item.itemPrice <= max;
          }).toList();
          break;
        case FilterType.highToLow:
          _filteredItems = [..._allItems]
            ..sort((a, b) => b.itemPrice.compareTo(a.itemPrice));
          break;
        case FilterType.lowToHigh:
          _filteredItems = [..._allItems]
            ..sort((a, b) => a.itemPrice.compareTo(b.itemPrice));
          break;
        case FilterType.alphabetical:
          _filteredItems = [..._allItems]..sort((a, b) =>
              a.itemDesc.toLowerCase().compareTo(b.itemDesc.toLowerCase()));
          break;
        case FilterType.itemno:
        _filteredItems = [..._allItems]
          ..sort((a, b) => a.itemNo.toLowerCase().compareTo(b.itemNo.toLowerCase()));
        break;
      }
      _currentPage = 0;
    });
  }

  double getTotalUnitsAll() {
    return _allItems.fold(0.0, (sum, item) => sum + (item.qty));
  }

  void _showFilterDialog(BuildContext context) {
    final minController = TextEditingController(text: _minPriceController.text);
    final maxController = TextEditingController(text: _maxPriceController.text);

    FilterType tempSelectedFilterType = _selectedFilterType;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter Items',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Filter Type Dropdown
                  DropdownButtonFormField<FilterType>(
                    value: tempSelectedFilterType,
                    decoration: InputDecoration(
                      labelText: 'Filter Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: FilterType.priceRange,
                        child: Text('Filter by Price Range'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.highToLow,
                        child: Text('Sort by Price: High to Low'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.lowToHigh,
                        child: Text('Sort by Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.alphabetical,
                        child: Text('Sort Alphabetically'),
                      ),
                      DropdownMenuItem(
                        value: FilterType.itemno,
                        child: Text('Sort by Item Number'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tempSelectedFilterType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Show price inputs only if Price Range selected
                  if (tempSelectedFilterType == FilterType.priceRange) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Min Price',
                              prefixIcon: Icon(Icons.php_rounded),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: maxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Max Price',
                              prefixIcon: Icon(Icons.php_rounded),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          minController.clear();
                          maxController.clear();
                          setState(() {
                            _minPriceController.clear();
                            _maxPriceController.clear();
                            _filteredItems = _allItems;
                            _selectedFilterType = FilterType.priceRange;
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Clear',
                            style: GoogleFonts.poppins(color: Colors.red)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          this.setState(() {
                            _selectedFilterType = tempSelectedFilterType;
                            _minPriceController.text = minController.text;
                            _maxPriceController.text = maxController.text;
                            _applyFilter();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Apply',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
            hintText: _searchMode == 'Price'
                ? 'Search by price...'
                : 'Search by item name, barcode, or number...',
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
    if (_isSearching)
      DropdownButton<String>(
        value: _searchMode,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        items: ['Text', 'Price'].map((mode) {
          return DropdownMenuItem<String>(
            value: mode,
            child: Text(mode, style: GoogleFonts.poppins(fontSize: 12)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _searchMode = value!;
            _searchController.clear();
            _filterItems('');
          });
        },
      ),
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
      icon: Icon(Icons.logout, color: Colors.black),
      tooltip: 'Logout',
      onPressed: () {
        // Call your logout logic here
        logout(); // Define this method to handle logout
      },
    ),
  ],
  elevation: 0,
  backgroundColor: Colors.white,
),

        body: Padding(
          padding: EdgeInsets.only(
            top: isSmallScreen ? 5.0 : 5.0,
            left: isSmallScreen ? 20.0 : 50.0,
            right: isSmallScreen ? 20 : 50.0,
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
                        fillColor: Colors.grey.shade100,
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

              SizedBox(height: 8),

              // PRICE RANGE INPUT

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Add horizontal padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top:
                              2.0), // Small vertical nudge for perfect alignment
                      child: Text(
                        'Items',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      height: 28, // Perfect height to match text size
                      child: ElevatedButton.icon(
                        onPressed: () => _showFilterDialog(context),
                        icon: Icon(Icons.filter_alt, size: 14),
                        label: Text(
                          'Filter',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight
                                .w500, // Slightly bolder for better contrast
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(),
              const SizedBox(height: 20),
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
                                      (_currentPage * _itemsPerPage)),
                              itemBuilder: (context, index) {
                                int actualIndex =
                                    _currentPage * _itemsPerPage + index;
                                if (actualIndex >= _filteredItems.length)
                                  return SizedBox();

                                Item item = _filteredItems[actualIndex];
                                return ListTile(
                                  title: Text(
                                    item.itemDesc,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  subtitle: Text(
                                    'Item No: ${item.itemNo}\nBarcode: ${item.barcode}\nPrice: ${item.itemPrice} | Qty: ${item.qty}',
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
  Future<void> logout() async {
    const url = "http://192.168.100.180/A1PrimeInventory/logout.php";

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  Login()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Logout failed: ${data['message']}")),
        );
      }
    } catch (e) {
      print("Logout error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Network error during logout")),
      );
    }
  }
}


