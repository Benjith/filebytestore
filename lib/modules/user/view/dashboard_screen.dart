import 'dart:async';
import 'dart:io';

import 'package:filebytestore/modules/user/controller/user_bloc.dart';
import 'package:filebytestore/modules/user/model/user_model.dart';
import 'package:filebytestore/modules/user/view/custom_expansion_tile.dart';
import 'package:filebytestore/utils/pick_image.dart';
import 'package:filebytestore/utils/type_checker.dart';
import 'package:filebytestore/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../utils/color_resources.dart';
import 'search_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _debounce;

  UserBloc bloc = UserBloc();

  var scrollController = ScrollController();
  @override
  void initState() {
    bloc.pageIndex = 1;
    bloc.fetchList();
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          bloc.userList.isNotEmpty &&
          bloc.userList.length >= 10) {
        bloc.fetchList();
      }
    });
  }

  @override
  dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<UserModel?> addForm(UserModel model) async {
    final formKey = GlobalKey<FormState>();
    return await modalBottomSheet(
      context: context,
      title: "Details",
      builder: (
        context,
      ) {
        return StatefulBuilder(builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          ImageSource? source =
                              await imageSourcePicker(context);

                          if (source == null) {
                            return;
                          }
                          SVProgressHUD.show(status: 'Loading...');
                          File? result =
                              await pickImage(source, enableCrop: true);
                          SVProgressHUD.dismiss();
                          if (result != null) {
                            state(() {
                              model.imgUrl = result;
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: ColorResources.placeHolder,
                          radius: 60,
                          backgroundImage: model.imgUrl == null
                              ? null
                              : FileImage(
                                  model.imgUrl!,
                                ),
                          child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.edit,
                                color: ColorResources.placeHolder,
                              )),
                        ),
                      ),
                      TextFieldCustom(
                        initialValue: model.name,
                        labelText: 'Name',
                        hintText: 'Enter employee name',
                        onChanged: (text) {
                          model.name = text;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'Enter employee name';
                          }
                          return null;
                        },
                      ),
                      const Gap(24),
                      TextFieldCustom(
                        initialValue: model.employeeId,
                        keyboardType: TextInputType.phone,
                        labelText: 'Employee ID',
                        hintText: 'Enter employee unique id',
                        onChanged: (text) {
                          model.employeeId = text;
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'Enter employee number';
                          }
                          return null;
                        },
                      ),
                      const Gap(24),
                      CustomDropdownButtonFormField(
                        labelText: 'Nationality',
                        hintText: 'Choose employee nationality',
                        items: const ['INDIA', 'UAE'],
                        value: model.nationality,
                        onChanged: (String? value) {
                          model.nationality = value;
                        },
                      ),
                      const Gap(24),
                      DatePickerTextField(
                          pickFromFuture: false,
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: ColorResources.primary,
                          ),
                          labelText: 'Date of birth',
                          hintText: 'Choose employee dob',
                          onChanged: (value) {
                            model.dob = value;
                          },
                          value: model.dob),
                      const Gap(24),
                      SizedBox(
                        width: 172,
                        child: SubmitButton(
                          model.id != null ? 'Update' : 'Save',
                          onTap: (loader) async {
                            if (formKey.currentState!.validate()) {
                              bool result =
                                  await bloc.addUpdateUser(model, context);
                              if (result) {
                                customSnackBar(model.id != null
                                    ? 'Updated successfully'
                                    : 'Added new employee');
                                bloc.pageIndex = 1;
                                bloc.fetchList();
                                return Navigator.pop(context, model);
                              }
                            }
                          },
                        ),
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              )
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User list'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            SearchBarCustom(
              hintText: 'Search user',
              onChange: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  bloc.pageIndex = 1;
                  bloc.fetchList(keyword: value);
                });
              },
            ),
            const Gap(10),
            Container(
              decoration: BoxDecoration(
                  color: ColorResources.primary.withOpacity(.1),
                  border: const Border(
                      bottom:
                          BorderSide(color: ColorResources.blue, width: 1))),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    '#',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(80),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        bloc
                          ..pageIndex = 1
                          ..fetchList();
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                  stream: bloc.listStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return errorReload(snapshot.error.toString(),
                          callback: () {
                        bloc
                          ..pageIndex = 1
                          ..fetchList(keyword: '');
                      });
                    }

                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                      case ConnectionState.active:
                        if (snapshot.data!.isEmpty) {
                          return noItemsFound();
                        } else {
                          return RefreshIndicator(
                            onRefresh: () async {
                              bloc.pageIndex = 1;
                              bloc.fetchList();
                            },
                            child: ListView.builder(
                              controller: scrollController,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                var item = snapshot.data?[index];
                                return CustomExpansionTile(
                                  firstTitleMaxWidth: 80,
                                  titlePadding: 0,
                                  deleteAction: () async {
                                    if ((item?.id != null) ?? false) {
                                      ConditionalType? response =
                                          await confirmationDialog(
                                              "Delete?",
                                              "Are you sure you want to delete this entry?. This will be a permanent action.",
                                              "Yes",
                                              context);
                                      if (response == ConditionalType.yes) {
                                        bool result =
                                            await bloc.delete(item?.id);
                                        if (result) {
                                          setState(() {
                                            snapshot.data!.remove(item);
                                          });
                                        }
                                      }
                                    }
                                  },
                                  editAction: () async {
                                    if (item != null) {
                                      UserModel? newItem = await addForm(item!);

                                      if (newItem != null) {
                                        setState(() {
                                          item = newItem;
                                        });
                                      }
                                    }
                                  },
                                  leadingText: item?.employeeId ?? '',
                                  title: item?.name ?? "",
                                  children: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldCustom(
                                        labelText: 'Nationality',
                                        readOnlyField: true,
                                        initialValue: item?.nationality,
                                      ),
                                      const Gap(12),
                                      TextFieldCustom(
                                        labelText: 'D.O.B',
                                        readOnlyField: true,
                                        initialValue: item?.dob == null
                                            ? null
                                            : DateFormat('dd-MMM-yyyy')
                                                .format(item!.dob!),
                                      ),
                                      const Gap(12),
                                      if (item?.imgUrl != null)
                                        Image.file(item!.imgUrl!)
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }

                      case ConnectionState.waiting:
                        return Center(
                          child: stoppedAnimationProgress(),
                        );
                      default:
                        return Container();
                    }
                  }),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: SubmitButton(
                'Add',
                onTap: (loader) {
                  addForm(UserModel());
                },
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
