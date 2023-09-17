import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/Driver.dart';
import 'package:agotaxi/model/user.dart';
import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/utils/form_validation_api.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/common/form/CustomTextInput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountForm extends StatefulWidget {
  final int activeTabIndex;

  const CreateAccountForm({
    super.key,
    required this.activeTabIndex,
  });

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {
    'name': '',
    'phone': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
  };
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  setFieldValue(field, value) {
    setState(() {
      _formValues[field] = value;
    });
  }

  void signUpFirebase(String email, String password) async {}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'name',
            label: 'Nome Completo',
            placeholder: 'Nome Completo',
            validator: (val) {
              if (!val!.isValidName) {
                return 'Nome inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'phone',
            label: 'Telefone',
            placeholder: '8* *** ****',
            validator: (val) {
              if (!val!.isValidPhone) {
                return 'Número inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'email',
            label: 'Email',
            placeholder: 'nome@exemplo.com',
            validator: (val) {
              if (!val!.isValidEmail) {
                return 'Email inválido, escreva novamente';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          if (widget.activeTabIndex == 1)
            Column(
              children: [
                CustomTextInput(
                  setFieldValue: setFieldValue,
                  name: 'veicleType',
                  label: 'Tipo de Veículo',
                  placeholder: 'Moto',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextInput(
                  setFieldValue: setFieldValue,
                  name: 'brand',
                  label: 'Marca do Veículo',
                  placeholder: 'Suzuki',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextInput(
                  setFieldValue: setFieldValue,
                  name: 'plate',
                  label: 'Matrícula',
                  placeholder: 'XYZ 123 MP',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Matrícula é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'password',
            label: 'Senha',
            placeholder: '******',
            textController: passwordController,
            validator: (val) {
              if (!val!.isValidPassword) {
                return 'Senha fraca, tente outra';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            setFieldValue: setFieldValue,
            name: 'confirmPassword',
            label: 'Confirmar Senha',
            placeholder: '******',
            validator: (val) {
              if (val != passwordController.text) {
                return 'Senha inválida, digite a mesma senha';
              }
              // if (val != _formValues['password']) {
              //   return 'Senha inválida, digite a mesma senha';
              // }
            },
          ),
          const SizedBox(height: 24),
          Obx(
            () => AppButton(
              label: "Criar conta",
              isLoading: authStoreController.isLoading.value,
              onClick: () async {
                authStoreController.updateLoader(true);
                if (!_formKey.currentState!.validate()) {
                  authStoreController.updateLoader(false);
                  return;
                }
                _formKey.currentState!.save();
                if (widget.activeTabIndex == 0) {
                  _formValues['role'] = 'CLIENT';
                  _formValues.removeWhere((key, value) =>
                      key == 'brand' || key == 'plate' || key == 'veicleType');
                } else {
                  _formValues['role'] = 'DRIVER';
                }
                print(_formValues.toString());
                try {
                  UserCredential user =
                      await _auth.createUserWithEmailAndPassword(
                          email: _formValues['email'],
                          password: _formValues['password']);
                  _formValues['uid'] = user.user!.uid;
                  _formValues.removeWhere((key, value) =>
                      key == 'password' || key == 'confirmPassword');
                  await _firestore
                      .collection('users')
                      .doc(user.user!.uid)
                      .set(_formValues);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Conta criada com sucesso!'),
                    ),
                  );
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
                      content:
                          Text('Erro ao criar conta! Tente novamente mais'),
                    ),
                  );
                  print(err.toString());
                }

                authStoreController.updateLoader(false);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
