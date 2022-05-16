import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';

import '../models/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum AuthMode { signup, login }

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250,
      ),
    );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));
    // _heightAnimation?.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.login;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _controller?.forward();
        _authMode = AuthMode.signup;
      } else {
        _controller?.reverse();
        _authMode = AuthMode.login;
      }
    });
  }

  _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ocorreu um erro'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'))
            ],
          );
        });
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    final auth = Provider.of<Auth>(context, listen: false);

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    try {
      if (_isLogin()) {
        await auth.signIn(_authData['email']!, _authData['password']!);
      } else {
        await auth.signUp(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (err) {
      _showErrorDialog(err.toString());
    } catch (err) {
      _showErrorDialog('Ocorreu um erro inesperado.');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        // height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';

                  if (email.trim().isEmpty || !email.trim().contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.trim().isEmpty || password.trim().length < 5) {
                    return 'Informe uma senha válida!';
                  }
                  return null;
                },
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                constraints: BoxConstraints(
                    minHeight: _isLogin() ? 0 : 60,
                    maxHeight: _isLogin() ? 0 : 120),
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirmar senha'),
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (_password) {
                              final password = _password ?? '';
                              if (password != _passwordController.text) {
                                return 'As senhas informadas não conferem';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                    ),
                    child: Text(_isLogin() ? 'ENTRAR' : 'CADASTRAR')),
              const Spacer(),
              TextButton(
                  onPressed: _switchAuthMode,
                  child: const Text('Não possui login?'))
            ],
          ),
        ),
      ),
    );
  }
}
