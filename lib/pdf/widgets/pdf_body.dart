import 'package:church_tax_rebate_generator/models/invoice.dart';
import 'package:church_tax_rebate_generator/models/korean_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';

class PdfBody extends StatelessWidget {
  final Invoice invoice;
  final KoreanFonts koreanFonts;

  PdfBody({
    required this.koreanFonts,
    required this.invoice,
  });

  @override
  Widget build(Context context) {
    return Row(
      children: [
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text("To whom it may concern", style: TextStyle(fontSize: 12, font: koreanFonts.regular)),
              SizedBox(height: 70),
              RichText(
                softWrap: true,
                text: TextSpan(
                  text: 'This is to certify the annual donation of ',
                  style: TextStyle(fontSize: 12, lineSpacing: 8, font: koreanFonts.regular),
                  children: <TextSpan>[
                    TextSpan(text: invoice.name, style: TextStyle(font: koreanFonts.extraBold)),
                    const TextSpan(text: ' of '),
                    TextSpan(text: "${invoice.address}."),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                softWrap: true,
                text: TextSpan(
                  text: '',
                  style: TextStyle(fontSize: 12, lineSpacing: 8, font: koreanFonts.regular),
                  children: <TextSpan>[
                    TextSpan(text: invoice.name, style: TextStyle(font: koreanFonts.extraBold)),
                    TextSpan(
                        text:
                            ' donated ${getCurrency(invoice.totalDonation)} from 1 April ${invoice.currentYear - 1} to 31 March ${invoice.currentYear}.'),
                  ],
                ),
              ),
              SizedBox(height: 70),
              Text(
                "If you have any queries, please do not hesitate to contact me on 021-920-650.",
                style: TextStyle(fontSize: 12, font: koreanFonts.regular),
              ),
              SizedBox(height: 30),
              Text(
                "Regards",
                style: TextStyle(fontSize: 12, font: koreanFonts.regular),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getCurrency(double totalDonation) {
    return NumberFormat.simpleCurrency(locale: 'EN-us', decimalDigits: 2).format(totalDonation);
  }
}
