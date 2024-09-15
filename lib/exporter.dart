import 'dart:io';

void main() {
  // مسیر دایرکتوری lib
  const directoryPath = 'lib';

  const exportFilePath = 'lib/export_lib.dart';

  final directory = Directory(directoryPath);
  final exportFile = File(exportFilePath);

  if (!directory.existsSync()) {
    print('دایرکتوری lib وجود ندارد.');
    return;
  }

  final sink = exportFile.openWrite();

  directory.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final relativePath = entity.path.replaceFirst('$directoryPath/', '');
      if (!relativePath.endsWith('.g.dart')) {
        sink.writeln("export '$relativePath';");
      }
    }
  });

  // بستن فایل پس از اتمام نوشتن
  sink.close();
  print(
      'تمام فایل‌های دارت در دایرکتوری lib، به جز فایل‌های .g.dart، در export_lib.dart وارد شدند.');
}
