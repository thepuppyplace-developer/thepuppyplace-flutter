import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/util/common.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_icon_button.dart';

import '../../models/Search.dart';
import '../buttons/custom_text_button.dart';

class PopularSearchCard extends StatelessWidget {
  final Search search;
  final Function(String) onSearchTap;
  final Function(Search)? onDelete;

  const PopularSearchCard(this.search, this.onSearchTap, {
    this.onDelete,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: CustomTextButton(search.search_text, (){
              onSearchTap(search.search_text);
            }, color: Colors.black, alignment: Alignment.centerLeft,),
          ),
          if(isAdmin && onDelete != null) CustomIconButton(icon: Icons.clear, onTap: () => onDelete!(search))
        ],
      ),
    );
  }
}
