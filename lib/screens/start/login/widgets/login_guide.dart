import 'package:flutter/material.dart';

class LoginGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Placeholder(
          fallbackWidth: 100,
          fallbackHeight: 100,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            '감자마켓은 휴대폰 번호로 가입해요. 번호는 안전하게 보관되며 어디에도 공개되지 않아요.',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
