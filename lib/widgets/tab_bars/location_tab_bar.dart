import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../models/User.dart';

class LocationTabBar extends GetWidget<AuthController> with PreferredSizeWidget{
  final double height;

  const LocationTabBar(this.height, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => controller.obx((User? user) => SizedBox(
      height: height,
      child: ListTile(
        title: Text(user!.location ?? '지역을 선택해주세요.'),
        trailing: OutlineButton(
          child: Text('지역선택'),
          onPressed: (){},
        ),
      )
  ));

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
