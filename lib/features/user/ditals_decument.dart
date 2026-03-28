import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_bar.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/styles/themes.dart';


class DitalsDecument extends StatelessWidget {
  const DitalsDecument({super.key});

  static ScrollController? scrollController;
  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getDesc(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  CustomAppBarBack(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          cubit.details != null && cubit.details != '' ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                            padding: const EdgeInsets.all(8),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: borderColor,
                                width: 1.0,
                              ),
                              color: containerColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: cubit.details!.split('  ').map((e) => Text(e.trim())).toList(),
                            ),
                          ) :
                          CircularProgressIndicator(color: primaryColor,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
