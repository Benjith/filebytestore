import 'package:filebytestore/core/app_constants.dart';
import 'package:filebytestore/utils/color_resources.dart';
import 'package:filebytestore/utils/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Widget stoppedAnimationProgress({color}) => CircularProgressIndicator(
      strokeWidth: 2.5,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? ColorResources.bg),
    );

class SubmitButton extends StatefulWidget {
  const SubmitButton(
    this.title, {
    Key? key,
    this.onTap,
    this.padding = 14,
    this.backgroundColor = ColorResources.primary,
    this.textColor = Colors.white,
    this.overlayColor = Colors.white,
    this.textStyle,
    this.borderColor,
    this.radius,
    this.suffix,
  }) : super(key: key);

  const SubmitButton.primary(
    this.title, {
    Key? key,
    this.onTap,
    this.padding = 14,
    this.backgroundColor = ColorResources.primary,
    this.textColor = Colors.white,
    this.overlayColor = Colors.white,
    this.textStyle,
    this.borderColor,
    this.radius,
    this.suffix,
  }) : super(key: key);

  const SubmitButton.delete({
    this.title = 'Delete Post',
    Key? key,
    this.onTap,
    this.padding = 14,
    this.backgroundColor = ColorResources.grey,
    this.overlayColor = ColorResources.red,
    this.textStyle,
    this.textColor = ColorResources.red,
    this.borderColor,
    this.radius,
    this.suffix,
  }) : super(key: key);

