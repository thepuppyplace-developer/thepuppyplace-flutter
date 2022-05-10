import 'package:flutter/material.dart';

import '../util/common.dart';

enum TermsType{require, select}

class TermsCheckbox extends StatelessWidget {
  final bool allCheck;
  final List<bool> termsCheckList;
  final Function(bool) onAllCheck;
  final Function(int, bool) onTermsCheck;

  const TermsCheckbox({
    required this.allCheck,
    required this.termsCheckList,
    required this.onAllCheck,
    required this.onTermsCheck,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: basePadding(context),
      child: Column(
        children: [
          Container(
            margin: baseVerticalPadding(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: allCheck
                      ? Icon(Icons.check_circle, size: mediaHeight(context, 0.03), color: CustomColors.main)
                      : Icon(Icons.check_circle_outline, size: mediaHeight(context, 0.03), color: Colors.grey),
                  onTap: (){
                    onAllCheck(allCheck);
                  },
                ),
                Expanded(
                    child: Container(
                      margin: baseHorizontalPadding(context),
                      child: Text(
                          '바야바즈 이용약관, 개인정보 수집 및 이용, 위치정보 이용약관, 프로모션 정보 수신(선택)에 모두 동의합니다.',
                          style: CustomTextStyle.w600(context, height: 1.5)),
                    )),
              ],
            ),
          ),
          for(int index = 0; index < termsCheckList.length; index++) TermsItem(
            check: termsCheckList[index],
            onTermsCheck: (check){
              onTermsCheck(index, check);
            },
          )
        ],
      ),
    );
  }
}

class TermsItem extends StatelessWidget {
  final bool check;
  final Function(bool) onTermsCheck;

  const TermsItem({
    required this.check,
    required this.onTermsCheck,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: baseVerticalPadding(context),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: check
                    ? Icon(Icons.check_circle, size: mediaHeight(context, 0.03), color: CustomColors.main)
                    : Icon(Icons.check_circle_outline, size: mediaHeight(context, 0.03), color: Colors.grey),
                onTap: (){
                  onTermsCheck(check);
                },
              ),
              Expanded(
                child: Container(
                    margin: baseHorizontalPadding(context),
                    child: Text('약관 동의', style: CustomTextStyle.w600(context))),
              ),
              Text(_termsText(TermsType.require),
                  style: CustomTextStyle.w500(context, color: CustomColors.main, scale: 0.016))
            ],
          ),
          Container(
            height: mediaHeight(context, 0.15),
            width: mediaWidth(context, 1),
            margin: baseVerticalPadding(context),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: CustomColors.hint),
                borderRadius: BorderRadius.circular(20)
            ),
            child: SingleChildScrollView(
                padding: basePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('개인정보 취급 동의약관', style: CustomTextStyle.w600(context)),
                    Container(
                        margin: baseVerticalPadding(context),
                        child: Text('개인정보 취급 동의약관입니다\n안녕', style: CustomTextStyle.w500(context, color: Colors.grey, scale: 0.018, height: 1.5))),
                  ],
                )
            ),
          )
        ],
      ),
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