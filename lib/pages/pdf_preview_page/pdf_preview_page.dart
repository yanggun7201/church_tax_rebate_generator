import 'package:flutter/material.dart';
import 'package:church_tax_rebate_generator/models/invoice.dart';
import 'package:church_tax_rebate_generator/pdf/pdfexport.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final Invoice invoice;

  const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        // build: (context) => makeGridPdf(invoice),
        build: (context) => makePdf(invoice),
      ),
    );
  }
}