  final ValueChanged<VoidCallback>? onTap;
  final String title;
  final double padding;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadius? radius;
  final Widget? suffix;
  final Color backgroundColor;
  final Color overlayColor;
  final TextStyle? textStyle;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton>
    with TickerProviderStateMixin {
  bool showLoader = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onTap == null
          ? null
          : () => widget.onTap!(() {
                setState(() {
                  showLoader = !showLoader;
                });
              }),
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(widget.padding),
        shape: RoundedRectangleBorder(
          borderRadius: widget.radius ?? BorderRadius.circular(5),
        ),
      ).copyWith(
        overlayColor: MaterialStatePropertyAll(
          widget.overlayColor.withOpacity(0.1),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return ColorResources.placeHolder;
            }
            return widget.backgroundColor;
          },
        ),
      ),
      child: showLoader
          ? stoppedAnimationProgress()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.suffix != null) ...[widget.suffix!, const Gap(6.5)],
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: (widget.textStyle ?? buttonText).copyWith(
                      color: widget.textColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Widget errorReload(dynamic message, {Function? callback}) {
  return Center(
      child: InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () => callback!(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.refresh),
        Text(
          message.toString(),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ));
}

Widget noItemsFound() {
  return Center(
      child: Text(
    "No matching records found",
    style: body1.black,
  ));
}

confirmationDialog(
    String title, String content, String okButtonText, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, textAlign: TextAlign.center, style: subHeading1.black),
          const SizedBox(height: 15),
          const Divider(),
          Text(content, textAlign: TextAlign.center, style: font14W400.black),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, ConditionalType.no);
                },
                child: Container(
                  color: Colors.white,
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: font14W400.black,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context, ConditionalType.yes);
                },
                child: Container(
                  color: Colors.white,
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    okButtonText,
                    style: font14W500.primary,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

customSnackBar(String s, {Color? color}) {
  ScaffoldMessenger.of(AppConstants.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(
    content: Text(
      s,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    backgroundColor: color ?? ColorResources.primary,
  ));
}

InputDecoration get defaultInputDecoration => InputDecoration(
      errorStyle: font14W400.copyWith(color: ColorResources.red),
      // hintStyle: body1.copyWith(color: ColorResources.grey),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(width: 1, color: ColorResources.placeHolder)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(width: 1, color: ColorResources.placeHolder)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              const BorderSide(width: 1, color: ColorResources.primary)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(width: 1, color: Color(0xffD9DBE9))),
    );

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({
    Key? key,
    this.controller,
    this.prefixWidget,
    this.labelText,
    this.hintText,
    this.suffixWidget,
    this.readOnlyField,
    this.onTap,
    this.keyboardType,
    this.isEnabled = true,
    this.obscure = false,
    this.labelColor,
    this.fillColor,
    this.enableBorder = true,
    this.textAlign = TextAlign.start,
    this.height = 56,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines = 1,
    this.labelStyle,
    this.validator,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.style,
    this.prefixStyle,
    this.prefixText,
    this.initialValue,
    this.maxLength,
    this.showCounter = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? prefixWidget;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixWidget;
  final bool? readOnlyField;
  final Function? onTap;
  final bool isEnabled;
  final bool obscure;
  final TextAlign textAlign;
  final Color? labelColor;
  final Color? fillColor;
  final bool enableBorder;
  final double height;
  final EdgeInsets? contentPadding;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextStyle? labelStyle;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final Widget? prefix;
  final Widget? suffix;
  final void Function(String text)? onChanged;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final TextStyle? style;
  final TextStyle? prefixStyle;
  final String? prefixText;
  final String? initialValue;
  final bool showCounter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText?.isNotEmpty ?? false) ...[
          Text(
            labelText!,
            style: labelStyle ?? body1Medium.black,
          ),
          const Gap(11)
        ],
        TextFormField(
          focusNode: focusNode,
          onChanged: onChanged,
          initialValue: initialValue,
          maxLength: maxLength ??
              ((keyboardType == TextInputType.name ||
                      keyboardType == TextInputType.emailAddress)
                  ? 30
                  : keyboardType == TextInputType.phone
                      ? 10
                      : null),
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            maxLength,
          }) {
            if (!isFocused || !showCounter) {
              return null;
            }

            return Text(
              '$currentLength/$maxLength',
              style: caption.black,
            );
          },
          onFieldSubmitted: onFieldSubmitted,
          onEditingComplete: onEditingComplete,
          maxLines: maxLines,
          minLines: minLines,
          obscureText: obscure,
          enabled: isEnabled,
          onTap: () => onTap == null ? null : onTap!(),
          readOnly: readOnlyField ?? false,
          controller: controller,
          validator: validator,
          textAlign: textAlign,
          keyboardType: keyboardType ?? TextInputType.name,
          style: style ?? body1.copyWith(color: ColorResources.black),
          cursorColor: ColorResources.black,
          textInputAction: textInputAction,
          inputFormatters: [
            if (keyboardType == TextInputType.phone)
              FilteringTextInputFormatter.digitsOnly,
            if (keyboardType == TextInputType.name)
              FilteringTextInputFormatter.allow(RegExp(r'^[a-z A-Z,.\-]+$'))
          ],
          decoration: defaultInputDecoration.copyWith(
            filled: fillColor == null ? false : true,
            fillColor: fillColor,
            prefix: prefix,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: hintText,
            // hintStyle: body1.copyWith(color: ColorResources.grey),
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget,
            errorStyle: font14W400.copyWith(color: ColorResources.red),
            suffix: suffix,
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 17.97,
                  vertical: maxLines == null ? 0 : maxLines! * 3,
                ),
          ),
        ),
      ],
    );
  }
}

class DatePickerController {
  late VoidCallback openDatePicker;
}

class DatePickerTextField extends StatefulWidget {
  const DatePickerTextField({
    Key? key,
    required this.onChanged,
    required this.value,
    this.controller,
    this.hintText,
    this.pickFromFuture = true,
    this.validator,
    this.labelText,
    this.suffixIcon,
    this.dismissSuffixIcon = false,
    this.textAlign = TextAlign.start,
    this.initialDate,
  }) : super(key: key);

  final ValueChanged<DateTime?> onChanged;
  final DateTime? value;
  final DatePickerController? controller;
  final DateTime? initialDate;
  final bool pickFromFuture;
  final FormFieldValidator<String?>? validator;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final bool dismissSuffixIcon;
  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  final _dateTextController = TextEditingController();

