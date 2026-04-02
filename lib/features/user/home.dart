import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/constant.dart';
import '../../core/ navigation/navigation.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/model/GetAdsModel.dart' show GetAds;
import '../../core/network/remote/dio_helper.dart';
import '../../core/styles/themes.dart';
import 'daily_tasks.dart';
import 'details.dart';


class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  static ScrollController? scrollController;
  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getProducts(context: context)
        ..getAds(context: context)
        ..getDesc(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  CustomAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                            child: ConditionalBuilder(
                              condition:cubit.getAdsModel.isNotEmpty,
                              builder:(c){
                                return Stack(
                                  children: [
                                    CarouselSlider(
                                      items: cubit.getAdsModel.isNotEmpty
                                          ? cubit.getAdsModel.expand<Widget>((GetAds ad) =>
                                          ad.images.map<Widget>((String imageUrl) => Builder(
                                            builder: (BuildContext context) {
                                              double? progress = cubit.mediaDownloadProgress[imageUrl];
                                              bool isDownloading = progress != null;
                                              return GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Dialog(
                                                      backgroundColor: Colors.transparent,
                                                      insetPadding: const EdgeInsets.all(10),
                                                      child: GestureDetector(
                                                        onTap: () => Navigator.pop(context),
                                                        child: InteractiveViewer(
                                                          child: Image.network("$url/uploads/${imageUrl}", fit: BoxFit.contain),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },

                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: primaryColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.network(
                                                          "$url/uploads/$imageUrl",
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 8,
                                                        right: 8,
                                                        child: isDownloading
                                                            ? Container(
                                                                padding: const EdgeInsets.all(4),
                                                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                child: Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    CircularProgressIndicator(value: progress, strokeWidth: 3, color: primaryColor),
                                                                    Text(
                                                                      "${(progress * 100).toInt()}%",
                                                                      style: const TextStyle(fontSize: 9, color: primaryColor, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () => cubit.downloadMediaOnly(context: context, mediaUrl: imageUrl, isVideo: false),
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(4),
                                                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                  child: Icon(Icons.download, color: primaryColor, size: 22),
                                                                ),
                                                              ),
                                                      ),
                                                    ],
                                                    ),
                                                  ),
                                              );
                                            },
                                          )),
                                      ).toList()
                                          : <Widget>[],
                                      options: CarouselOptions(
                                        height: 156,
                                        viewportFraction: 0.94,
                                        enlargeCenterPage: true,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: true,
                                        autoPlay: true,
                                        autoPlayInterval: const Duration(seconds: 6),
                                        autoPlayAnimationDuration: const Duration(seconds: 1),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          currentIndex = index;
                                          cubit.slid();
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: cubit.getAdsModel.asMap().entries.map((entry) {
                                          return Container(
                                            width: 8,
                                            height: 7.0,
                                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: currentIndex == entry.key
                                                  ? secondPrimaryColor.withOpacity(0.8)
                                                  : Colors.white,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              fallback: (c)=> Container(),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      navigateTo(context, DailyTasksScreen());
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 40,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                        color: primaryColor,
                                      ),
                                      child: Center(child: Text('المهام اليومية',style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6,),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      signOut(context);
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 40,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                        color: Colors.redAccent,
                                      ),
                                      child: Center(child: Text('تسجيل الخروج',style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          state is! GetProductsLoadingState?
                          cubit.getProductsModel.isNotEmpty?
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                                itemCount: cubit.getProductsModel.length,
                                itemBuilder:(context,index){
                                  final imgs = cubit.getProductsModel[index].images;
                                  if (imgs.isEmpty) return const SizedBox.shrink();
                                  String rawImageUrl = imgs[0];
                                  String cleanImageUrl = rawImageUrl.replaceAll(RegExp(r'[\[\]]'), '');
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          navigateTo(context, DetailsUser(
                                              productIndex: index,
                                              id: cubit.getProductsModel[index].id,
                                              tittle: cubit.getProductsModel[index].description,
                                              videoUrl: cubit.getProductsModel[index].videoLinks,
                                              images: cubit.getProductsModel[index].images,
                                            attachedVideos: cubit.getProductsModel[index].attachedVideos,
                                            attachedImages: cubit.getProductsModel[index].attachedImages,
                                            colors: cubit.getProductsModel[index].colors,
                                            size: cubit.getProductsModel[index].size,
                                          ));
                                        },
                                        child: Container(
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
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      cubit.getProductsModel[index].description,
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      cubit.getProductsModel[index].size,
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      cubit.getProductsModel[index].colors,
                                                      style: TextStyle(fontSize: 14),
                                                      textAlign: TextAlign.end,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 6,),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(
                                                  '$url/uploads/$cleanImageUrl',
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6,),
                                    ],
                                  );
                              }),
                          ):Center(child: Text('لا يوجد بيانات')):
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
