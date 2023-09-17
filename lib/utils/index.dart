import 'package:agotaxi/enums/RideTypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomUtils {
  void showCustomDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shadowColor: Colors.black.withAlpha(100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ), //this right here
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Center(
                          child: SvgPicture.asset('assets/icons/check.svg'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Solicitação bem sucedida",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Sua corrida foi confirmada! O motorista chegará para te pegar em 2 minutos.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    endIndent: 0,
                    height: 0.5,
                    thickness: 0.5,
                    indent: 0,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 20,
                              ),
                              child: Text(
                                'Cancelar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 0,
                          endIndent: 0,
                          width: 0.5,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 20,
                              ),
                              child: Text(
                                'Pronto',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

VeicleTypes stringToEnum(String input) {
  return VeicleTypes.values.firstWhere(
    (e) => e.toString().split('.').last == input,
    orElse: () => VeicleTypes.car,
  );
}

List<String> listDynamicToListString(List<dynamic> list) {
  return list.map((e) => e as String).toList();
}
