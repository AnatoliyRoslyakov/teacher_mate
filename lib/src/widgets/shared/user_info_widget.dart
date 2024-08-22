import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teacher_mate/src/bloc/user_details_bloc/user_details_bloc.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class UserInfoWidget extends StatelessWidget {
  final bool mobile;
  const UserInfoWidget({
    super.key,
    this.mobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
      return Container(
        height: mobile ? 170 : 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.amber.withOpacity(1),
              Colors.amber.withOpacity(0.4)
            ]),
            color: Colors.amber.withOpacity(1)),
        child: Padding(
          padding: EdgeInsets.only(top: mobile ? 100 : 30, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                      backgroundColor: Colors.white, child: Icon(Icons.person)),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name,
                        style: AppTextStyle.b7f24,
                      ),
                      Row(
                        children: [
                          Text(
                            state.tgName,
                            style: AppTextStyle.b3f12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.telegram,
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
