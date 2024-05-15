import 'package:city/model/user.dart';
import 'package:city/services/user_service.dart';
import 'package:city/utils/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userService = UserService();

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  String? errorMessage;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade500,
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      errorMessage = null;
    });
    _isLoading = true;

    try {
      await Auth().signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      showSnackbar("Login realizado com sucesso!");
      Navigator.of(context).pushReplacementNamed('/home');
    } on Firebase.FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Email ou senha incorreto';
      });
    } finally {
      _isLoading = false;
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      errorMessage = null;
    });
    _isLoading = true;

    try {
      var response = await Auth().createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      _userService.saveUser(
          User(id: response.user!.uid, email: _email.text, name: _name.text));

      showSnackbar("Usuário criado com sucesso!");
      Navigator.of(context).pushReplacementNamed('/home');
    } on Firebase.FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Já existe uma conta com este email';
        }
      });
    } finally {
      _isLoading = false;
    }
  }

  onSubmit() {
    if (_isLoading) {
      return null;
    }

    if (_isLogin) {
      return signInWithEmailAndPassword;
    }

    return createUserWithEmailAndPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 82,
                  ),
                  const Icon(
                    Icons.location_city,
                    size: 100,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text("City App",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(
                    height: 54,
                  ),
                  if (!_isLogin)
                    _buildInput(
                        controller: _name,
                        hintText: "Nome",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Campo obrigatório";
                          }

                          return null;
                        }),
                  if (!_isLogin)
                    const SizedBox(
                      height: 18,
                    ),
                  _buildInput(
                      controller: _email,
                      hintText: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obrigatório";
                        }

                        if (!EmailValidator.validate(value)) {
                          return "Email inválido";
                        }

                        return null;
                      }),
                  const SizedBox(
                    height: 18,
                  ),
                  _buildInput(
                      controller: _password,
                      hintText: "Senha",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obrigatório";
                        }

                        return null;
                      },
                      errorMessage: errorMessage),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSubmit(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(_isLogin ? "Entrar" : "Criar"),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          "OU",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLogin)
                        Text(
                          "Não tem uma conta?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.outline,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      TextButton(
                        onPressed: !_isLoading
                            ? () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              }
                            : null,
                        child: Text(_isLogin ? "Crie agora" : "Fazer login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      {required TextEditingController controller,
      required String hintText,
      bool obscureText = false,
      String? Function(String?)? validator,
      String? errorMessage}) {
    return TextFormField(
      enabled: !_isLoading,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        errorText: errorMessage,
        hintText: hintText,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
