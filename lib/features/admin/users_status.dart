import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/styles/themes.dart';
import '../../../core/widgets/app_bar.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';


class UsersStatus extends StatelessWidget {
  const UsersStatus({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserStatus(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CustomAppBarBack(),
                    SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          state is! GetUserStatusLoadingState?
                          cubit.userStatusModel != null?
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cubit.userStatusModel!.users.length,
                              itemBuilder:(context,index){
                                return Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: borderColor,
                                          width: 1.0,
                                        ),
                                        color: containerColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 80,height: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: cubit.userStatusModel!.users[index].hasCompletedAll == true ?Colors.green:Colors.red
                                            ),
                                            child: Center(
                                              child: Text(
                                                cubit.userStatusModel!.users[index].hasCompletedAll == true ? 'مكتمل':'لم يكمل',
                                                style: TextStyle(fontSize: 10,color: Colors.white),
                                                textAlign: TextAlign.end,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      cubit.userStatusModel!.users[index].id.toString(),
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '#',
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      cubit.userStatusModel!.users[index].name,
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),

                                                    Text(
                                                      ' : الاسم',
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      cubit.userStatusModel!.users[index].phone,
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),

                                                    Text(
                                                      ' : الهاتف',
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat('yyyy/MM/dd - hh:mm a').format(
                                                        cubit.userStatusModel!.users[index].tasks[0].createdAt,
                                                      ),
                                                      style: TextStyle(fontSize: 12),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                    Text(
                                                      ' : الانشاء',
                                                      style: TextStyle(fontSize: 12),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat('yyyy/MM/dd - hh:mm a').format(
                                                        cubit.userStatusModel!.users[index].tasks[0].updatedAt,
                                                      ),
                                                      style: TextStyle(fontSize: 12),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                    Text(
                                                      ' : اخر نشاط',
                                                      style: TextStyle(fontSize: 12),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),


                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6,),
                                  ],
                                );
                              }):Center(child: Text('لا يوجد بيانات')):
                          CircularProgressIndicator(color: primaryColor,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
