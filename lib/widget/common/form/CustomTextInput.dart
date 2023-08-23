import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final Function(String, dynamic) setFieldValue;
  final String name;
  final String label;
  final String placeholder;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? textController;

  const CustomTextInput({
    super.key,
    required this.setFieldValue,
    required this.name,
    required this.label,
    this.placeholder = '',
    this.inputFormatters,
    this.textController,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey.shade500,
              ),
        ),
        TextFormField(
          style: TextStyle(color: Colors.grey.shade800),
          cursorColor: Theme.of(context).secondaryHeaderColor,
          controller: textController,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            alignLabelWithHint: false,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor, width: 1)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).secondaryHeaderColor,
                width: 1,
              ),
            ),
          ),
          validator: validator,
          onSaved: (String? value) {
            setFieldValue(name, value!);
          },
        ),
      ],
    );
  }
}
