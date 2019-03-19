import 'dart:io';

class Media {
  final File file;
  final Type type;

  Media({this.file, this.type});
}

enum Type { Video, Image }
