import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadManager {
  final _dio = Dio();

  void downloadVideo({required String url, String? savePath}) async {
    print('This is url - $url');
    String path = Platform.isAndroid ? "/storage/emulated/0/Download" : (await getApplicationDocumentsDirectory()).path;
    try {
      Response response = await _dio.download(
        url,
        savePath ?? '$path/video_${DateTime.now().millisecondsSinceEpoch}.mp4',
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      if (response.statusCode == 200) {
        print("Download completed!");
      } else {
        print("Failed to download: ${response.statusMessage}");
      }
    } catch (e) {
      print("Download error: $e");
    }
  }
}
