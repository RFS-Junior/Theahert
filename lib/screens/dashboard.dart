import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theahert/models/models.dart';
import 'package:theahert/services/sqlite.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Cliente"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
        ],
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Dashboard Cliente",
                style: TextStyle(fontSize: 35),
              ),
              FutureBuilder<List<UserTheahert>?>(
                  future: const SQLiteDatabase().selectUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: 400,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Text(
                                              "Primeiro nome: ${snapshot.data![index].firstName}")),
                                      Center(
                                          child: Text(
                                              "Último nome: ${snapshot.data![index].lastName}")),
                                      Center(
                                          child: Text(
                                              "Email: ${snapshot.data![index].email}")),
                                      Center(
                                          child: Text(
                                              "Número de Celular: ${snapshot.data![index].phoneNumber.toString()}")),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return const Text("No data");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
        ],
      ),
      body: const Text("Dashboard Admin"),
    );
  }
}
