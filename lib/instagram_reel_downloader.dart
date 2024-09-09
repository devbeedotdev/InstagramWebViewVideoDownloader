import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:instagram_reel_downloader/download_manager.dart';

class InstagramReelDownloaderWebViewImpl implements InstagramReelDownloaderWebView {
  final InAppWebViewController webViewController;
  InstagramReelDownloaderWebViewImpl({required this.webViewController});
  String _videoSourceUrl = 'empty';

  @override
  void addScriptHandler() async {
    try {
      print('adding script handler');
      webViewController.addJavaScriptHandler(
          handlerName: 'vidurl',
          callback: (tt) {
            decodeRawVideoUrl(tt);
          });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void loadScriptFromAsset() {
    print('loading script from asset');
    webViewController.injectJavascriptFileFromAsset(assetFilePath: "packages/instagram_reel_downloader/assets/fb.js");
  }

  @override
  Future<bool> validateUrl() async {
    Uri? currentWebViewUrl = await webViewController.getUrl();

    if (currentWebViewUrl == null) {
      return false;
    }
    return currentWebViewUrl.toString().contains('facebook.com');
  }

  @override
  String get videoSourceUrl => _videoSourceUrl;

  @override
  void decodeRawVideoUrl(List rawVideoUrl) {
    String joinedUrl = rawVideoUrl.join();
    String decodedVideoUrl = joinedUrl.replaceAll('&amp;', '&').toString();

    assignVideoUrl = decodedVideoUrl;
  }

  @override
  set assignVideoUrl(String videoSourceUrl) {
    _videoSourceUrl = videoSourceUrl;
    downloadDecodedVideoUrl(decodedVideoUrl: _videoSourceUrl);
  }

  @override
  void downloadDecodedVideoUrl({required String decodedVideoUrl, String? savePath}) {
    DownloadManager().downloadVideo(url: decodedVideoUrl, savePath: savePath);
  }
}

abstract class InstagramReelDownloaderWebView {
  void addScriptHandler();
  String get videoSourceUrl;
  set assignVideoUrl(String videoSourceUrl);
  void loadScriptFromAsset();
  Future<bool> validateUrl();
  void decodeRawVideoUrl(List url);
  void downloadDecodedVideoUrl({required String decodedVideoUrl, String? savePath});
}
