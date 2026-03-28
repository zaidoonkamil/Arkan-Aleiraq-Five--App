import 'package:arkan_aleiraq_five_app/core/widgets/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/themes.dart';
import '../../core/ navigation/navigation.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/network/remote/dio_helper.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/show_toast.dart';
import 'home.dart';
import 'video_player_screen.dart';

class DetailsUser extends StatelessWidget {
  const DetailsUser({super.key, required this.id, required this.tittle,
    required this.videoUrl, required this.images, required this.productIndex,
    this.attachedVideos, this.attachedImages, required this.colors, required this.size,});

  static CarouselController carouselController = CarouselController();

  static int currentIndex = 0;
  final int productIndex;
  final int id;
  final String tittle;
  final String colors;
  final String size;
  final List<String>? videoUrl;
  final List<String>? images;
  final List<String>? attachedVideos;
  final List<String>? attachedImages;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(state is UpdateVariantsSuccessState){
              showToastSuccess(
                text: 'تم الامر بنجاح',
                context: context,
              );
              navigateAndFinish(context, HomeUser());
            }
          },
          builder: (context, state) {
            var cubit=AppCubit.get(context);
            return WillPopScope(
              onWillPop: () async {
                navigateAndFinish(context, HomeUser());
                return false;
              },
              child: SafeArea(
                child: Scaffold(
                  body: Stack(
                    children: [
                      Column(
                          children: [
                            CustomAppBarBack(),
                            SizedBox(height: 12,),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 373,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                      child: Stack(
                                        children: [
                                          CarouselSlider(
                                            items:images!.map((entry) {
                                              double? progress = cubit.mediaDownloadProgress[entry];
                                              bool isDownloading = progress != null;
                                              return Builder(
                                                builder: (BuildContext context) {
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
                                                              child: Image.network("$url/uploads/${entry}", fit: BoxFit.contain),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      width: double.maxFinite,
                                                      child: Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(16.0),
                                                            child: Image.network(
                                                              "$url/uploads/$entry",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 10,
                                                            right: 10,
                                                            child: isDownloading
                                                                ? Container(
                                                                    padding: const EdgeInsets.all(4),
                                                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                    child: Stack(
                                                                      alignment: Alignment.center,
                                                                      children: [
                                                                        CircularProgressIndicator(value: progress, strokeWidth: 3, color: primaryColor),
                                                                        Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () => cubit.downloadMediaOnly(context: context, mediaUrl: entry, isVideo: false),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(4),
                                                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                      child: Icon(Icons.download, color: primaryColor, size: 24),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              height: 343,
                                              viewportFraction: 0.94,
                                              enlargeCenterPage: true,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: true,
                                              autoPlay: true,
                                              autoPlayInterval: const Duration(seconds: 6),
                                              autoPlayAnimationDuration:
                                              const Duration(seconds: 1),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                currentIndex=index;
                                                cubit.slid();

                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 16),
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: images!.asMap().entries.map((entry) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    carouselController.animateTo(
                                                      entry.key.toDouble(),
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: currentIndex == entry.key ? 8 : 8,
                                                    height: 7.0,
                                                    margin: const EdgeInsets.symmetric(
                                                      horizontal: 3.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: currentIndex == entry.key
                                                            ? primaryColor
                                                            : Colors.white),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: SizedBox(
                                        height: 120,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          reverse: true,
                                          children: [
                                            if (videoUrl != null)
                                              ...videoUrl!.map((vid) {
                                                double? progress = cubit.mediaDownloadProgress[vid];
                                                bool isDownloading = progress != null;
                                                return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoUrl: vid)));
                                                },
                                                child: Container(
                                                  width: 120,
                                                  margin: const EdgeInsets.only(left: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: Colors.grey.shade300),
                                                    color: Colors.black12,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Image.asset('assets/images/$logo',width: 120,height: 120,),
                                                      Positioned(
                                                          left: 0,
                                                          right: 0,
                                                          top: 0,
                                                          bottom: 0,
                                                          child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white)),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: isDownloading
                                                            ? Container(
                                                                padding: const EdgeInsets.all(4),
                                                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                child: Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    CircularProgressIndicator(value: progress, strokeWidth: 3, color: primaryColor),
                                                                    Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () => cubit.downloadMediaOnly(context: context, mediaUrl: vid, isVideo: true),
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(4),
                                                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                  child: Icon(Icons.download, color: primaryColor, size: 24),
                                                                ),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );}).toList(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  tittle,
                                                  style: TextStyle(fontSize: 20, color: Colors.black87),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  size,
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  colors,
                                                  style: TextStyle(fontSize: 12, color: Colors.black87),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20,),
                                          if ((attachedImages != null && attachedImages!.isNotEmpty) || (attachedVideos != null && attachedVideos!.isNotEmpty))
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "تجارب : صور + فيديوات",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  height: 120,
                                                  child: ListView(
                                                    scrollDirection: Axis.horizontal,
                                                    reverse: true,
                                                    children: [
                                                      if (attachedImages != null)
                                                        ...attachedImages!.map((img) {
                                                          double? progress = cubit.mediaDownloadProgress[img];
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
                                                                    child: Image.network("$url/uploads/${img.trim()}", fit: BoxFit.contain),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 120,
                                                            margin: const EdgeInsets.only(left: 10),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey.shade300),
                                                            ),
                                                            child: Stack(
                                                              fit: StackFit.expand,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  child: Image.network(
                                                                    "$url/uploads/$img",
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, error, stackTrace) =>
                                                                        const Icon(Icons.broken_image, color: Colors.grey),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: isDownloading
                                                                      ? Container(
                                                                          padding: const EdgeInsets.all(4),
                                                                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                          child: Stack(
                                                                            alignment: Alignment.center,
                                                                            children: [
                                                                              CircularProgressIndicator(value: progress, strokeWidth: 3, color: primaryColor),
                                                                              Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap: () => cubit.downloadMediaOnly(context: context, mediaUrl: img, isVideo: false),
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(4),
                                                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                            child: Icon(Icons.download, color: primaryColor, size: 24),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );}).toList(),
                                                      if (attachedVideos != null)
                                                        ...attachedVideos!.map((vid) {
                                                          double? progress = cubit.mediaDownloadProgress[vid];
                                                          bool isDownloading = progress != null;
                                                          return GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoUrl: vid)));
                                                          },
                                                          child: Container(
                                                            width: 120,
                                                            margin: const EdgeInsets.only(left: 10),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey.shade300),
                                                              color: Colors.black12,
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Image.asset('assets/images/$logo',width: 120,height: 120,),
                                                                Positioned(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0,
                                                                    child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white)),
                                                                Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: isDownloading
                                                                      ? Container(
                                                                          padding: const EdgeInsets.all(4),
                                                                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                          child: Stack(
                                                                            alignment: Alignment.center,
                                                                            children: [
                                                                              CircularProgressIndicator(value: progress, strokeWidth: 3, color: primaryColor),
                                                                              Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap: () => cubit.downloadMediaOnly(context: context, mediaUrl: vid, isVideo: true),
                                                                          child: Container(
                                                                            padding: const EdgeInsets.all(4),
                                                                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                                                            child: Icon(Icons.download, color: primaryColor, size: 24),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );}).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SizedBox(height: 20,),
                                      ]),
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
