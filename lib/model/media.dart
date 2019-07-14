import 'dart:io';

class Media {
  final File file;
  final Type type;

  Media({this.file, this.type});

  @override
  String toString() {
    return 'Media{file: $file, type: $type}';
  }

  Map<String, dynamic> toJson() => {"file": file.path, "type": type.index};
}

enum Type { Video, Image }
