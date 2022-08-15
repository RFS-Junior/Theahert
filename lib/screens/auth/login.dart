import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:theahert/models/models.dart';
import 'package:theahert/screens/auth/sign.dart';

class _LoginFormBloc extends FormBloc<String, String> {
  final TextFieldBloc<String> email = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.email],
  );
  final TextFieldBloc<String> password = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  _LoginFormBloc() {
    addFieldBlocs(fieldBlocs: [email, password]);
  }

  @override
  Future<void> onSubmitting() async {
    final String email = this.email.value;
    final String password = this.password.value;

    final AsyncSnapshot<UserCredential> snapshot = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((creds) => AsyncSnapshot.withData(ConnectionState.done, creds))
        .catchError((e) {
      return AsyncSnapshot<UserCredential>.withError(ConnectionState.done, e);
    }, test: (e) => e is FirebaseAuthException);

    if (snapshot.hasError) {
      final FirebaseAuthException e = snapshot.error as FirebaseAuthException;
      switch (e.code) {
        case "invalid-email":
          {
            this.email.addFieldError("O e-mail fornecido é inválido.");
            break;
          }
        case "user-disabled":
          {
            this.email.addFieldError("Essa conta foi desabilitada.");
            break;
          }
        case "user-not-found":
          {
            this.email.addFieldError("Não existe um usuário com este e-mail.");
            break;
          }
        case "wrong-password":
          {
            this.password.addFieldError("A senha fornecida é inválida.");
            break;
          }
      }
      return emitFailure();
    }
    return emitSuccess();
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> save(UserTheahertData userTheahertData) async {
    UserTheahert userTheahert = await GetIt.instance
        .get<Dorm>()
        .users
        .put(const UserTheahertDependency(), userTheahertData);
    if (userTheahert != null) print(userTheahert.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _LoginFormBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            body: Consumer<_LoginFormBloc>(
              builder: (context, bloc, _) {
                return FormBlocListener<_LoginFormBloc, String, String>(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  "Theahert",
                                  style: TextStyle(fontSize: 40),
                                )),
                            const SizedBox(height: 10),
                            TextFieldBlocBuilder(
                              textInputAction: TextInputAction.done,
                              textFieldBloc: bloc.email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                hintText: "Email",
                              ),
                              errorBuilder: (context, error) {
                                switch (error) {
                                  case FieldBlocValidatorsErrors.required:
                                    return "Insira este campo.";
                                  case FieldBlocValidatorsErrors.email:
                                    return "O e-mail inserido é inválido.";
                                }
                                if (error is String) return error;
                                throw error;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFieldBlocBuilder(
                              textInputAction: TextInputAction.done,
                              textFieldBloc: bloc.password,
                              autofillHints: const [AutofillHints.password],
                              suffixButton: SuffixButton.obscureText,
                              decoration: const InputDecoration(
                                hintText: "Senha",
                              ),
                              errorBuilder: (context, error) {
                                switch (error) {
                                  case FieldBlocValidatorsErrors.required:
                                    return "Insira este campo.";
                                  case FieldBlocValidatorsErrors.email:
                                    return "O e-mail inserido é inválido.";
                                }
                                if (error is String) return error;
                                throw error;
                              },
                            ),
                            const SizedBox(height: 30),
                            const SizedBox(height: 30),
                            MaterialButton(
                              onPressed: () {
                                bloc.submit();
                              },
                              color: Colors.blue,
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    bool teste = false;
                                    teste = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserResetFormScreen()),
                                    );
                                    if (teste == true) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.blue,
                                        content: const Text(
                                          'Solicitação enviada com sucesso. Verifique seu email!',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        action: SnackBarAction(
                                          textColor: Colors.white,
                                          label: 'OK',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text(
                                    "Esqueceu a senha?",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 1, 138, 119)),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserFormScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "Cadastrar Novo Usuário",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(150, 1, 138, 119)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
