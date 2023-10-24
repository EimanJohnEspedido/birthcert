import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:vector_math/vector_math_64.dart';

import '../data.dart';
// import 'test.dart';

// double credit1 = 0;
// double total0 = 0;
// double total1 = 0;
// double debit1 = 0;
// double _grandTotal = 0;
//this1

Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat, CustomData data) async {
  DateTime now = DateTime.now();

  final formattedDate = DateFormat.yMd('en_US');

  // final objSample = [
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "lacinia aenean",
  //     "refno": 43249326,
  //     "reading": 1180,
  //     "usage": 1,
  //     "debit": 1122.8,
  //     "credit": 594.67,
  //     "balance": 371.87
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "lacinia eget",
  //     "refno": 586130482,
  //     "reading": 3954,
  //     "usage": 15,
  //     "debit": 207.12,
  //     "credit": 1399.63,
  //     "balance": 1056.5
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "parturient montes",
  //     "refno": 514176825,
  //     "reading": 3123,
  //     "usage": 8,
  //     "debit": 1281.16,
  //     "credit": 670.9,
  //     "balance": 437.62
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "integer pede",
  //     "refno": 353719653,
  //     "reading": 3381,
  //     "usage": 2,
  //     "debit": 1834.31,
  //     "credit": 1489.68,
  //     "balance": 1452.6
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "nascetur ridiculus",
  //     "refno": 192222224,
  //     "reading": 3894,
  //     "usage": 2,
  //     "debit": 1566.55,
  //     "credit": 1986.26,
  //     "balance": 573.76
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "fermentum justo",
  //     "refno": 128481101,
  //     "reading": 3848,
  //     "usage": 15,
  //     "debit": 1640.13,
  //     "credit": 991.74,
  //     "balance": 1141.91
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "sapien urna",
  //     "refno": 30530847,
  //     "reading": 3987,
  //     "usage": 12,
  //     "debit": 1983.99,
  //     "credit": 855.66,
  //     "balance": 888.82
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "eget elit",
  //     "refno": 63733283,
  //     "reading": 666,
  //     "usage": 10,
  //     "debit": 1108.34,
  //     "credit": 247.26,
  //     "balance": 680.21
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "id sapien",
  //     "refno": 280635410,
  //     "reading": 2055,
  //     "usage": 8,
  //     "debit": 1022.86,
  //     "credit": 1099.86,
  //     "balance": 117.79
  //   },
  //   {
  //     "date": "5/23/2004",
  //     "particulars": "dolor sit",
  //     "refno": 620643046,
  //     "reading": 3994,
  //     "usage": 5,
  //     "debit": 1584.11,
  //     "credit": 615.06,
  //     "balance": 1650.51
  //   }
  // ];

  final objSample = [
    {
      "refNum": "82-507961",
      "name": "Way Gleeton",
      "totalReceivables": 1.0,
      "current": 2.0,
      "a": 3.0,
      "b": 4.0,
      "c": 5.0,
      "d": 65.0,
      "e": 7.0,
      "f": 88.0,
      "g": 9.0,
      "h": 10.0,
      "i": 11.0,
      "j": 12.0
    },
  ];

  // double calculateTotalBalance() {
  //   double total = 0.0;
  //   double total1 = 0.0;
  //   double total2 = 0.0;

  //   for (final client in objSample) {
  //     if (client['balance'] is double) {
  //       total += (client['balance'] as double); // Cast the value to double
  //       total0 = total;
  //     }
  //     if (client['credit'] is double) {
  //       total1 += (client['credit'] as double); // Cast the value to double
  //       credit1 = total1;
  //     }
  //     if (client['debit'] is double) {
  //       total2 += (client['debit'] as double); // Cast the value to double
  //       debit1 = total2;
  //     }
  //   }
  //   _grandTotal = total0 + debit1 - credit1;
  //   return total + total1 - total2;
  // }

  // calculateTotalBalance();

  final client = objSample.map((objSample) {
    return viewClients(
      objSample['refNum'].toString(),
      objSample['name'].toString(),
      objSample['totalReceivables'] as double,
      objSample['current'] as double,
      objSample['a'] as double,
      objSample['b'] as double,
      objSample['c'] as double,
      objSample['d'] as double,
      objSample['e '] as double,
      objSample['f'] as double,
      objSample['g'] as double,
      objSample['h'] as double,
      objSample['i'] as double,
      objSample['j'] as double,
    );
  }).toList();

  final statementOfAccount = Statement(
    client: client,
    refNum: 'a',
    name: 'a',
    totalReceivables: 162.0,
    current: 3.0,
    a: 37.0,
    b: 2.0,
    c: 166.0,
    d: 41.0,
    e: 83.0,
    f: 19.0,
    g: 72.0,
    h: 16.0,
    i: 23.0,
    j: 42.0,
    baseColor: PdfColors.white,
    accentColor: PdfColors.black,
  );

  return await statementOfAccount.buildPdf(pageFormat);
}

