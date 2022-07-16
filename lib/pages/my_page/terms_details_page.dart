import 'package:flutter/material.dart';
import 'package:thepuppyplace_flutter/models/Term.dart';
import 'package:thepuppyplace_flutter/util/common.dart';

class TermsDetailsPage extends StatelessWidget {
  final Term term;
  const TermsDetailsPage(this.term, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        titleTextStyle: CustomTextStyle.appBarStyle(context),
        title: Text(term.name, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mediaWidth(context, 0.033)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: mediaHeight(context, 0.01)),
                child: Text(term.name, style: CustomTextStyle.w600(context, scale: 0.025))),
            Text(term.content, style: CustomTextStyle.w500(context, height: 1.5)),
          ],
        )
      ),
    );
  }
}
