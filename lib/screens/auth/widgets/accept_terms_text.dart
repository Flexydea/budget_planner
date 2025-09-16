import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AcceptTermsText extends StatelessWidget {
  const AcceptTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'I accept ',
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: 'Terms and Conditions',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // This will navigate using GoRouter
                context.push('/settings/terms');
              },
          ),
        ],
      ),
    );
  }
}
