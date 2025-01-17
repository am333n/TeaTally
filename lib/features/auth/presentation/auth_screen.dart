import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:teatally/core/styles/text/txt.dart';
import 'package:teatally/core/theme/presentation/app_theme.dart';
import 'package:teatally/core/widgets/common_widgets.dart';
import 'package:teatally/core/widgets/form_components.dart';
import 'package:teatally/features/auth/application/cubit/auth_cubit.dart';
import 'package:teatally/features/auth/application/cubit/auth_state.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CommonWidgets.modelProgressIndicator(
          inAsyncCall: state.maybeWhen(
            orElse: () => false,
            authloadingState: () => true,
          ),
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/bevimages/tealogo.png',
                        height: 160,
                        width: double.maxFinite,
                      ),
                      const Txt(
                        'TeaTally',
                        style: TxtStyle.headerLBold,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: context.theme.dialogBackgroundColor,
                  padding: EdgeInsets.all(15),
                  child: FormBuilder(
                    key: _formkey,
                    child: Column(
                      children: [
                        FormComponents.formBuilderTextField(context,
                            fieldName: 'email',
                            label: 'Email',
                            hintText: 'example@mail.com',
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ],
                            isRequired: true),
                        PasswordTextField(
                          fieldName: 'pass',
                        ),
                        state.maybeWhen(
                          orElse: () => const SizedBox.shrink(),
                          authErrorState: (errorMessage) => Padding(
                            padding: const EdgeInsets.all(15),
                            child: Txt(
                              errorMessage ?? '-',
                              color: context.theme.appColors.danger,
                              maxLines: 3,
                            ),
                          ),
                        ),
                        VerticalSpacing(15),
                        CommonWidgets.coloredTextButton(context, text: 'Login',
                            onPressed: () {
                          if (_formkey.currentState?.validate() ?? false) {
                            final email =
                                _formkey.currentState?.fields['email']?.value;
                            final password =
                                _formkey.currentState?.fields['pass']?.value;
                            context
                                .read<AuthCubit>()
                                .signInWithEmailAndPassowrd(email, password);
                          }
                        }),
                        VerticalSpacing(15),
                        CommonWidgets.coloredTextButton(context,
                            text: 'Sign In With Google', onPressed: () {
                          context.read<AuthCubit>().signInWithGoogle();
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.fieldName,
  });
  final String fieldName;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordVisibile = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormComponents.formBuilderTextField(context,
          fieldName: widget.fieldName,
          label: 'Password',
          obscureText: isPasswordVisibile ? false : true,
          hintText: 'Password',
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisibile = !isPasswordVisibile;
                });
              },
              icon: Icon(
                isPasswordVisibile ? Icons.visibility_off : Icons.visibility,
                color: Theme.of(context).appColors.fontPrimary.withOpacity(0.4),
              )),
          isRequired: true),
    );
  }
}
