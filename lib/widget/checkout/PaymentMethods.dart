import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Métodos de pagamento',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          'Selecione o método de pagamentoque o cliente usou.',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          value: 'cash',
          label: 'Dinheiro',
          icon: 'assets/icons/paypal.svg',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          value: 'mpesa',
          label: 'Mpesa',
          icon: 'assets/icons/mpesa.svg',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          value: 'emola',
          label: 'Emola',
          icon: 'assets/icons/transfer.svg',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
        const SizedBox(height: 8),
        CustomRadioButton(
          value: 'other',
          label: 'Outro',
          icon: 'assets/icons/paypal.svg',
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
        ),
      ],
    );
  }
}

class CustomRadioButton extends StatefulWidget {
  final String value;
  final String icon;
  final String label;
  final String groupValue;
  final ValueChanged<String>? onChanged;

  CustomRadioButton({
    required this.icon,
    required this.value,
    required this.label,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.value);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: widget.value == widget.groupValue
              ? Border.all(color: Theme.of(context).primaryColor)
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            SvgPicture.asset(widget.icon),
            const SizedBox(
              width: 12,
            ),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
