import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> openBot() async {
    final Uri url = Uri.parse('tg://resolve?domain=teacher_mate_bot');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');

      //
    }
  }
}
