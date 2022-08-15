import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:theahert/models/models.dart';

class _UserFormBloc extends FormBloc<UserCredential, FirebaseAuthException> {
  late final TextFieldBloc<String> email;
  late final TextFieldBloc<String> password;
  late final TextFieldBloc<String> firstName;
  late final TextFieldBloc<String> lastName;
  late final TextFieldBloc<String> phoneNumber;
  late final TextFieldBloc<String> userType;

  _UserFormBloc() {
    firstName = TextFieldBloc(
        name: 'firstName', validators: [FieldBlocValidators.required]);

    lastName = TextFieldBloc(
        name: 'lastName', validators: [FieldBlocValidators.required]);

    phoneNumber = TextFieldBloc(
      name: 'phoneNumber',
    );

    userType = TextFieldBloc(
      name: 'userType',
    );

    email = TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.required, FieldBlocValidators.email]);

    password = TextFieldBloc(
      name: 'password',
      validators: [FieldBlocValidators.required],
    );

    addFieldBlocs(
        fieldBlocs: [firstName, lastName, phoneNumber, email, password]);
  }

  @override
  Future<void> onSubmitting() async {
    final String email = this.email.value;
    final String password = this.password.value;

    try {
      UserCredential newUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return emitSuccess(successResponse: newUser);
    } on FirebaseAuthException catch (e) {
      return emitFailure(failureResponse: e);
    }
  }
}

class UserFormScreen extends StatelessWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  Future<UserTheahert?> saveUserGeevo(UserTheahert userTheahert) async {
    await GetIt.instance.get<Dorm>().users.push(userTheahert);
    return await GetIt.instance.get<Dorm>().users.peek(userTheahert.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _UserFormBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Cadastrar Cliente"),
              centerTitle: true,
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Consumer<_UserFormBloc>(
                builder: (context, bloc, _) {
                  return FormBlocListener<_UserFormBloc, UserCredential,
                      FirebaseAuthException>(
                    formBloc: bloc,
                    onSuccess: (context, success) async {
                      if (success.successResponse != null) {
                        UserCredential? userCredential =
                            success.successResponse;

                        UserTheahert userTheahert = UserTheahert(
                          id: userCredential!.user!.uid,
                          firstName: bloc.firstName.value,
                          lastName: bloc.lastName.value,
                          email: bloc.email.value,
                          phoneNumber: bloc.phoneNumber.value,
                          userType: "client",
                        );

                        await saveUserGeevo(userTheahert);

                        Navigator.pop(context);
                      }
                    },
                    onFailure: (context, failure) async {
                      if (failure.failureResponse != null) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red[400],
                          content: Text(
                            'Erro : ${failure.failureResponse?.message.toString()}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 10),
                                  TextFieldBlocBuilder(
                                    textFieldBloc: bloc.firstName,
                                    keyboardType: TextInputType.name,
                                    autofillHints: const [AutofillHints.name],
                                    decoration: const InputDecoration(
                                      hintText: "Primeiro Nome",
                                    ),
                                    errorBuilder: (context, error) {
                                      switch (error) {
                                        case FieldBlocValidatorsErrors.required:
                                          return "Insira este campo.";
                                        case FieldBlocValidatorsErrors.email:
                                          return "O Nome inserido é inválido.";
                                      }
                                      if (error is String) return error;
                                      throw error;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFieldBlocBuilder(
                                    textFieldBloc: bloc.lastName,
                                    keyboardType: TextInputType.name,
                                    autofillHints: const [AutofillHints.name],
                                    decoration: const InputDecoration(
                                      hintText: "Último Nome",
                                    ),
                                    errorBuilder: (context, error) {
                                      switch (error) {
                                        case FieldBlocValidatorsErrors.required:
                                          return "Insira este campo.";
                                        case FieldBlocValidatorsErrors.email:
                                          return "O Nome inserido é inválido.";
                                      }
                                      if (error is String) return error;
                                      throw error;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 10),
                                  TextFieldBlocBuilder(
                                    textFieldBloc: bloc.phoneNumber,
                                    keyboardType: TextInputType.number,
                                    autofillHints: const [
                                      AutofillHints.telephoneNumberDevice
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: "Número de Telefone",
                                    ),
                                    errorBuilder: (context, error) {
                                      switch (error) {
                                        case FieldBlocValidatorsErrors.required:
                                          return "Insira este campo.";
                                        case FieldBlocValidatorsErrors.email:
                                          return "O Nome inserido é inválido.";
                                      }
                                      if (error is String) return error;
                                      throw error;
                                    },
                                  ),
                                  TextFieldBlocBuilder(
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
                                    textFieldBloc: bloc.password,
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: MaterialButton(
                                minWidth: size.width * 0.7,
                                onPressed: () async {
                                  bloc.submit();
                                },
                                color: Colors.blue,
                                child: const Text(
                                  "Salvar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserResetFormBloc extends FormBloc<bool, bool> {
  late final TextFieldBloc<String> email;
  _UserResetFormBloc() {
    email = TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.required, FieldBlocValidators.email]);

    addFieldBlocs(fieldBlocs: [email]);
  }

  @override
  Future<void> onSubmitting() async {
    final String email = this.email.value;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      return emitSuccess(successResponse: true);
    } on FirebaseAuthException catch (e) {
      return emitFailure(failureResponse: true);
    }
  }
}

class UserResetFormScreen extends StatelessWidget {
  const UserResetFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _UserResetFormBloc(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Redefinir Senha"),
              centerTitle: true,
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Consumer<_UserResetFormBloc>(
                builder: (context, bloc, _) {
                  return FormBlocListener<_UserResetFormBloc, bool, bool>(
                    formBloc: bloc,
                    onSuccess: (context, success) async {
                      if (success.successResponse == true) {
                        Navigator.pop(context, true);
                      }
                    },
                    onFailure: (context, failure) async {
                      if (failure.failureResponse == true) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red[400],
                          content: const Text(
                            'Erro na solicitação. Verifique o campo Email!',
                            style: TextStyle(fontSize: 18),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    TextFieldBlocBuilder(
                                      textFieldBloc: bloc.email,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                      ),
                                      errorBuilder: (context, error) {
                                        switch (error) {
                                          case FieldBlocValidatorsErrors
                                              .required:
                                            return "Insira este campo.";
                                          case FieldBlocValidatorsErrors.email:
                                            return "O e-mail inserido é inválido.";
                                        }
                                        if (error is String) return error;
                                        throw error;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 30),
                                    MaterialButton(
                                      onPressed: () async {
                                        bloc.submit();
                                      },
                                      color: Colors.blue,
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Redefinir Senha",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
