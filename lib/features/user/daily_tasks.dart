import 'package:arkan_aleiraq_five_app/core/widgets/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/network/remote/dio_helper.dart';
import '../../core/styles/themes.dart';
import '../../core/widgets/app_bar.dart';
import 'video_player_screen.dart';

class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({Key? key}) : super(key: key);

  static CarouselController carouselController = CarouselController();
  static int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getDailyTask(context: context, userId: id),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var task = cubit.dailyTask;

          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  const CustomAppBarBack(),
                  if (state is GetDailyTaskLoadingState && task == null)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (task == null || task.product == null)
                    const Expanded(child: Center(child: Text("لا توجد مهام حالياً")))
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            if (task.isCompleted)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green)
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text("تم إكمال جميع مهام التحميل بنجاح", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ),
                            Container(
                              height: 373,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                              child: Stack(
                                children: [
                                  if (task.product!.images.isNotEmpty)
                                    CarouselSlider(
                                      items: task.product!.images.map((entry) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              width: double.maxFinite,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: Image.network(
                                                  "$url/uploads/${entry.trim()}",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
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
                                        autoPlayAnimationDuration: const Duration(seconds: 1),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          currentIndex = index;
                                          cubit.slid();
                                        },
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: (task.product!.images ?? []).asMap().entries.map((entry) {
                                        return GestureDetector(
                                          onTap: () {
                                            carouselController.animateTo(
                                              entry.key.toDouble(),
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: Container(
                                            width: currentIndex == entry.key ? 8.0 : 8.0,
                                            height: 7.0,
                                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey, width: 1.0),
                                              borderRadius: BorderRadius.circular(10),
                                              color: currentIndex == entry.key ? primaryColor : Colors.white
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (task.product!.videoLinks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: SizedBox(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    children: task.product!.videoLinks.map((vid) => GestureDetector(
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
                                            Image.asset('assets/images/$logo', width: 120, height: 120),
                                            const Positioned.fill(
                                              child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white)
                                            ),
                                          ],
                                        ),
                                      ),
                                    )).toList(),
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
                                          task.product!.description ?? "",
                                          style: const TextStyle(fontSize: 20, color: Colors.black87),
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
                                          task.product!.size ?? "",
                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
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
                                          task.product!.colors ?? "",
                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  if ((task.product!.attachedImages.isNotEmpty) ||
                                      (task.product!.attachedVideos.isNotEmpty))
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
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
                                              ...task.product!.attachedImages.map((img) {
                                                bool isDownloaded = task.downloadedMedia.contains(img) || task.isCompleted;
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
                                                            "$url/uploads/${img.trim()}",
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) =>
                                                                const Icon(Icons.broken_image, color: Colors.grey),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 5,
                                                          right: 5,
                                                          child: isDownloaded
                                                              ? const Icon(Icons.check_circle, color: Colors.green, shadows: [Shadow(color: Colors.white, blurRadius: 4)])
                                                              : isDownloading
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
                                                                      onTap: () => cubit.downloadTaskMedia(context: context, taskId: task.id, mediaUrl: img, isVideo: false),
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
                                              }),
                                              if (task.product!.attachedVideos != null)
                                                ...task.product!.attachedVideos!.map((vid) {
                                                  bool isDownloaded = task.downloadedMedia.contains(vid) || task.isCompleted;
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
                                                          Image.asset('assets/images/$logo', width: 120, height: 120),
                                                          const Positioned.fill(
                                                            child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white)
                                                          ),
                                                          Positioned(
                                                            top: 5,
                                                            right: 5,
                                                            child: isDownloaded
                                                                ? const Icon(Icons.check_circle, color: Colors.green, shadows: [Shadow(color: Colors.white, blurRadius: 4)])
                                                                : isDownloading
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
                                                                        onTap: () => cubit.downloadTaskMedia(context: context, taskId: task.id, mediaUrl: vid, isVideo: true),
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
                                                }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
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
