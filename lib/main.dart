import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorm_firebase_database/dorm_firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';
import 'models/models.dart';
import 'screens/auth/login.dart';
import 'screens/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  const FirebaseInstance instance = FirebaseInstance();
  final FirebaseReference prodRef = FirebaseReference(instance, 'production');
  final FirebaseReference testRef = FirebaseReference(instance, 'teste');
  GetIt.instance.registerSingleton<Dorm>(Dorm(prodRef));
  runApp(const MyApp());
}

Future<FirebaseApp> _initializeFirebase() async {
  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final User? user = snapshot.data;
          return user == null
              ? const LoginScreen()
              : Provider<User?>(
                  create: (_) => user,
                  builder: (context, _) => const SwitchPage(),
                );
        });
  }
}

class SwitchPage extends StatelessWidget {
  const SwitchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserTheahert?>(
      stream: GetIt.instance
          .get<Dorm>()
          .users
          .pull(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          switch (snapshot.data!.userType) {
            case "admin":
              return const AdminDashboard();
            case "client":
              return const ClientDashboard();
          }
        }
        return const Text("Erro ao encontrar usuário");
      },
    );
  }
}
