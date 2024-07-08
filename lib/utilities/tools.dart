import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

var basicColor = const Color(0xff14631c);

void printLog(msg) {
  if (kDebugMode) {
    print("BZU: $msg");
  }
}

sendEmail(String name, String email) async {
  final smtpServer =
      gmail(dotenv.env["GMAIL_EMAIL"]!, dotenv.env["GMAIL_PASS"]!);

  final message = Message()
    ..from = Address(dotenv.env["GMAIL_EMAIL"]!, 'salah mustafa yaaqba')
    ..recipients.add(email.toString().trim())
    ..subject = "Hello $name 😊"
    ..text =
        "Thank you for registering for the program. I hope you will like this program and help you spread your useful information and share it with others.🙂";

  try {
    final sendReport = await send(message, smtpServer);

    printLog('Message sent: $sendReport');
    printLog('sendReport: $sendReport');
  } on MailerException catch (e) {
    printLog('Message not sent.');
    for (var p in e.problems) {
      printLog('Problem: ${p.code}: ${p.msg}');
    }
  }
}

enum PostType { friend, page, user }
