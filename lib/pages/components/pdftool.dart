// import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PDFTools {
  static Future<void> generateCenteredText(String text) async {
    final pdf = Document();
    final font = await PdfGoogleFonts.openSansRegular();
    pdf.addPage(Page(
      theme: ThemeData.withFont(base: font),
      pageFormat: PdfPageFormat.a4,
      build: (context) => Container(
        child: Text(text, style: const TextStyle(fontSize: 48)),
      ),
    ));
    saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<void> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    Printing.sharePdf(bytes: await pdf.save(), filename: 'notes.pdf');
    // final dir = await getApplicationDocumentsDirectory();
    // final file = File('${dir.path}/$name');
    // await file.writeAsBytes(bytes);
    // final path = file.path;
    // print('Saved file to $path');
  }
}
