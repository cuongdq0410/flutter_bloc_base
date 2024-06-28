import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skyway_example/ui/base/base_screen.dart';
import 'package:flutter_skyway_example/ui/widget/app_navigator.dart';
import 'package:flutter_skyway_example/ui/widget/common_button.dart';
import 'package:flutter_skyway_example/ui/widget/route_define.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_skyway_example/gen/assets.gen.dart';

import '../bloc/login_bloc.dart';

class LoginScreen extends BaseScreen {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen, LoginBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildContent(BuildContext context) {
    return BlocListener(
      bloc: bloc,
      listener: (context, state) {
        if (state == const LoginState.loginSuccess()) {
          AppNavigator.navigateTo(
            context,
            RouteDefine.homeScreen.name,
            stackAction: NavigatorStackAction.removeAll,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Assets.logo.iconText.svg(
                    width: 150,
                  ),
                ),
                const SizedBox(height: 45),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(text: 'Email'),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        style: Theme.of(context)
                            .inputDecorationTheme
                            .labelStyle
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        validator: MultiValidator(
                          [
                            RequiredValidator(
                              errorText: 'Enter email address',
                            ),
                            EmailValidator(
                                errorText: 'Please correct email filled'),
                          ],
                        ).call,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(),
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                        const TextSpan(
                          children: [
                            TextSpan(text: 'Password'),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        style: Theme.of(context)
                            .inputDecorationTheme
                            .labelStyle
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passController,
                        validator: MultiValidator(
                          [
                            RequiredValidator(
                                errorText: 'Please enter Password'),
                            MinLengthValidator(8,
                                errorText: 'Password must be at least 8 digit'),
                          ],
                        ).call,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(),
                      ),
                      const SizedBox(height: 20),
                      CommonButton(
                        onTap: () {
                          bloc.add(
                            LoginEvent.login(
                              _emailController.text,
                              _passController.text,
                            ),
                          );
                        },
                        text: 'Login',
                        borderRadius: 8,
                        buttonHeight: 42,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  afterBuild() {}
}
