import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  CustomAppBar({required this.title, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // Black color for the line
            width: 2, // Thickness of the line
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.white, // Adjust the AppBar background color
        centerTitle: true,
        elevation: 0, // Remove default AppBar shadow
        title: Text(
          title,
          style: GoogleFonts.righteous(
            fontSize: 36,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
