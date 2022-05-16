import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 0.5),
                    Color.fromRGBO(255, 188, 117, .9)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Minha Loja',
                          style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'Anton',
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                        transform: Matrix4.rotationZ(-8 * pi / 180)
                          ..translate((-10.0)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 70),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const AuthForm(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
