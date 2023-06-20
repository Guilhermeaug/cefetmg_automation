import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _login(BuildContext context) {
    final cpf = cpfController.text.replaceAll(RegExp(r'\D'), '');
    final password = passwordController.text;
    final sharedPrefs = GetIt.instance.get<SharedPreferences>();
    sharedPrefs.setString('cpf', cpf);
    sharedPrefs.setString('password', password);
    context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'CPF',
            hintText: 'Entre com seu CPF',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          controller: cpfController,
        ),
        const SizedBox(height: 4.0),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Senha',
            hintText: 'Entre com sua senha',
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          controller: passwordController,
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _login(context),
            child: const Text('Entrar'),
          ),
        ),
      ],
    );
  }
}
