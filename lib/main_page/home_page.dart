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
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  String? selectedBranch;
  String? selectedBranchCode;
  int _currentPage = 0;
  static const int _itemsPerPage = 4;
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

  void _filterByPriceRange() {
    final min = double.tryParse(_minPriceController.text) ?? 0;
    final max = double.tryParse(_maxPriceController.text) ?? double.infinity;

    setState(() {
      _filteredItems = _allItems.where((item) {
        return item.itemPrice >= min && item.itemPrice <= max;
      }).toList();
      _currentPage = 0;
    });
  }

  double getTotalUnitsAll() {
    return _allItems.fold(0.0, (sum, item) => sum + (item.qty));
  }

  void _showFilterDialog(BuildContext context) {
    final minController = TextEditingController(text: _minPriceController.text);
    final maxController = TextEditingController(text: _maxPriceController.text);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Items',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Price range fields
              Text(
                'Price Range',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.attach_money, size: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.attach_money, size: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Action buttons
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
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _minPriceController.text = minController.text;
                        _maxPriceController.text = maxController.text;
                        _filterByPriceRange();
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 2.0), // Small vertical nudge for perfect alignment
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
              fontWeight: FontWeight.w500, // Slightly bolder for better contrast
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
}