  bool get pickFromFuture => widget.pickFromFuture;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.openDatePicker = openDatePicker;
    }

    if (widget.value != null) {
      setTextController(widget.value!);
    }
  }

  Future<DateTime?> datePicker(BuildContext context, DateTime initialDate,
      bool pickFromFuture, String hintText,
      {bool enableAllDays = false}) async {
    DateTime oldDate = DateTime.parse('1900-01-01');
    DateTime futureDate = DateTime.now().add(const Duration(days: 365 * 4));
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      locale: const Locale('en', 'IN'),
      firstDate:
          enableAllDays ? oldDate : (pickFromFuture ? DateTime.now() : oldDate),
      lastDate: enableAllDays
          ? futureDate
          : (pickFromFuture ? futureDate : DateTime.now()),
      helpText: hintText,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: ColorResources.primary,
              brightness: Brightness.light,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ColorResources.black,
              onBackground: Colors.white,
              secondary: ColorResources.primary,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textTheme: TextTheme(
              subtitle1: subHeading1.primary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void openDatePicker() async {
    final DateTime? newValue = await datePicker(
      context,
      widget.value ?? widget.initialDate ?? DateTime.now(),
      pickFromFuture,
      widget.hintText ?? "",
    );
    if (newValue != null) {
      setTextController(newValue);
      widget.onChanged(newValue);
    } else {
      _dateTextController.text = '';
    }
    setState(() {});
  }

  void setTextController(DateTime dateTime) {
    _dateTextController.text = DateFormat("dd/MM/yyyy").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: openDatePicker,
      child: TextFieldCustom(
        textAlign: widget.textAlign!,
        hintText: widget.hintText,
        controller: _dateTextController,
        labelText: widget.labelText,
        validator: widget.validator,
        suffixWidget: widget.dismissSuffixIcon
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: widget.suffixIcon,
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        isEnabled: false,
      ),
    );
  }
}

modalBottomSheet(
    {required BuildContext context,
    required Widget Function(
      BuildContext,
    ) builder,
    String? title,
    VoidCallback? callback}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: true,
    builder: (context) => SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight * 2,
          ),
          child: ListView(
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: h6.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                const Divider(),
                Builder(
                  builder: builder,
                ),
              ]),
        )
        // }),
        ),
  );
}

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  const CustomDropdownButtonFormField(
      {Key? key,
      this.labelText,
      this.hintText,
      required this.items,
      required this.onChanged,
      this.value,
      this.validator,
      this.contentPadding,
      this.dismissBorder = false,
      this.prefixText})
      : super(key: key);

  final String? labelText;
  final String? hintText;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final EdgeInsets? contentPadding;
  final FormFieldValidator? validator;
  final bool dismissBorder;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: body1Medium.black,
          ),
          const Gap(9),
        ],
        DropdownButtonFormField<T>(
          alignment:
              dismissBorder ? Alignment.centerRight : Alignment.centerLeft,
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Builder(builder: (context) {
                      String text = e.toString();
                      if (e is MapEntry<String, int>) {
                        text = e.key;
                      }
                      return Text(
                        text,
                        style: body2.black,
                      );
                    }),
                  ))
              .toList(),
          value: value,
          onChanged: onChanged,
          validator: validator,
          iconEnabledColor: ColorResources.primary,
          iconDisabledColor: ColorResources.grey,
          icon: const Icon(Icons.arrow_downward),
          decoration: defaultInputDecoration.copyWith(
            prefixText: prefixText,
            focusedBorder: dismissBorder ? InputBorder.none : null,
            enabledBorder: dismissBorder ? InputBorder.none : null,
            hintText: hintText,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 17.97,
                  vertical: 0,
                ),
          ),
        )
      ],
    );
  }
}

TextButton _button({
  required VoidCallback? onPressed,
  required Icon icon,
  required String label,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Column(
      children: [
        icon,
        const Gap(8),
        Text(
          label,
          style: body2.w500.black,
        )
      ],
    ),
  );
}

imageSourcePicker(context) async {
  return await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(12),
      children: [
        Text(
          'Select Source',
          style: h6.black,
          textAlign: TextAlign.center,
        ),
        const Gap(2),
        const Divider(
          color: ColorResources.grey,
          thickness: 1,
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: _button(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                icon: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: 'Camera',
              ),
            ),
            const Gap(8),
            Expanded(
              child: _button(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                icon: const Icon(
                  Icons.photo,
                  color: Colors.black,
                ),
                label: 'Gallery',
              ),
            ),
          ],
        )
      ],
    ),
  );
}

enum ConditionalType { yes, no }
