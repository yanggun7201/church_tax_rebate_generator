import 'package:church_tax_rebate_generator/theme.dart';
import 'package:flutter/material.dart';
import 'package:church_tax_rebate_generator/pages/pdf_config_page/pdf_config_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: theme(context),
      home: const PdfConfigPage(title: title),
    );
  }
}
