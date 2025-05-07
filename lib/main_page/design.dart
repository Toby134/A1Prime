import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetailsDesign {
  static Widget buildSectionHeader(String title,
      {bool isSmallScreen = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 20, color: Colors.black87),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildInfoCard({required List<Widget> children}) {
  return Card(
    elevation: 0, // Removed elevation offset
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Colors.grey, // 0.5 border
        width: 0.5,
      ),
    ),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
}

 static Widget buildInfoRow(
  String label,
  String value, {
  TextStyle? valueStyle,
  bool isSmallScreen = false,
  IconData? icon,
  Color labelColor = Colors.black54,
  Color valueColor = Colors.black87,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              if (icon != null) Icon(icon, size: 16, color: labelColor),
              if (icon != null) const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: labelColor, // <-- use labelColor here
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: valueStyle ??
                GoogleFonts.lato(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: valueColor, // <-- use valueColor here
                ),
            maxLines: 5,
          ),
        ),
      ],
    ),
  );
}


  static Widget buildBranchDropdown(
    List<Map<String, String>> branches, {
    required String? selectedBranch,
    required Function(String?) onChanged,
    bool isSmallScreen = false,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      hint: Text(
        'Select Branch',
        style: GoogleFonts.poppins(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
      iconSize: 28,
      items: branches.map((branch) {
        return DropdownMenuItem(
          value: branch['BranchName'],
          child: Text(
            branch['BranchName']!,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 16,
            ),
            maxLines: 5,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  static Widget buildCountInputField({
    required TextEditingController controller,
    bool isSmallScreen = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Enter item count',
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.poppins(),
        prefixIcon: const Icon(Icons.format_list_numbered, color: Colors.grey),
      ),
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 14 : 16,
        color: Colors.black87,
      ),
    );
  }
    static Widget buildAddButton({
    required VoidCallback onPressed,
    bool isSmallScreen = false,
  }) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'ADD COUNT',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF40A3EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 32 : 48,
            vertical: isSmallScreen ? 16 : 20,
          ),
          elevation: 4,
        ),
      ),
    );
  }
}