import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/pages/my_page/terms_details_page.dart';
import 'package:thepuppyplace_flutter/widgets/buttons/custom_text_button.dart';
import '../../models/Term.dart';
import '../../util/common.dart';
import '../pages/my_page/terms_page.dart';

enum TermsType{require, select}

class TermsCheckbox extends StatelessWidget {
  final bool allCheck;
  final List<Term> termsList;
  final Function(bool) onAllCheck;
  final Function(int, bool) onTermsCheck;

  const TermsCheckbox({
    required this.allCheck,
    required this.termsList,
    required this.onAllCheck,
    required this.onTermsCheck,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: allCheck ? CustomColors.main : Colors.black)
          ),
          margin: baseVerticalPadding(context),
          child: CupertinoButton(
            padding: basePadding(context),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                        '아래 내용에 모두 동의합니다.',
                        style: CustomTextStyle.w600(context, height: 1.5))),
                Icon(Icons.check, size: mediaHeight(context, 0.03), color: allCheck ? CustomColors.main : CustomColors.emptySide)
              ],
            ),
            onPressed: (){
              onAllCheck(allCheck);
            },
          ),
        ),
        if(termsList.isNotEmpty) for(int index = 0; index < termsList.length; index++) TermsItem(
          termsList[index],
          check: termsList[index].check,
          index: index,
          onTermsCheck: (check){
            onTermsCheck(index, check);
          },
        )
      ],
    );
  }
}

class TermsItem extends StatelessWidget {
  final Term term;
  final bool check;
  final int index;
  final Function(bool) onTermsCheck;

  const TermsItem(this.term, {
    required this.check,
    required this.index,
    required this.onTermsCheck,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Text(term.name,
                        style: CustomTextStyle.w500(context)),
                    Text(_termsText(term.is_required ? TermsType.require : TermsType.select),
                        style: CustomTextStyle.w500(context)),
                  ],
                ),
                onPressed: () => Get.to(() => TermsDetailsPage(term)),
              ),
            ),
            CupertinoButton(
                child: Icon(Icons.check, size: mediaHeight(context, 0.03), color: check ? CustomColors.main : CustomColors.emptySide),
              onPressed: (){
                onTermsCheck(check);
              },
            )
          ],
        ),
      ],
    );
  }
}

String _termsText(TermsType termsType){
  switch(termsType){
    case TermsType.require: return '(필수)';
    case TermsType.select: return '(선택)';
    default: return '';
  }
}