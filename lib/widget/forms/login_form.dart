import 'package:agotaxi/services/auth.dart';
import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/utils/auth.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/common/form/CustomTextInput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

                try {
                  UserCredential user = await _auth.signInWithEmailAndPassword(
                      email: _formValues['email'],
                      password: _formValues['password']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login Realizado com sucesso'),
                    ),
                  );
                  print("-------------------------");
                  print(user.user.toString());
                  print(await user.user!.getIdToken());
                  print("-------------------------");
                  var registeredUser = await _firestore
                      .collection('users')
                      .doc(user.user!.uid)
                      .get();
                  authStoreController.login({
                    'user': registeredUser.data(),
                    'token': await user.user!.getIdToken()
                  });

                  Get.offAllNamed('/home');
                } on FirebaseAuthException catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Não foi possível fazer o login, verifique suas  credenciais!'),
                    ),
                  );
                  print(err.toString());
                  print(determineError(err).toString());
                }

                authStoreController.updateLoader(false);

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
