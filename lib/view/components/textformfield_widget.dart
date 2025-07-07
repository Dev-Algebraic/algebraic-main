import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart' as constants;

class TextformWidget extends StatefulWidget {
  final String? labelName;
  final ValueChanged<String?>? saved;
  final bool? isMandatory;
  final FocusNode? focusNode;
  final TextCapitalization? capitalization;
  final AutovalidateMode? autovalidateMode;
  final int? maxlines;
  final int? minlines;
  final bool? enabled;
  final bool? autofocus;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? prefix;
  final String? errortxt;
  final int? errorlines;
  final EdgeInsetsGeometry? contentpadding;
  final TextInputType? keyboardtype;
  final int? maxLength;
  final bool? email;
  final bool? url;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool? readOnly;
  final bool? obscureText;

  const TextformWidget({
    Key? key,
    this.labelName,
    this.isMandatory,
    this.focusNode,
    this.capitalization,
    this.autovalidateMode,
    this.maxlines,
    this.minlines,
    this.saved,
    this.enabled,
    this.autofocus,
    this.controller,
    this.suffixIcon,
    this.errortxt,
    this.contentpadding,
    this.errorlines,
    this.keyboardtype,
    this.maxLength,
    this.email,
    this.url,
    this.inputFormatters,
    this.validator,
    this.initialValue,
    this.readOnly,
    this.obscureText,
    this.prefix,
  }) : super(key: key);

  @override
  State<TextformWidget> createState() => _TextformWidgetState();
}

class _TextformWidgetState extends State<TextformWidget> {
  String? onValidate(txt) {
    if(widget.email!=null && widget.email! && txt!=null && txt !=""){
      bool vaild=EmailValidator.validate(txt);
      return vaild?null: "Enter a valid email";

    }else {
      return txt.length <= 0 ? "This field is required" : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelName != null
            ? Text(
                widget.labelName!,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color.fromRGBO(142, 158, 177, 1)),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: TextFormField(
              obscureText: widget.obscureText ?? false,
              readOnly: widget.readOnly ?? false,
              style: TextStyle(
                color: constants.themeColor,
              ),
              initialValue: widget.initialValue,
              keyboardType: widget.keyboardtype,
              inputFormatters: widget.inputFormatters ?? [],
              focusNode: widget.focusNode,
              textCapitalization:
                  widget.capitalization ?? TextCapitalization.none,
              autovalidateMode: widget.autovalidateMode,
              maxLength: widget.maxLength,
              maxLines: widget.maxlines,
              minLines: widget.minlines,
              enabled: widget.enabled,
              autofocus: false,
              controller: widget.controller,
              decoration: InputDecoration(
                counterText: "",
                suffixIcon: widget.suffixIcon,
                errorMaxLines: widget.errorlines,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(202, 212, 224, 1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(202, 212, 224, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: constants.themeColor,
                  ),
                ),
                errorStyle: TextStyle(color: Color.fromRGBO(244, 151, 142, 1)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(244, 151, 142, 1),
                  ),
                ),
                // labelStyle: TextStyle(color: constants.themeColor),
                // labelText: widget.labelName,
                errorText: widget.errortxt,
              ),
              onSaved: (val) => widget.saved!(val),
              validator: widget.validator != null
                  ? (widget.validator!)
                  : (val) => (widget.isMandatory! ? onValidate(val) : null)),
        ),
      ],
    );
  }
}
