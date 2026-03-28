import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/show_toast.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/widgets/app_bar.dart';

class AllVideo extends StatelessWidget {
  const AllVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getVideosFromFolder(context: context, folderId: "28724494"),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body:Column(
                children: [
                  CustomAppBarBack(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 16,),
                          cubit.videos.isNotEmpty? Expanded(
                            child: ListView.builder(
                              itemCount: cubit.videos.length + (cubit.nextPageUrl != null ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == cubit.videos.length) {
                                  cubit.getVideosFromFolder(context: context, folderId: '26233367', loadMore: true);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(color: primaryColor),
                                    ),
                                  );
                                }


                                String formatDuration(int seconds) {
                                  final minutes = seconds ~/ 60;
                                  final remainingSeconds = seconds % 60;
                                  final minutesStr = minutes.toString().padLeft(2, '0');
                                  final secondsStr = remainingSeconds.toString().padLeft(2, '0');
                                  return "$minutesStr:$secondsStr";
                                }
                                var video = cubit.videos[index];
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: primaryColor.withOpacity(0.8),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(video.name, textAlign: TextAlign.end,style: TextStyle(color: Colors.white),),
                                                      if (video.duration != null)
                                                        Text(
                                                          "مدة المحاضرة: ${formatDuration(video.duration!)}",
                                                          style: TextStyle(fontSize: 12, color: Colors.white70),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    video.thumbnail!,
                                                    width: 100,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              onTap: () {
                                                final linkToCopy = video.playbackLink ?? '';
                                                if (linkToCopy.isNotEmpty) {
                                                  Clipboard.setData(ClipboardData(text: linkToCopy));
                                                  showToastSuccess(text: "تم نسخ الرابط!", context: context);
                                                } else {
                                                  showToastError(text: "الرابط غير متوفر", context: context);
                                                }
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: primaryColor,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.5,
                                                    )
                                                ),
                                                child: Text('نسخ الرابط',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6,),
                                  ],
                                );
                              },
                            ),
                          ):Expanded(child: Center(child: CircularProgressIndicator(color: primaryColor,))),
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
