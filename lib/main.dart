import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/data/repositories/auth_repository.dart';
import 'package:ucp2/data/repositories/katalog_repository.dart';
import 'package:ucp2/ui/pages/homepage.dart';
import 'package:ucp2/ui/pages/katalogpage.dart';
import 'package:ucp2/ui/pages/katalog_form_page.dart';
import 'package:ucp2/ui/pages/kategoripage.dart';
import 'package:ucp2/ui/pages/loginpage.dart';
import 'package:ucp2/ui/pages/registerpage.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(repository: AuthRepository())..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => KatalogBloc(repository: KatalogRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'DriveEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Homepage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => Homepage(),
          '/katalog': (context) => KatalogPage(),
          '/katalog/tambah': (context) => BlocProvider.value(
                value: context.read<KatalogBloc>(),
                child: const KatalogFormPage(),
              ),
          '/kategori': (context) => KategoriPage(),
        },
      ),
    );
  }
}
