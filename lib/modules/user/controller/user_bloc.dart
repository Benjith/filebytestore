// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:filebytestore/modules/user/model/user_model.dart';
import 'package:filebytestore/modules/user/repository.dart/user_repository.dart';
import 'package:filebytestore/widgets.dart';
import 'package:flutter/material.dart';

class UserBloc {
  UserRepository repository = UserRepository();

  int pageIndex = 1;

  List<UserModel> userList = [];

  StreamController<List<UserModel>> listSC =
      StreamController<List<UserModel>>.broadcast();

  Stream<List<UserModel>> get listStream => listSC.stream;

  Future fetchList({String? keyword}) async {
    try {
      if (pageIndex == 1) {
        userList.clear();
      }
      List<UserModel> result = await repository.fetchList(keyword, pageIndex);
      userList.addAll(result);
      listSC.sink.add(userList);
    } catch (e) {
      listSC.sink.addError(e);
    }
  }

  delete(int? id) async {
    try {
      return await repository.delete(id);
    } catch (e) {
      customSnackBar(e.toString());
    }
  }

  Future addUpdateUser(UserModel model, BuildContext context) async {
    try {
      await repository.addUpdateUser(model);
      return true;
    } catch (e) {
      Flushbar(
        title: "Failed!",
        message: e.toString().toLowerCase().contains('unique')
            ? 'Employee ID is already used'
            : e.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
      return false;
    }
  }
}
