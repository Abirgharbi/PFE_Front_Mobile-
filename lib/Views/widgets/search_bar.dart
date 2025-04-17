import 'package:flutter/material.dart';
import 'package:arkea/Views/screens/Home/filter_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Model/product_model.dart';
import '../../utils/colors.dart';
import '../screens/Home/home_page.dart';

class CustomSearchBar  extends StatefulWidget {
  final List<Product> productList;
  final void Function(List<Product>) onFilter;

  const CustomSearchBar ({
    Key? key,
    required this.productList,
    required this.onFilter,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProductList = [];

  @override
  void initState() {
    super.initState();
    _filteredProductList = widget.productList;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search items...",
          filled: true,
          fillColor: Colors.white,
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.btnColor.withOpacity(0.9),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    builder: (context) {
                      return const FilterPage();
                    },
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/filter_icon.svg',
                ),
              ),
            ),
          ),
        ),
       onChanged: (value) {
  _filteredProductList = widget.productList
      .where((product) => product.name.toLowerCase().contains(value.toLowerCase()))
      .toList();
  widget.onFilter(_filteredProductList);
},

      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
