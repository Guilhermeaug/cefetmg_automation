import 'package:cefetmg_automation/components/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'ENTRAR',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text('Utilize as mesmas credenciais do SIGAA para entrar no app.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16.0),
              const LoginForm(),
              const Spacer(),
              Center(
                child: Text(
                  'Nenhuma informação é armazenada fora do seu dispositivo.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
