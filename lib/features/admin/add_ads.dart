import 'dart:io';

import 'package:arkan_aleiraq_five_app/features/admin/home.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../core/ navigation/navigation.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/widgets/app_bar.dart';

class AddAds extends StatelessWidget {
  const AddAds({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController tittleController = TextEditingController();
  static TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AddAdsSuccessState){
            AppCubit.get(context).selectedImages=[];
            tittleController.text='';
            descController.text='';
            showToastSuccess(
              text: "تمت العملية بنجاح",
              context: context,
            );
            navigateAndFinish(context, HomeAdmin());
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body:SingleChildScrollView(
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
                            const SizedBox(height: 20),
                            GestureDetector(
                                onTap:(){
                                  cubit.pickImages();
                                },
                                child:
                                cubit.selectedImages.isEmpty?
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    border: Border.all(color: primaryColor, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor,
                                        blurRadius: 12,
                                        offset: Offset(0, 0),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "اختيار صورة",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ):Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipOval(
                                    child: Image.file(
                                      File(cubit.selectedImages[0].path),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: tittleController,
                              hintText: 'العنوان',
                              prefixIcon: Icons.title,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل العنوان';
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: descController,
                              hintText: 'الوصف',
                              prefixIcon: Icons.description_outlined,
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل الوصف';
                                }
                              },
                            ),
                            const SizedBox(height: 60),
                            ConditionalBuilder(
                              condition: state is !AddAdsLoadingState,
                              builder: (context){
                                return GestureDetector(
                                  onTap: (){
                                    if (formKey.currentState!.validate()) {
                                        cubit.addAds(
                                          tittle: tittleController.text.trim(),
                                          desc: descController.text.trim(),
                                          context: context,
                                        );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(width: 50,),
                                        Text('انشاء اعلان',
                                          style: TextStyle(color: Colors.white,fontSize: 16 ),),
                                        Container(
                                          margin: EdgeInsets.all(6),
                                          height: double.maxFinite,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              borderRadius:  BorderRadius.circular(12),
                                              color: Colors.white
                                          ),
                                          child: Icon(Icons.arrow_forward_ios_outlined,size: 22,color: primaryColor,),
                                        ),
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
