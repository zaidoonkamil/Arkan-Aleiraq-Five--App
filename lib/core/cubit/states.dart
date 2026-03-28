abstract class AppStates {}

class AppInitialState extends AppStates {}

class ValidationState extends AppStates {}
class AddState extends AppStates {}
class SelectedImagesState extends AppStates {}

class GetProductsLoadingState extends AppStates {}
class GetProductsSuccessState extends AppStates {}
class GetProductsErrorState extends AppStates {}

class UpdateDescLoadingState extends AppStates {}
class UpdateDescSuccessState extends AppStates {}
class UpdateDescErrorState extends AppStates {}

class GetDescLoadingState extends AppStates {}
class GetDescSuccessState extends AppStates {}
class GetDescErrorState extends AppStates {}

class GetProfileLoadingState extends AppStates {}
class GetProfileSuccessState extends AppStates {}
class GetProfileErrorState extends AppStates {}

class GetUserStatusLoadingState extends AppStates {}
class GetUserStatusSuccessState extends AppStates {}
class GetUserStatusErrorState extends AppStates {}

class GetStatisticsLoadingState extends AppStates {}
class GetStatisticsSuccessState extends AppStates {}
class GetStatisticsErrorState extends AppStates {}

class GetVideosLoadingState extends AppStates {}
class GetVideosSuccessState extends AppStates {}
class GetVideosErrorState extends AppStates {}

class DeleteProductsLoadingState extends AppStates {}
class DeleteProductsSuccessState extends AppStates {}
class DeleteProductsErrorState extends AppStates {}

class DeleteVariantsLoadingState extends AppStates {}
class DeleteVariantsSuccessState extends AppStates {}
class DeleteVariantsErrorState extends AppStates {}

class UpdateVariantsLoadingState extends AppStates {}
class UpdateVariantsSuccessState extends AppStates {}
class UpdateVariantsErrorState extends AppStates {}

class AddProductsLoadingState extends AppStates {}
class AddProductsSuccessState extends AppStates {}
class AddProductsErrorState extends AppStates {}

class AddVariantsLoadingState extends AppStates {}
class AddVariantsSuccessState extends AppStates {}
class AddVariantsErrorState extends AppStates {}

class DeleteProductActionLoadingState extends AppStates {}
class DeleteProductActionSuccessState extends AppStates {}
class DeleteProductActionErrorState extends AppStates {}

class DeleteProductMediaLoadingState extends AppStates {}
class DeleteProductMediaSuccessState extends AppStates {
  final String type;
  final String value;

  DeleteProductMediaSuccessState({required this.type, required this.value});
}
class DeleteProductMediaErrorState extends AppStates {}

class GetAdsLoadingState extends AppStates {}
class GetAdsSuccessState extends AppStates {}
class GetAdsErrorState extends AppStates {}

class AddAdsLoadingState extends AppStates {}
class AddAdsSuccessState extends AppStates {}
class AddAdsErrorState extends AppStates {}

class DeleteAdsLoadingState extends AppStates {}
class DeleteAdsSuccessState extends AppStates {}
class DeleteAdsErrorState extends AppStates {}

class UpdateProductMediaLoadingState extends AppStates {}
class UpdateProductMediaSuccessState extends AppStates {}
class UpdateProductMediaErrorState extends AppStates {}

class UpdateProductDetailsLoadingState extends AppStates {}
class UpdateProductDetailsSuccessState extends AppStates {}
class UpdateProductDetailsErrorState extends AppStates {}

class GetDailyTaskLoadingState extends AppStates {}
class GetDailyTaskSuccessState extends AppStates {}
class GetDailyTaskErrorState extends AppStates {}

class DownloadTaskMediaLoadingState extends AppStates {}
class DownloadTaskMediaProgressState extends AppStates {}
class DownloadTaskMediaSuccessState extends AppStates {
  final bool isCompleted;
  DownloadTaskMediaSuccessState(this.isCompleted);
}
class DownloadTaskMediaErrorState extends AppStates {}

