import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/show_toast.dart';
import '../auth/cubit/cubit.dart';
import '../auth/cubit/states.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is SignUpSuccessState){
            userNameController.text='';
            phoneController.text='';
            passwordController.text='';
            showToastSuccess(text: 'تم انشاء المستقبل بنجاح', context: context);
          }
        },
        builder: (context,state){
          var cubit=LoginCubit.get(context);
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
                            CustomTextField(
                              hintText: 'الاسم',
                              controller: userNameController,
                              keyboardType: TextInputType.text,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل الاسم';
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'رقم الهاتف',
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل رقم الهاتف';
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'كلمة السر',
                              controller: passwordController,
                              obscureText: cubit.isPasswordHidden,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  cubit.togglePasswordVisibility();
                                },
                                child: Icon(
                                  cubit.isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل الرمز السري';
                                }
                              },
                            ),
                            const SizedBox(height: 60),
                            ConditionalBuilder(
                              condition: state is !SignUpLoadingState,
                              builder: (c){
                                return GestureDetector(
                                  onTap: (){
                                    if (formKey.currentState!.validate()) {
                                      cubit.signUp(
                                          phone: phoneController.text.trim(),
                                          password: passwordController.text.trim(),
                                          name: userNameController.text.trim(),
                                          context: context,
                                          role: 'user'
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    decoration: BoxDecoration(
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('انشاء الحساب',
                                          style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                            ),
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
