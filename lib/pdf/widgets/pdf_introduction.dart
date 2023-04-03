import 'package:church_tax_rebate_generator/models/korean_fonts.dart';
import 'package:pdf/widgets.dart';

class PdfIntroduction extends StatelessWidget {
  final KoreanFonts koreanFonts;

  PdfIntroduction({required this.koreanFonts});

  @override
  Widget build(Context context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("The Evangelical Holiness Church of New Zealand",
            style: TextStyle(fontSize: 15, font: koreanFonts.extraBold)),
        SizedBox(height: 10),
        Text("46 James St, Glenfield, Auckland", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
        SizedBox(height: 10),
        Text("Ph 09 443 8113", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
      ],
    );
  }
}
