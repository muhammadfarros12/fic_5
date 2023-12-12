import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/login/login_bloc.dart';
import 'package:flutter_ecatalog/data/model/request/login_request_model.dart';
import 'package:flutter_ecatalog/presentation/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text('Login User'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ElevatedButton(
                  onPressed: () {
                    final requestModel = LoginRequestModel(
                        email: emailController!.text,
                        password: passwordController!.text);
                    context
                        .read<LoginBloc>()
                        .add(DoLoginEvent(model: requestModel));
                  },
                  child: const Text('Login'));
            }, listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
              if (state is LoginLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Login Success'),
                  backgroundColor: Colors.green,
                ));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
