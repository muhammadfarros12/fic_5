import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_auth/auth_bloc/auth_event.dart';

import '../auth_bloc/auth_bloc.dart';
import '../auth_bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Welcome to BLOC testing ${state.name}')),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              }, child: const Text('Logout'))
            ],
          );  
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
