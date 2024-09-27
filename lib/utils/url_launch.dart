import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
