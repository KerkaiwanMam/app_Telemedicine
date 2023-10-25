import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class TextFormFieldSignIn extends StatelessWidget {
  final TextEditingController controller;
  final String labelTextDetail;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const TextFormFieldSignIn({
    Key? key,
    required this.controller,
    required this.labelTextDetail,
    required this.obscureText,
    required this.keyboardType,
    this.validator,
    this.focusNode,
    this.onTap,
    this.errorMsg,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: UnderlineInputBorder(),
        labelText: labelTextDetail,
        errorText: errorMsg,
      ),
    );
  }
}

class PhoneFormFieldSignIn extends StatefulWidget {
  final String labelTextDetail;

  PhoneFormFieldSignIn({Key? key, required this.labelTextDetail})
      : super(key: key);

  @override
  _PhoneFormFieldSignInState createState() => _PhoneFormFieldSignInState();
}

class _PhoneFormFieldSignInState extends State<PhoneFormFieldSignIn> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: widget.labelTextDetail,
      ),
    );
  }
}

class BoxFormFieldSignIn extends StatefulWidget {
  BoxFormFieldSignIn({Key? key}) : super(key: key);

  @override
  _BoxFormFieldSignInState createState() => _BoxFormFieldSignInState();
}

class _BoxFormFieldSignInState extends State<BoxFormFieldSignIn> {
  @override
  Widget build(BuildContext context) {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 30,
      style: TextStyle(fontSize: 16),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      keyboardType: TextInputType.number,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
      },
    );
  }
}
class DropDownFormFieldSignIn extends StatelessWidget {
  final String? dropdownValue;
  final String labelText;
  final List<String> items;
  final Function(String?) onChanged;

  DropDownFormFieldSignIn({
    required this.items,
    required this.labelText,
    required this.dropdownValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      value: dropdownValue,
      dropdownColor: Colors.white,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}