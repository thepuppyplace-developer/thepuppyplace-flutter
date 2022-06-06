import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:thepuppyplace_flutter/models/Term.dart';
import 'package:thepuppyplace_flutter/repositories/terms/terms_repo.dart';

class TermsListController extends GetxController with StateMixin<List<Term>>{
  final BuildContext context;
  TermsListController(this.context);

  static TermsListController to(BuildContext context) => Get.put(TermsListController(context));

  TermsRepo get _repo => TermsRepo();

  final _termsList = RxList<Term>();
  List<Term> get termsList => _termsList;

  @override
  void onReady() {
    super.onReady();
    ever(_termsList, _termsListListener);
    getTermsList;
  }

  void _termsListListener(List<Term> termsList){
    try{
      change(null, status: RxStatus.loading());
      if(termsList.isNotEmpty){
        change(termsList, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch(error){
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future get getTermsList async{
    _termsList.value = await _repo.getTermsList;
  }
}