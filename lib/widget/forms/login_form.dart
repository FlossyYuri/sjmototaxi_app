import 'package:agotaxi/services/auth.dart';
import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/common/form/CustomTextInput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agotaxi/utils/form_validation_api.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {
    'email': '',
    'password': '',
  };

  setFieldValue(field, value) {
    setState(() {
      _formValues[field] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'email',
            label: 'Email',
            placeholder: 'nome@exemplo.com',
            validator: (val) {
              if (!val!.isValidEmail) {
                return 'Email inválido, escreva novamente';
              }
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'password',
            label: 'Senha',
            placeholder: '******',
            validator: (val) {
              if (!val!.isValidPassword) {
                return 'Senha inválida, tente novamente';
              }
            },
          ),
          const SizedBox(height: 24),
          Obx(
            () => AppButton(
              label: "Entrar",
              isLoading: authStoreController.isLoading.isTrue,
              onClick: () async {
                authStoreController.updateLoader(true);
                if (!_formKey.currentState!.validate()) {
                  authStoreController.updateLoader(false);
                  return;
                }
                _formKey.currentState!.save();
                var response = await postRequest('auth/login', _formValues);
                authStoreController.updateLoader(false);
                if (response['statusCode'] >= 200 &&
                    response['statusCode'] < 300) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login Realizado com sucesso'),
                    ),
                  );
                  authStoreController.login(response['jsonResponse']);
                  Get.offAllNamed('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Não foi possível fazer o login, verifique suas  credenciais!'),
                    ),
                  );
                }
                Future.delayed(Duration(seconds: 1)).then(
                  (value) => authStoreController.updateLoader(false),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