class Statement {
  Statement({
    required this.client,
    required this.refNum,
    required this.name,
    required this.totalReceivables,
    required this.current,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
    required this.f,
    required this.g,
    required this.h,
    required this.i,
    required this.j,
    required this.accentColor,
    required this.baseColor,
  });

  final List<viewClients> client;
  final String refNum;
  final String name;
  final double totalReceivables;
  final double current;
  final double a;
  final double b;
  final double c;
  final double d;
  final double e;
  final double f;
  final double g;
  final double h;
  final double i;
  final double j;

  final PdfColor baseColor;
  final PdfColor accentColor;
  static const _darkColor = PdfColors.black;
  static const _lightColor = PdfColors.white;
  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;
  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.anonymousProRegular(),
          await PdfGoogleFonts.anonymousProBold(),
          await PdfGoogleFonts.anonymousProItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _buildHeader1(context),
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 5),
          _buildForm(context)
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
        decoration: const pw.BoxDecoration(),
        child: pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text('Taal Water District',
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: (12),
                            )),
                        pw.Text(
                          'CALLE V. ILLUSTRE, COR. CALLE C. SANCHEZ. TAAL, BATANGAS',
                        )
                      ]),
                ])));
  }

  pw.Widget _buildHeader1(pw.Context context) {
    return pw.Container(
      //   decoration: pw.BoxDecoration(
      //   border: pw.Border.all(),
      //  ),
      child: pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'STATEMENT OF ACCOUNT',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          'AS OF ${_formatDate(DateTime.now())}',
                        )
                      ]),
                ),
                // pw.Column(
                //   crossAxisAlignment: pw.CrossAxisAlignment.end,
                //   children: [
                //     pw.Text('DISCONNECTION LIST'),
                //     pw.Text('${context.pageNumber} / ${context.pagesCount}')
                //   ]
                // ),
              ])),
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat.copyWith(
        marginLeft: 20,
        marginRight: 20,
        marginTop: 20,
        marginBottom: 20,
      ),
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Container(
      //   decoration: pw.BoxDecoration(
      //    border: pw.Border.all(),
      // ),
      child: pw.Padding(
        padding: pw.EdgeInsets.all(10),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ACCOUNT NO: ',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('NAME : '),
                    pw.Text('ADDRESS  : '),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('RunDateTime: ${_formatDate(DateTime.now())}'),
                    pw.Text('METER NO. '),
                    pw.Text('STATUS : '),
                  ]),
            ]),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          // child: pw.BarcodeWidget(
          //   barcode: pw.Barcode.pdf417(),
          //   data: 'Invoice# $invoiceNumber',
          //   drawText: false,
          // ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  // pw.Widget _contentFooter(pw.Context context) {
  //   return pw.Row(
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     children: [
  //       pw.Expanded(
  //         flex: 2,
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text(
  //               'Thank you for your business',
  //               style: pw.TextStyle(
  //                 color: _darkColor,
  //                 fontWeight: pw.FontWeight.bold,
  //               ),
  //             ),
  //             pw.Container(
  //               margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
  //               child: pw.Text(
  //                 'Payment Info:',
  //                 style: pw.TextStyle(
  //                   color: baseColor,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             pw.Text(
  //               '',
  //               style: const pw.TextStyle(
  //                 fontSize: 8,
  //                 lineSpacing: 5,
  //                 color: _darkColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       pw.Expanded(
  //         flex: 1,
  //         child: pw.DefaultTextStyle(
  //           style: const pw.TextStyle(
  //             fontSize: 10,
  //             color: _darkColor,
  //           ),
  //           child: pw.Column(
  //             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //             children: [
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Sub Total:'),
  //                   pw.Text(_formatCurrency(total0)),
  //                 ],
  //               ),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Total Debit:'),
  //                   pw.Text(_formatCurrency(debit1)),
  //                 ],
  //               ),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Total Credit:'),
  //                   pw.Text(_formatCurrency(credit1)),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 5),
  //               // pw.Row(
  //               //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               //   children: [
  //               //     pw.Text('Tax:'),
  //               //     pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
  //               //   ],
  //               // ),

  //               pw.Divider(color: accentColor),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Total:'),
  //                   pw.Text(_formatCurrency(_grandTotal)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

// pw.Widget _termsAndConditions(pw.Context context) {
//     return pw.Row(
//       crossAxisAlignment: pw.CrossAxisAlignment.end,
//       children: [
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Container(
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border(top: pw.BorderSide(color: accentColor)),
//                 ),
//                 padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
//                 child: pw.Text(
//                   'Terms & Conditions',
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     color: baseColor,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.Text(
//                 pw.LoremText().paragraph(40),
//                 textAlign: pw.TextAlign.justify,
//                 style: const pw.TextStyle(
//                   fontSize: 6,
//                   lineSpacing: 2,
//                   color: _darkColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         pw.Expanded(
//           child: pw.SizedBox(),
//         ),
//       ],
//     );
//   }

  pw.Widget _buildForm(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            style: pw.BorderStyle.dashed,
            color: PdfColors.black,
          ),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(height: 10),
          pw.DefaultTextStyle(
            style: pw.TextStyle(
              fontSize: 8,
            ),
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        alignment: pw.Alignment
                            .center, // Center the content horizontally
                        child: pw.Paragraph(
                          padding: pw.EdgeInsets.only(right: 60, left: 60),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          text:
                              'This is a statement of your account as it appears in your books. If it disagrees with your records in any way, kindly advise us at once. Please disregard if payment has been made.',
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(width: 140),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Prepared by: '),
                    pw.SizedBox(width: 160),
                    pw.Text('Noted by: '),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('CRISTINA R. ROMANES',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 200),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Customer Service Clerk',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 120),
                    pw.Text('Division Manager C',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Account Number',
      'Consumer Name',
      'Total Receivables',
      'Current',
      '31-60',
      '61-90',
      '91-120',
      '121-180',
      '181-365',
      '1-2 Yr',
      '2-3 Yr',
      '3-4 Yr',
      '4-5 Yr',
      'Above'
    ];

    return pw.TableHelper.fromTextArray(
      headerPadding: pw.EdgeInsets.zero,
      border: pw.TableBorder(
          bottom: pw.BorderSide(
              width: 1, color: PdfColors.black, style: pw.BorderStyle.dashed),
          horizontalInside: pw.BorderSide(width: 0, color: PdfColors.white),
          verticalInside: pw.BorderSide(width: 0, color: PdfColors.white)),
      cellPadding: pw.EdgeInsets.all(1),
      cellAlignment: pw.Alignment.centerLeft,
      headerHeight: 20,
      cellHeight: 10,
      headerAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
        10: pw.Alignment.center,
        11: pw.Alignment.center,
        12: pw.Alignment.center,
        13: pw.Alignment.center,
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
        10: pw.Alignment.center,
        11: pw.Alignment.center,
        12: pw.Alignment.center,
        13: pw.Alignment.center,
      },
      columnWidths: {
        0: pw.FlexColumnWidth(1.5),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(1.5),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1),
        5: pw.FlexColumnWidth(1),
        6: pw.FlexColumnWidth(1),
        7: pw.FlexColumnWidth(1),
        8: pw.FlexColumnWidth(1),
        9: pw.FlexColumnWidth(1),
        10: pw.FlexColumnWidth(1),
        11: pw.FlexColumnWidth(1),
        12: pw.FlexColumnWidth(1),
        13: pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        fontSize: 7,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 5.5,
      ),
      headerCellDecoration: pw.BoxDecoration(
          border: pw.Border(
              bottom: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              left: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              right: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              top: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed))),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        client.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => client[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMd('en_US');
  return format.format(date);
}

// class Clients {
//   const Clients(this.date, this.particulars, this.refno, this.reading,
//       this.usage, this.debit, this.credit, this.balance);
//   final String date;
//   final String particulars;
//   final String refno;
//   final String reading;
//   final String usage;
//   final double debit;
//   final double credit;
//   final double balance;

//   String getIndex(int index) {
//     switch (index) {
//       case 0:
//         return date;
//       case 1:
//         return particulars;
//       case 2:
//         return refno;
//       case 3:
//         return reading;
//       case 4:
//         return usage;
//       case 5:
//         return debit.toString();
//       case 6:
//         return credit.toString();
//       case 7:
//         return balance.toString();
//     }
//     return '';
//   }
// }

class viewClients {
  const viewClients(
    this.refNum,
    this.name,
    this.totalReceivables,
    this.current,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.i,
    this.j,
  );

  final String refNum;
  final String name;
  final double totalReceivables;
  final double current;
  final double a;
  final double b;
  final double c;
  final double d;
  final double e;
  final double f;
  final double g;
  final double h;
  final double i;
  final double j;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return refNum;
      case 1:
        return name;
      case 2:
        return totalReceivables.toString();
      case 3:
        return current.toString();
      case 4:
        return a.toString();
      case 5:
        return b.toString();
      case 6:
        return c.toString();
      case 7:
        return d.toString();
      case 8:
        return e.toString();
      case 9:
        return f.toString();
      case 10:
        return g.toString();
      case 11:
        return h.toString();
      case 12:
        return i.toString();
      case 13:
        return j.toString();
    }
    return '';
  }
}
