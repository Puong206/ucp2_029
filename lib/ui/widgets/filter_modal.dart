import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget{
  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? selectedSeats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Text('Filter Modal'),
          // Tambahkan widget filter lainnya di sini
        ],
      ),
    );
  }
}