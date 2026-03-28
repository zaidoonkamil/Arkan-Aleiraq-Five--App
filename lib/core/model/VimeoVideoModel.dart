class VimeoVideoModel {
  final String name;
  final String? thumbnail;
  final String? playbackLink;
  final int? duration;

  VimeoVideoModel({
    required this.name,
    this.thumbnail,
    this.playbackLink,
    this.duration,
  });

  factory VimeoVideoModel.fromJson(Map<String, dynamic> json) {
    String? playbackUrl;
    if (json['files'] != null && json['files'] is List) {
      var files = json['files'] as List;
      if (files.isNotEmpty) {
        playbackUrl = files.first['link'];
      }
    }
    return VimeoVideoModel(
      name: json['name'] ?? '',
      thumbnail: json['pictures'] != null && json['pictures']['sizes'] != null
          ? json['pictures']['sizes'].last['link']
          : null,
      playbackLink: playbackUrl,
      duration: json['duration'],
    );
  }
}
