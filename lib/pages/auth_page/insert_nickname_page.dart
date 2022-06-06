import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/Term.dart';
import '../../util/common.dart';
import '../../views/insert_nickname_view.dart';

class InsertNicknamePage extends StatelessWidget {
  final List<Term> termsList;
  final GoogleSignInAccount? googleUser;
  final AuthorizationCredentialAppleID? appleUser;

  const InsertNicknamePage(
      this.termsList,{
        this.googleUser,
        this.appleUser,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: CustomTextStyle.appBarStyle(context),
          title: const Text('닉네임 설정'),
        ),
        body: InsertNicknameView(termsList, googleUser: googleUser, appleUser: appleUser),
      ),
    );
  }
}