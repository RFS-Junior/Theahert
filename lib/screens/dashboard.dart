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
              const Text("Dashboard Cliente"),
              FutureBuilder<List<UserTheahert>?>(
                  future: const SQLiteDatabase().getUsers(),
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
                              return Text(snapshot.data![index].email);
                            }),
                      );
                    }
                    return const Text("No data");
                  }),
              MaterialButton(
                color: Colors.green,
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ClientDashboard()));
                },
                child: const Text("ATUALIZAR"),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () async {
                  await const SQLiteDatabase().create(const UserTheahertData(
                      firstName: "abc",
                      lastName: "abc",
                      email: "abc",
                      phoneNumber: "abc",
                      userType: "abc"));
                  await const SQLiteDatabase().deleteAll();
                },
                child: const Text("REMOVE ALL"),
              ),
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
