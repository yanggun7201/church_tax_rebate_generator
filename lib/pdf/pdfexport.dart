import 'package:church_tax_rebate_generator/models/invoice.dart';
import 'package:church_tax_rebate_generator/models/korean_fonts.dart';
import 'package:church_tax_rebate_generator/pdf/widgets/pdf_body.dart';
import 'package:church_tax_rebate_generator/pdf/widgets/pdf_footer.dart';
import 'package:church_tax_rebate_generator/pdf/widgets/pdf_header.dart';
import 'package:church_tax_rebate_generator/pdf/widgets/pdf_introduction.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:pdf/widgets.dart';

const signImageSize = 110.0;
const String nanumSquareRoundBPath = 'assets/fonts/NanumSquareRoundB.ttf';
const String nanumSquareRoundEBPath = 'assets/fonts/NanumSquareRoundEB.ttf';
const String nanumSquareRoundLPath = 'assets/fonts/NanumSquareRoundL.ttf';
const String nanumSquareRoundRPath = 'assets/fonts/NanumSquareRoundR.ttf';

Future<Uint8List> makePdf(Invoice invoice) async {
  Font koreanLightFont = Font.ttf(await rootBundle.load(nanumSquareRoundLPath));
  Font koreanBoldFont = Font.ttf(await rootBundle.load(nanumSquareRoundBPath));
  Font koreanExtraBoldFont = Font.ttf(await rootBundle.load(nanumSquareRoundEBPath));
  Font koreanRegularFont = Font.ttf(await rootBundle.load(nanumSquareRoundRPath));
  var koreanFonts = KoreanFonts(
    light: koreanLightFont,
    regular: koreanRegularFont,
    bold: koreanBoldFont,
    extraBold: koreanExtraBoldFont,
  );

  final signImage = MemoryImage((await rootBundle.load('assets/images/treasurer_sign.png')).buffer.asUint8List());

  final pdf = Document();

  pdf.addPage(
    Page(
      build: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              PdfIntroduction(koreanFonts: koreanFonts),
              SizedBox(height: 30),
              PdfHeader(koreanFonts: koreanFonts, year: invoice.currentYear),
              SizedBox(height: 20),
              PdfBody(koreanFonts: koreanFonts, invoice: invoice),
              PdfFooter(koreanFonts: koreanFonts, invoice: invoice, signImageSize: signImageSize, signImage: signImage)
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}
