class Captcha {}

Future<bool> verificationCaptcha() async {
  await Future.delayed(Duration(seconds: 5));
  return true;
}

Future<bool> verificationSms() async {
  await Future.delayed(Duration(seconds: 5));
  return true;
}
