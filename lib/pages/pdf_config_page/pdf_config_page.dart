import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:church_tax_rebate_generator/models/invoice.dart';
import 'package:church_tax_rebate_generator/pages/pdf_preview_page/pdf_preview_page.dart';
import 'package:church_tax_rebate_generator/pdf/pdfexport.dart';
import 'package:church_tax_rebate_generator/utils/file_utils.dart';
import 'package:church_tax_rebate_generator/utils/number_utils.dart';
import 'package:church_tax_rebate_generator/utils/snack_bar_utils.dart';
import 'package:path_provider/path_provider.dart';

const title = 'The Evangelical Holiness Church';

const pdfFileDirectoryPrefix = "참된교회_TAX_REBATE_";

class PdfConfigPage extends StatefulWidget {
  const PdfConfigPage({super.key, required this.title});

  final String title;

  @override
  State<PdfConfigPage> createState() => _PdfConfigPageState();
}

class _PdfConfigPageState extends State<PdfConfigPage> {
  int year = 2023;
  int dataCount = 0;
  int genCount = 0;
  String issueDate = '';
  String savedDirectory = '';
  bool isGenerating = false;
  bool isSelectingCsvFile = false;
  List<Invoice> invoices = [];
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateFormat directoryFormat = DateFormat("yyyy_MM_dd_HH_mm_ss");
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var currentYear = DateTime.now().year;

    setState(() {
      year = currentYear;
      yearController.text = "$currentYear";
      issueDate = dateFormat.format(DateTime.now());
    });
  }

  void _previewInvoice() async {
    if (invoices.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PdfPreviewPage(invoice: invoices.elementAt(0))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildYearTextFormField(),
            const SizedBox(height: 30),
            if (dataCount == 0) const Text('CSV 파일을 선택해 주세요.', style: TextStyle(fontSize: 20)),
            if (dataCount != 0) ...[
              if (isGenerating == false && genCount == 0)
                Text('처리할 데이터가 $dataCount 건 입니다.', style: const TextStyle(fontSize: 20)),
              if (isGenerating == false && genCount == dataCount)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$dataCount 건의 Tax Rebate PDF 파일을 생성하였습니다.', style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    ElevatedButton(onPressed: _openSavedDirectory, child: const Text('폴더 열기')),
                  ],
                ),
              if (isGenerating == true) Text('$genCount / $dataCount 처리 중 입니다.', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _generatePdfFiles, child: const Text('PDF 만들기')),
              const SizedBox(height: 50),
            ],
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _selectCsvFile, child: const Text('Select CSV File')),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: dataCount > 0,
        child: FloatingActionButton(
          onPressed: _previewInvoice,
          tooltip: 'PDF 미리보기',
          child: const Icon(Icons.preview),
        ),
      ),
    );
  }

  Widget _buildYearTextFormField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: yearController,
        // style: const TextStyle(color: Colors.deepPurple),
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_month),
          hintText: '년도를 입력하세요.',
          labelText: 'Year *',
          hintStyle: TextStyle(fontSize: 18),
          labelStyle: TextStyle(fontSize: 18),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
          ),
        ),
        style: TextStyle(fontSize: 18),
        onChanged: (newValue) {
          setState(() {
            year = int.parse(newValue);
          });
        },
      ),
    );
  }

  void _selectCsvFile() async {
    if (isSelectingCsvFile) {
      return;
    }

    isSelectingCsvFile = true;
    setState(() {
      isSelectingCsvFile = true;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    isSelectingCsvFile = false;
    setState(() {
      isSelectingCsvFile = false;
    });

    if (result != null) {
      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(contents);

      _initState();

      List<Invoice> invoiceList = [];
      for (List<dynamic> row in rowsAsListOfValues) {
        if (row[0].toString().isEmpty || row[0].toString() == "#") {
          continue;
        }
        invoiceList.add(toInvoice(row));
      }

      setState(() {
        dataCount = invoiceList.length;
        invoices = invoiceList;
      });
    }
  }

  void _initState() {
    setState(() {
      genCount = 0;
      dataCount = 0;
      isGenerating = false;
      invoices = [];
      savedDirectory = '';
    });
  }

  Invoice toInvoice(List<dynamic> row) {
    Invoice invoice = Invoice(
      name: row[0],
      address: row[1],
      totalDonation: NumberUtils.parseDouble(row[2].toString()),
      currentYear: year,
    );

    return invoice;
  }

  void _generatePdfFiles() async {
    setState(() {
      genCount = 0;
      isGenerating = true;
    });

    var distDirectory = await _getDistDirectory();

    if (await FileUtils.createNewDirectory(distDirectory) == null) {
      SnackBarUtils.showSnackBar(context, "폴더를 생성하는데 실패하였습니다.");
      return;
    }

    List<Invoice> targetInvoices = getInvoicesWithConfigurations();

    for (Invoice invoice in targetInvoices) {
      final file = File('$distDirectory$s${invoice.name}.pdf');
      await file.writeAsBytes(await makePdf(invoice));
      setState(() {
        genCount = genCount + 1;
      });
    }

    SnackBarUtils.showSnackBar(context, '$distDirectory 폴더에 저장되었습니다.');

    setState(() {
      savedDirectory = distDirectory;
      isGenerating = false;
    });
  }

  List<Invoice> getInvoicesWithConfigurations() {
    return invoices.map((e) => e.copyWith(currentYear: year)).toList();
  }

  void _openSavedDirectory() {
    FileUtils.openSavedDirectory(context, savedDirectory);
  }

  String get s => Platform.pathSeparator;

  Future<String> _getDistDirectory() async {
    final documentsDirectory = await _getDocumentDirectory();
    return '$documentsDirectory${s}Documents$s$pdfFileDirectoryPrefix$year$s${directoryFormat.format(DateTime.now())}';
  }

  Future<String> _getDocumentDirectory() async {
    if (Platform.isMacOS) {
      return Directory.current.absolute.path;
    }

    final applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
    return applicationDocumentsDirectory.parent.parent.path;
  }
}
