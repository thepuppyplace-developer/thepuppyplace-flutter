import 'package:flutter/material.dart';

import '../../models/Search.dart';
import '../buttons/custom_text_button.dart';

class PopularSearchCard extends StatelessWidget {
  final Search search;
  final Function(String) onSearchTap;

  const PopularSearchCard(this.search, this.onSearchTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(search.search_text, (){
      onSearchTap(search.search_text);
    }, color: Colors.black, alignment: Alignment.centerLeft,);
  }
}
