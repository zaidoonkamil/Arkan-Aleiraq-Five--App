import 'package:arkan_aleiraq_five_app/core/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

import '../model/DailyTaskModel.dart';
import '../model/GetAdsModel.dart';
import '../model/GetProducts.dart';
import '../model/ProfileModel.dart';
import '../model/UserStatusModel.dart';
import '../model/VimeoVideoModel.dart';
import '../network/remote/dio_helper.dart';
import '../widgets/show_toast.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }


  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      final seen = <String>{};
      selectedImages = resultList.where((f) => seen.add(f.name)).toList();
      emit(SelectedImagesState());
    }
  }

  List<XFile> attachedImages = [];
  Future<void> pickAttachedImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      final seen = <String>{};
      attachedImages = resultList.where((f) => seen.add(f.name)).toList();
      emit(SelectedImagesState());
    }
  }

  addProducts({required String tittle, required String size, required String colors, required String videoLinks,
    required String attachedVideos, required BuildContext context,}) async {
    emit(AddProductsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور الرئيسية أولاً!", context: context);
      emit(AddProductsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'colors': colors,
          'size': size,
          'description': tittle,
          'videoLinks': videoLinks,
          'attachedVideos': attachedVideos,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }
    for (var file in attachedImages) {
      formData.files.add(
        MapEntry(
          "attachedImages",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/products',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddProductsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        String errorMessage = "حدث خطأ غير معروف";

        final data = error.response?.data;

        if (data is Map) {
          errorMessage = data["error"] ?? data["message"] ?? errorMessage;
        } else if (data is String) {
          errorMessage = data;
        } else if (data is List && data.isNotEmpty) {
          errorMessage = data[0].toString();
        }
        print(errorMessage);
        showToastError(
          text: errorMessage,
          context: context,
        );
        emit(AddProductsErrorState());
      } else {
        print("Unknown Error: $error");
        emit(AddProductsErrorState());
      }
    });
  }

  List<GetProducts> getProductsModel = [];
  void getProducts({required BuildContext context,}) {
    emit(GetProductsLoadingState());
    DioHelper.getData(
      url: '/products',
    ).then((value) {
      getProductsModel = (value.data as List)
          .map((item) => GetProducts.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetProductsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  List<VimeoVideoModel> videos = [];
  String? nextPageUrl;
  void getVideosFromFolder({required BuildContext context, required String folderId, bool loadMore = false}) {
    if (!loadMore) {
      emit(GetVideosLoadingState());
      videos.clear();
      nextPageUrl = null;
    }
    final url = nextPageUrl ?? '/me/projects/$folderId/videos';
    Dio(
      BaseOptions(
        baseUrl: 'https://api.vimeo.com',
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/vnd.vimeo.*+json;version=3.4',
        },
      ),
    ).get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer e9737174eff0c80d3ea0b1609d2275ba',
        },
      ),
    ).then((value) {
      final newVideos = (value.data['data'] as List)
          .map((item) => VimeoVideoModel.fromJson(item))
          .toList();
      videos.addAll(newVideos);
      nextPageUrl = value.data['paging']?['next'];
      emit(GetVideosSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        print(error.toString());
        showToastError(text: error.toString(), context: context);
      } else {
        print("Unknown Error: $error");
      }
      emit(GetVideosErrorState());
    });
  }

  List<ProfileModel> profileModel = [];
  void getProfile({required BuildContext context,required String name,}) {
    emit(GetProfileLoadingState());
    DioHelper.getData(
      url: '/users/search?name=$name',
    ).then((value) {
      profileModel = (value.data as List).map((item) => ProfileModel.fromJson(item as Map<String, dynamic>)).toList();
      emit(GetProfileSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetProfileErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  UserStatusModel? userStatusModel;
  void getUserStatus({required BuildContext context,}) {
    emit(GetUserStatusLoadingState());
    DioHelper.getData(
      url: '/users/status',
    ).then((value) {
      userStatusModel = UserStatusModel.fromJson(value.data);
      emit(GetUserStatusSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetUserStatusErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteUser({required String idUser,required BuildContext context}) {
    emit(DeleteProductsLoadingState());

    DioHelper.deleteData(
      url: '/users/$idUser',
    ).then((value) {
      profileModel.removeWhere((users) => users.id.toString() == idUser);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteProductsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteProductAction({required int id, required BuildContext context}) {
    emit(DeleteProductActionLoadingState());
    DioHelper.deleteData(
      url: '/products/$id',
    ).then((value) {
      getProductsModel.removeWhere((p) => p.id == id);
      showToastSuccess(text: 'تم حذف المنتج بنجاح', context: context);
      emit(DeleteProductActionSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        showToastError(text: error.toString(), context: context);
      }
      emit(DeleteProductActionErrorState());
    });
  }

  List<GetAds> getAdsModel = [];
  void getAds({required BuildContext context,}) {
    emit(GetAdsLoadingState());
    DioHelper.getData(
      url: '/ads',
    ).then((value) {
      getAdsModel = (value.data as List)
          .map((item) => GetAds.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addAds({required String tittle, required String desc, required BuildContext context,})async{
    emit(AddAdsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddAdsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'name': tittle,
          'description': desc,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/ads',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddAdsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteAds({required String id,required BuildContext context}) {
    emit(DeleteAdsLoadingState());
    DioHelper.deleteData(
      url: '/ads/$id',
    ).then((value) {
      getAdsModel.removeWhere((getAdsModel) => getAdsModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  void deleteProductMedia({required int id, required String type, required String value, required BuildContext context}) {
    emit(DeleteProductMediaLoadingState());
    DioHelper.deleteData(
        url: '/products/$id/media',
        data: {
          "type": type,
          "value": value
        }
    ).then((response) {
      showToastSuccess(text: 'تم مسح المرفق بنجاح', context: context);
      emit(DeleteProductMediaSuccessState(type: type, value: value));
    }).catchError((error) {
      if (error is DioException) {
        showToastError(text: error.response?.data['error'] ?? error.toString(), context: context);
      }
      emit(DeleteProductMediaErrorState());
    });
  }

  void updateProductMedia({
    required int id,
    required String videoLinks,
    required String attachedVideos,
    required BuildContext context,
  }) async {
    emit(UpdateProductMediaLoadingState());
    
    FormData formData = FormData.fromMap(
        {
          'videoLinks': videoLinks,
          'attachedVideos': attachedVideos,
        },
        ListFormat.multiCompatible
    );

    for (var file in attachedImages) {
      formData.files.add(
        MapEntry(
          "attachedImages",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.putData(
      url: '/products/$id/media',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      showToastSuccess(text: 'تم الإضافة بنجاح', context: context);
      attachedImages = []; // reset after success
      emit(UpdateProductMediaSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        showToastError(text: error.toString(), context: context);
      }
      emit(UpdateProductMediaErrorState());
    });
  }

  updateDesc({required String content, required BuildContext context,}){
    emit(UpdateDescLoadingState());
    DioHelper.putData(
      url: '/details/1',
      data:
      {
        'content': content,
      },
    ).then((value) {
      emit(UpdateDescSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(UpdateDescErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  String? details;
  getDesc({ required BuildContext context,}){
    emit(GetDescLoadingState());
    DioHelper.getData(
      url: '/details/1',
    ).then((value) {
      details = value.data["content"];
      emit(GetDescSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(GetDescErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void updateProductDetails({
    required int id,
    required String tittle,
    required String size,
    required String colors,
    required BuildContext context,
  }) async {
    emit(UpdateProductDetailsLoadingState());

    FormData formData = FormData.fromMap(
      {
        'description': tittle,
        'size': size,
        'colors': colors,
      },
      ListFormat.multiCompatible,
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }


    DioHelper.putData(
      url: '/products/$id',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    ).then((value) {
      showToastSuccess(text: 'تم تحديث تفاصيل المنتج بنجاح', context: context);
      selectedImages = [];
      emit(UpdateProductDetailsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        final data = error.response?.data;
        final message = data is Map
            ? (data['error'] ?? data['message'] ?? error.toString()).toString()
            : error.toString();
        print(message);
        showToastError(text: message, context: context);
      }
      emit(UpdateProductDetailsErrorState());
    });
  }

  void clearSelectedImages() {
    selectedImages = [];
    emit(AppInitialState());
  }

  void clearAttachedImages() {
    attachedImages = [];
    emit(AppInitialState());
  }

  DailyTaskModel? dailyTask;
  
  void getDailyTask({required BuildContext context, required String userId}) {
    emit(GetDailyTaskLoadingState());
    DioHelper.getData(
      url: '/tasks/daily?userId=$userId',
    ).then((value) {
      dailyTask = DailyTaskModel.fromJson(value.data['task']);
      emit(GetDailyTaskSuccessState());
    }).catchError((error) {
      if (error is DioError) {
         showToastError(text: error.toString(), context: context);
      }
      print("Error fetching daily task: $error");
      emit(GetDailyTaskErrorState());
    });
  }

  Map<String, double> mediaDownloadProgress = {};

  void downloadTaskMedia({
    required BuildContext context,
    required int taskId,
    required String mediaUrl,
    bool isVideo = false,
  }) async {
    mediaDownloadProgress[mediaUrl] = 0.0;
    emit(DownloadTaskMediaProgressState());

    try {
      final isVimeo = mediaUrl.contains('vimeo');
      String urlToDownload = mediaUrl;
      if (!isVimeo && !mediaUrl.startsWith('http')) {
        urlToDownload = "$url/uploads/${mediaUrl.trim()}";
      }

      final dir = await getApplicationDocumentsDirectory();

      String fileName = urlToDownload.split('/').last.split('?').first;
      if (!fileName.contains('.')) {
        fileName = fileName + (isVideo ? '.mp4' : '.jpg');
      }
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        urlToDownload, 
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            mediaDownloadProgress[mediaUrl] = received / total;
            emit(DownloadTaskMediaProgressState());
          }
        },
      );

      if (isVideo) {
        await Gal.putVideo(savePath);
      } else {
        await Gal.putImage(savePath);
      }

      mediaDownloadProgress.remove(mediaUrl);
      emit(DownloadTaskMediaProgressState());

      DioHelper.postData(
        url: '/tasks/download',
        data: {
          'taskId': taskId,
          'mediaUrl': mediaUrl,
        },
      ).then((value) {
        if (dailyTask != null) {
          dailyTask!.downloadedMedia = List<String>.from(
            value.data['task']['downloadedMedia'].map((x) => x),
          );
          dailyTask!.isCompleted = value.data['task']['isCompleted'];
        }
        showToastSuccess(text: 'تم الحفظ والتحقق بنجاح ✅', context: context);
        emit(DownloadTaskMediaSuccessState(value.data['task']['isCompleted']));
      }).catchError((error) {
        print("Error recording: $error");
        mediaDownloadProgress.remove(mediaUrl);
        emit(DownloadTaskMediaErrorState());
      });

    } catch (e) {
      print("Error in actual download: $e");
      mediaDownloadProgress.remove(mediaUrl);
      showToastError(text: 'فشل الحفظ: $e', context: context);
      emit(DownloadTaskMediaErrorState());
    }
  }

  void downloadMediaOnly({
    required BuildContext context,
    required String mediaUrl,
    bool isVideo = false,
  }) async {
    mediaDownloadProgress[mediaUrl] = 0.0;
    emit(DownloadTaskMediaProgressState());

    try {
      final isVimeo = mediaUrl.contains('vimeo');
      String urlToDownload = mediaUrl;
      if (!isVimeo && !mediaUrl.startsWith('http')) {
        urlToDownload = "$url/uploads/${mediaUrl.trim()}";
      }

      final dir = await getApplicationDocumentsDirectory();

      String fileName = urlToDownload.split('/').last.split('?').first;
      if (!fileName.contains('.')) {
        fileName = fileName + (isVideo ? '.mp4' : '.jpg');
      }
      final savePath = '${dir.path}/$fileName';

      await Dio().download(
        urlToDownload, 
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            mediaDownloadProgress[mediaUrl] = received / total;
            emit(DownloadTaskMediaProgressState());
          }
        },
      );

      if (isVideo) {
        await Gal.putVideo(savePath);
      } else {
        await Gal.putImage(savePath);
      }

      mediaDownloadProgress.remove(mediaUrl);
      showToastSuccess(text: 'تم الحفظ بنجاح ✅', context: context);
      emit(DownloadTaskMediaSuccessState(false));

    } catch (e) {
      print("Error in actual download: $e");
      mediaDownloadProgress.remove(mediaUrl);
      showToastError(text: 'فشل الحفظ: $e', context: context);
      emit(DownloadTaskMediaErrorState());
    }
  }

}