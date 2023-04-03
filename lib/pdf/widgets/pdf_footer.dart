import 'package:church_tax_rebate_generator/models/invoice.dart';
import 'package:church_tax_rebate_generator/models/korean_fonts.dart';
import 'package:pdf/widgets.dart';

class PdfFooter extends StatelessWidget {
  final Invoice invoice;
  final double signImageSize;
  final MemoryImage signImage;
  final KoreanFonts koreanFonts;

  PdfFooter({
    required this.koreanFonts,
    required this.invoice,
    required this.signImageSize,
    required this.signImage,
  });

  @override
  Widget build(Context context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("SUN IL LEE", style: TextStyle(fontSize: 12, font: koreanFonts.extraBold)),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text("Treasurer", style: TextStyle(fontSize: 12, font: koreanFonts.extraBold)),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "The Evangelical Holiness Church of New Zealand",
                        style: TextStyle(fontSize: 12, font: koreanFonts.extraBold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 160,
              bottom: 20,
              child: SizedBox(height: signImageSize, width: signImageSize, child: Image(signImage)),
            )
          ],
        ),
      ),
    );
  }
}
