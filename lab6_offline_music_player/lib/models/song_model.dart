class SongModel {
  final String title;
  final String artist;
  final String assetPath;

  SongModel({
    required this.title,
    required this.artist,
    required this.assetPath,
  });
}
class MusicTrack {
  final String  id;
  final String  title;
  final String  artist;
  final String? album;
  final String  filePath;
  final Duration? duration;
  final String? albumArt;
  final int?    fileSize;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.filePath,
    this.duration,
    this.albumArt,
    this.fileSize,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      id:       json['id'],
      title:    json['title'],
      artist:   json['artist'],
      album:    json['album'],
      filePath: json['filePath'],
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'])
          : null,
      albumArt: json['albumArt'],
      fileSize: json['fileSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':       id,
      'title':    title,
      'artist':   artist,
      'album':    album,
      'filePath': filePath,
      'duration': duration?.inMilliseconds,
      'albumArt': albumArt,
      'fileSize': fileSize,
    };
  }

  factory MusicTrack.fromFilePath(String filePath) {
    final fileName = filePath.split('/').last.split('\\').last;
    final nameWithoutExt = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    return MusicTrack(
      id:       filePath.hashCode.toString(),
      title:    nameWithoutExt,
      artist:   'Unknown Artist',
      filePath: filePath,
    );
  }
}