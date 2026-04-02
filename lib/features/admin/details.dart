import 'package:arkan_aleiraq_five_app/core/widgets/constant.dart';
import 'package:arkan_aleiraq_five_app/features/admin/home.dart';
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
import '../user/video_player_screen.dart';


class DetailsAdmin extends StatelessWidget {
  DetailsAdmin({super.key, required this.id, required this.tittle,
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
  final List<String> mainImages = [];
  bool _imagesInitialized = false;

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
              navigateAndFinish(context, HomeAdmin());
            }
            if(state is UpdateProductDetailsSuccessState) {
              navigateAndFinish(context, HomeAdmin());
            }
            if(state is UpdateProductMediaSuccessState) {
              Navigator.pop(context); // close bottom sheet
              navigateAndFinish(context, HomeAdmin());
            }
            if(state is DeleteProductMediaSuccessState && state.type == 'images') {
              mainImages.remove(state.value);
              if (currentIndex >= mainImages.length && mainImages.isNotEmpty) {
                currentIndex = mainImages.length - 1;
              }
              if (mainImages.isEmpty) {
                currentIndex = 0;
              }
            }
            if(state is DeleteProductActionSuccessState) {
              navigateAndFinish(context, HomeAdmin());
            }
          },
          builder: (context, state) {
            var cubit=AppCubit.get(context);
            if(!_imagesInitialized && images != null && images!.isNotEmpty) {
              mainImages.addAll(images!);
              _imagesInitialized = true;
            }
            return WillPopScope(
              onWillPop: () async {
                navigateAndFinish(context, HomeAdmin());
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
                                      child: mainImages.isEmpty
                                          ? Container(
                                              height: 343,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'لا توجد صور رئيسية حالياً',
                                                  style: TextStyle(color: Colors.black54, fontSize: 14),
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                CarouselSlider(
                                                  items:mainImages.map((entry) {
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
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(16.0),
                                                                  child: Image.network(
                                                                    "$url/uploads/$entry",
                                                                    fit: BoxFit.cover,
                                                                    width: double.maxFinite,
                                                                    height: double.maxFinite,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 8,
                                                                  left: 8,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.black45,
                                                                      borderRadius: BorderRadius.circular(20),
                                                                    ),
                                                                    child: IconButton(
                                                                      visualDensity: VisualDensity.compact,
                                                                      icon: Icon(Icons.delete, color: Colors.white),
                                                                      onPressed: () {
                                                                        cubit.deleteProductMedia(
                                                                          id: id,
                                                                          type: "images",
                                                                          value: entry,
                                                                          context: context,
                                                                        );
                                                                      },
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
                                                    children: mainImages.asMap().entries.map((entry) {
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
                                              ...videoUrl!.map((vid) => GestureDetector(
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
                                                        top: 0,
                                                        right: 0,
                                                        child: IconButton(
                                                          icon: Icon(Icons.cancel, color: Colors.red),
                                                          onPressed: () => cubit.deleteProductMedia(
                                                            id: id, type: "videoLinks", value: vid, context: context
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )).toList(),
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
                                              IconButton(
                                                onPressed: () {
                                                  _showEditProductDialog(context, cubit, id);
                                                },
                                                icon: Icon(Icons.edit, color: primaryColor),
                                              ),
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
                                                        ...attachedImages!.map((img) => GestureDetector(
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
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: Stack(
                                                                fit: StackFit.expand,
                                                                children: [
                                                                  Image.network(
                                                                    "$url/uploads/$img",
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, error, stackTrace) =>
                                                                        const Icon(Icons.broken_image, color: Colors.grey),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child: IconButton(
                                                                      icon: Icon(Icons.cancel, color: Colors.red),
                                                                      onPressed: () => cubit.deleteProductMedia(
                                                                        id: id, type: "attachedImages", value: img, context: context
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )).toList(),
                                                      if (attachedVideos != null)
                                                        ...attachedVideos!.map((vid) => GestureDetector(
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
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: IconButton(
                                                                    icon: Icon(Icons.cancel, color: Colors.red),
                                                                    onPressed: () => cubit.deleteProductMedia(
                                                                      id: id, type: "attachedVideos", value: vid, context: context
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SizedBox(height: 20,),
                                      ]),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showAddMediaDialog(context, cubit, id);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 14),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'إضافة مرفقات للمنتج',
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          cubit.deleteProductAction(id: id, context: context);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 14),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade600,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: state is DeleteProductActionLoadingState
                                              ? Center(child: CircularProgressIndicator(color: Colors.white))
                                              : Center(
                                                  child: Text(
                                                    'حذف المنتج بالكامل',
                                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30,),
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

  void _showEditProductDialog(BuildContext context, AppCubit cubit, int id) {
    cubit.clearSelectedImages();
    final TextEditingController tittleController = TextEditingController(text: tittle);
    final TextEditingController sizeController = TextEditingController(text: size);
    final TextEditingController colorsController = TextEditingController(text: colors);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                          Text('تعديل تفاصيل المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                          SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: tittleController,
                        decoration: InputDecoration(
                          labelText: 'الوصف',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 3,
                        minLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: sizeController,
                        decoration: InputDecoration(
                          labelText: 'المقاسات',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: colorsController,
                        decoration: InputDecoration(
                          labelText: 'الألوان',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          cubit.pickImages();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              cubit.selectedImages.isEmpty
                                  ? 'اختيار صور رئيسية إضافية'
                                  : 'تم اختيار ${cubit.selectedImages.length} صورة جديدة',
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          cubit.updateProductDetails(
                            id: id,
                            tittle: tittleController.text,
                            size: sizeController.text,
                            colors: colorsController.text,
                            context: context,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                          child: state is UpdateProductDetailsLoadingState
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : const Center(
                                  child: Text('حفظ التعديلات', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddMediaDialog(BuildContext context, AppCubit cubit, int id) {
    cubit.clearAttachedImages();
    final TextEditingController videoLinksController = TextEditingController();
    final TextEditingController attachedVideosController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16, right: 16, top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                        Text("إضافة مرفقات للمنتج", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                        SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: attachedVideosController,
                      decoration: InputDecoration(
                        labelText: 'روابط فيديو تجارب (افصل بينها بفواصل)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: videoLinksController,
                      decoration: InputDecoration(
                        labelText: 'روابط فيديو إضافية للمنتج (اختياري)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        cubit.pickAttachedImages();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            cubit.attachedImages.isEmpty 
                                ? "اختر صور تجارب إضافية" 
                                : "تم اختيار ${cubit.attachedImages.length} صورة",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        cubit.updateProductMedia(
                          id: id,
                          videoLinks: videoLinksController.text,
                          attachedVideos: attachedVideosController.text,
                          context: context,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                        child: state is UpdateProductMediaLoadingState
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : const Center(
                                child: Text('حفظ المرفقات', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
        );
      },
    );
  }
}
