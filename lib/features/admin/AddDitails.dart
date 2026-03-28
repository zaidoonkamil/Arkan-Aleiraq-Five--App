import 'package:arkan_aleiraq_five_app/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq_five_app/features/admin/home.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/show_toast.dart';


class AddDitails extends StatefulWidget {
  const AddDitails({super.key, required this.desc});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController descController = TextEditingController();
  static bool isValidationPassed = false;
  final String desc;

  @override
  State<AddDitails> createState() => _AddDitailsState();
}

class _AddDitailsState extends State<AddDitails> {

  @override
  void initState() {
    AddDitails.descController.text=widget.desc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is UpdateDescSuccessState){
            navigateAndFinish(context, HomeAdmin());
            showToastSuccess(text: 'تمت العملية بنجاح', context: context);
          }
        },
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
                        key: AddDitails.formKey,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('افصل بين كل حقل بمسافتين')
                              ],
                            ),
                            SizedBox(height: 12,),
                            CustomTextField(
                              hintText: 'التفاصيل',
                              controller: AddDitails.descController,
                              keyboardType: TextInputType.text,
                              maxLines: 7,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل الاسم';
                                }
                              },
                            ),
                            const SizedBox(height: 60),
                            ConditionalBuilder(
                              condition: state is !UpdateDescLoadingState,
                              builder: (c){
                                return GestureDetector(
                                  onTap: (){
                                    if (AddDitails.formKey.currentState!.validate()) {
                                      cubit.updateDesc(
                                        content: AddDitails.descController.text.trim(),
                                          context: context,
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
                                        Text('ارسال',
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
