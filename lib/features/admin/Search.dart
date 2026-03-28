import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/widgets/app_bar.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CustomAppBarBack(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 40,),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.easeOutBack,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Image.asset('assets/images/$logo',width: 60,height: 60,),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if (formKey.currentState!.validate()) {
                                      cubit.getProfile(context: context, name: userNameController.text.trim());
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('بحث',
                                          style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextField(
                                    hintText: 'الاسم',
                                    controller: userNameController,
                                    keyboardType: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'رجائا اخل الاسم';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            cubit.profileModel.isNotEmpty?
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                                itemCount: cubit.profileModel.length,
                                itemBuilder:(c,i){
                              return Card(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cubit.profileModel[i].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.phone, size: 18, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Text(cubit.profileModel[i].phone),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.admin_panel_settings, size: 18, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Text(
                                            cubit.profileModel[i].role,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: cubit.profileModel[i].role == "admin" ? Colors.red : Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      GestureDetector(
                                        onTap: (){
                                          cubit.deleteUser(idUser: cubit.profileModel[i].id.toString(), context: context);
                                        },
                                        child: Container(
                                          width: double.maxFinite,
                                          height: 40,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                            color: Colors.redAccent,
                                          ),
                                          child: Center(child: Text('حذف المستخدم',style: TextStyle(color: Colors.white),)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }):Container(),
                            const SizedBox(height: 40),
                          ],
                        ),
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
