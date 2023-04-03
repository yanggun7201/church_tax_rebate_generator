import 'package:church_tax_rebate_generator/models/korean_fonts.dart';
import 'package:pdf/widgets.dart';

class PdfHeader extends StatelessWidget {
  final KoreanFonts koreanFonts;
  final int year;

  PdfHeader({
    required this.koreanFonts,
    required this.year,
  });

  @override
  Widget build(Context context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text("Inland Revenue", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
            SizedBox(height: 10),
            Text("Taxation Dept.", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
            SizedBox(height: 30),
            Text("31 March $year", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
          ],
        ),
      ],
    );
  }
}
