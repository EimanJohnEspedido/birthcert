/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data.dart';

Future<Uint8List> generateDisconnection(
    PdfPageFormat pageFormat, CustomData data) async {
  final accounts = [
    {
      'accountNumber': '12-345678',
      'accountName': 'DELA CRUZ, JUAN',
      'currentBalance': 8323.23,
      'meterNumber': '38971237627',
      'location': 'TAAL BATANGAS'
    },
    {
      'accountNumber': '12345678',
      'accountName': 'DELA CRUZ, JUAN',
      'currentBalance': 8323.23,
      'meterNumber': '38971237627',
      'location': 'TAAL BATANGAS'
    },
    {
      'accountNumber': '12345678',
      'accountName': 'DELA CRUZ, JUAN',
      'currentBalance': 8323.23,
      'meterNumber': '38971237627',
      'location': 'TAAL BATANGAS'
    },
    {
      'accountNumber': '12345678',
      'accountName': 'DELA CRUZ, JUAN',
      'currentBalance': 8323.23,
      'meterNumber': '38971237627',
      'location': 'TAAL BATANGAS'
    },
  ];

  final entries = accounts.map((account) {
    return Entry(
      account['accountNumber'].toString(),
      account['accountName'].toString(),
      account['currentBalance'] as double,
      account['location'].toString(),
      account['meterNumber'].toString(),
    );
  }).toList();

  final sheet = ReadingSheet(
    invoiceNumber: '982347',
    entries: entries,
    customerName: 'Abraham Swearegin',
    customerAddress: '54 rue de Rivoli\n75001 Paris, France',
    paymentInfo:
        '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.white,
    accentColor: PdfColors.black,
    dateIssued: DateTime.now(),
    dueDate: DateTime.now(),
  );

  return await sheet.buildPdf(pageFormat);
}

class ReadingSheet {
  ReadingSheet({
    required this.entries,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
    required this.dateIssued,
    required this.dueDate,
  });

  List<Entry> entries;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final DateTime dateIssued;
  final DateTime dueDate;

  static const _darkColor = PdfColors.black;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _subTotal =>
      entries.map<double>((p) => p.arrears).reduce((a, b) => a + b);

  dynamic twdLogo;
  Map<String, dynamic> zoneSummaryList = {};

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();
    //   twdLogo = pw.MemoryImage(
    //   (await rootBundle.load('assets/twd_logo.png')).buffer.asUint8List(),
    // );

    //_logo = await rootBundle.loadString('assets/twd_logo.svg');
    //_bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.urbanistRegular(),
          await PdfGoogleFonts.urbanistBold(),
          await PdfGoogleFonts.urbanistItalic(),
        ),
        header: _buildHeader,
        build: (context) => [
          _accountHeader(context),
          _consumersTable(context),
          _collectionTableFooter(context),
          _signatories(context)
        ],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.urbanistRegular(),
          await PdfGoogleFonts.urbanistBold(),
          await PdfGoogleFonts.urbanistItalic(),
        ),
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: -35),
            child: _noticeEntry(context),
          ),
        ],
      ),
    );

    //  doc.addPage(
    //   pw.Page(
    //       pageTheme: _buildTheme(
    //         pageFormat,
    //         await PdfGoogleFonts.urbanistRegular(),
    //         await PdfGoogleFonts.urbanistBold(),
    //         await PdfGoogleFonts.urbanistItalic(),
    //       ),
    //       build: (context) {
    //         return pw.Column(children: [
    //             _buildHeader(context),
    //             _accountHeader(context),
    //             pw.Divider(),
    //             _collectionSummaryBreakdown(context),
    //             pw.SizedBox(height: 10),
    //             //_collectionSummary(context)
    //         ]);
    //       }),
    // );

    // doc.addPage(
    //   pw.Page(
    //       pageTheme: _buildTheme(
    //         pageFormat,
    //         await PdfGoogleFonts.urbanistRegular(),
    //         await PdfGoogleFonts.urbanistBold(),
    //         await PdfGoogleFonts.urbanistItalic(),
    //       ),
    //       build: (context) {
    //         return pw.Column(children: [
    //           _buildHeader(context),
    //           _accountHeader(context),
    //           _certification(context),
    //         ]);
    //       }),
    // );

    final output = await doc.save();
    // final blob = html.Blob([output], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // final anchor = html.document.createElement('a') as html.AnchorElement
    //   ..href = url
    //   ..style.display = 'none'
    //   ..download = 'JobOrder.pdf'; // Set the desired filename here
    // html.document.body?.children.add(anchor);
    // anchor.click();
    // html.document.body?.children.remove(anchor);
    // html.Url.revokeObjectUrl(url);
    // Return the PDF file content
    return output;
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.black,
        ),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.max,
                children: [
                  // pw.Container(
                  //   width: 70,
                  //   height:80,
                  //   child: pw.Image(twdLogo)),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, top: 0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'TAAL WATER DISTRICT',
                              style: pw.TextStyle(
                                  fontSize: 15, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              'Calle V. Illustre Cor. Calle C. Sanchez, Taal, Batangas',
                              style: const pw.TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'DISCONNECTION LIST',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Page ${context.pageNumber}/${context.pagesCount}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
                      ),
                    ),
                  ]),
            ]),
      ),
    );
  }

  pw.Widget _noticeHeader(pw.Context context) {
    return pw.Container(
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisSize: pw.MainAxisSize.max,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, top: 0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'TAAL WATER DISTRICT',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              'CALLE V. ILLUSTRE CIR. CALLE C. SANCHEZ, TAAL, BATANGAS',
                              style: const pw.TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          children: [
                            pw.Text(
                              'DISCONNECTION ORDER',
                              style: const pw.TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  pw.Widget _accountHeader(pw.Context context) {
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 10),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 65,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Zone',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '22',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 65,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Book',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text('1',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Date Issued',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      _formatDate(dateIssued),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 120,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Due Date',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      _formatDate(dueDate),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                ]),
          ),
        ));
  }

  pw.Widget _accountDetails(pw.Context context) {
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 0),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal),
            child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 90,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Account No.',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '01-019999',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 90,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Name',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text('DELA CRUZ, JUAN',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 90,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Address',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text('TAAl, BATANGAS',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.normal)),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 120,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Meter No.',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '27836781267',
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 120,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Meter Brand',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'EDMI',
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                ]),
          ),
        ));
  }

  pw.Widget _accountStatement(pw.Context context) {
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 0),
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(top: 3),
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal),
            child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 140,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'PERIOD COVERED',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Column(children: [
                                  pw.Row(children: [
                                    pw.Text(
                                      '5/1/2023',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                  ]),
                                  pw.Row(children: [
                                    pw.Text(
                                      '7/1/2023',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.normal,
                                      ),
                                    ),
                                  ])
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'CURRENT',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '123,456.00',
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'ARREARS',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '123,456.00',
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'OTHER',
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '123,456.00',
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Container(
                          width: 140,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(
                                  width: .1, style: pw.BorderStyle.dashed),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'TOTAL',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ])),
                              pw.Expanded(
                                  child: pw.Row(children: [
                                pw.Text(
                                  ':',
                                ),
                              ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      '999,999.00',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    ),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                ]),
          ),
        ));
  }

  pw.Widget _accountSign(pw.Context context) {
    return pw.Padding(
        padding: const pw.EdgeInsets.only(top: 0),
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 5),
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal),
            child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Received By :',
                                    ),
                                  ])),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    width: 150,
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(
                                      width: 0.1,
                                      style: pw.BorderStyle.solid,
                                    )))),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          width: 160,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Expanded(
                                  flex: 1,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Action Taken :',
                                    ),
                                  ])),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Container(
                                    width: 150,
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(
                                      width: 0.1,
                                      style: pw.BorderStyle.solid,
                                    )))),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  pw.SizedBox(width: 50),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 100,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text(
                                      'Date :',
                                    ),
                                  ])),
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text('July 26, 2023',
                                        style: const pw.TextStyle(
                                          decoration:
                                              pw.TextDecoration.underline,
                                        )),
                                  ])),
                            ],
                          ),
                        ),
                      ]),
                ]),
          ),
        ));
  }

  pw.Widget _signatories(pw.Context context) {
    return pw.Column(children: [
      pw.SizedBox(height: 10),
      pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 8,
              ),
              child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Row(children: [
                                pw.Text('Prepared By:',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ])),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text('CRISTINA R. ROMANES',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Container(
                            height: 0.5,
                            width: 150,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 0.5),
                            ),
                          ),
                          pw.Row(children: [
                            pw.Text('Customer Service Clerk'),
                          ]),
                        ]),
                  ]),
            ),
            pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 8,
              ),
              child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Row(children: [
                                pw.Text('Received By:',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ])),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 40),
                    pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Container(
                            height: 0.5,
                            width: 150,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  color: PdfColors.black, width: 0.5),
                            ),
                          ),
                        ]),
                  ]),
            ),
          ]),
    ]);
  }

  pw.Widget _collectionTableFooter(pw.Context context) {
    return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColors.black,
          ),
        ),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [_collectionSubTotal(context)]));
  }

  pw.Widget _noticeDisclaimer(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.black,
        ),
      ),
      child: pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('Ito po ay ', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text('MAINTENANCE ORDER FOR DISCONNECTION ',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      pw.Text('na nakasaad ang kabuuang ',
                          style: const pw.TextStyle(fontSize: 8)),
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                          'halaga ng inyong pagkakautang ayon sa aming talaan. ',
                          style: const pw.TextStyle(fontSize: 8)),
                    ]),
              ])),
    );
  }

  pw.Widget _noticeSettle(pw.Context context) {
    return pw.Container(
      child: pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0, bottom: 0),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('PLEASE SETTLE YOUR ACCOUNTS ON OR BEFORE',
                          style: pw.TextStyle(
                              fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ]),
              ])),
    );
  }

  pw.Widget _noticeDisregard(pw.Context context) {
    return pw.Container(
      child: pw.Padding(
          padding: const pw.EdgeInsets.only(top: 0),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('PLEASE DISREGARD THIS IF PAYMENT HAD BEEN MADE',
                          style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              decoration: pw.TextDecoration.underline)),
                    ]),
                pw.SizedBox(height: 8),
                pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                          width: .1, style: pw.BorderStyle.dashed),
                    ),
                  ),
                )
              ])),
    );
  }

  pw.Widget _noticeEntry(pw.Context context) {
    return pw.ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return pw.Column(children: [
            _noticeHeader(context),
            _accountDetails(context),
            _noticeDisclaimer(context),
            _accountStatement(context),
            pw.Divider(),
            _noticeSettle(context),
            _accountSign(context),
            pw.SizedBox(height: 5),
            _noticeDisregard(context),
          ]);
        });
  }

  pw.Widget _collectionSummaryBreakdown(pw.Context context) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
              ),
            ),
            width: 300,
            child: pw.Column(children: [
              pw.Text('Summary of Other Collections',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _otherCollections(context),
              _otherCollectionsSummary(context)
            ]),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
              ),
            ),
            width: 250,
            child: pw.Column(children: [
              pw.Text('Cash Breakdown',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _cashBreakdown(context),
              _cashBreakdownSummary(context)
            ]),
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
              ),
            ),
            width: 150,
            child: pw.Column(children: [
              pw.Text('Summary by Zone',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _zoneBreakdown(context),
              _zoneBreakdownSummary(context)
            ]),
          ),
        ]);
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '$customerName\n',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: customerAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Column(
        mainAxisSize: pw.MainAxisSize.max,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(children: [
            pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 8,
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Row(children: [
                                pw.Text(
                                    'Inspection performed in the presence of:',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ])),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Container(
                      height: 0.5,
                      width: 250,
                      decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(color: PdfColors.black, width: 0.5),
                      ),
                    ),
                    pw.Row(children: [
                      pw.SizedBox(width: 20),
                      pw.Text(
                          'Applicant\'s or Representative\'s Signature over Printed Name',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ]),
                  ]),
            ),
            pw.SizedBox(width: 50),
            pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 8,
              ),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 2,
                              child: pw.Row(children: [
                                pw.Text('Inspection performed by:',
                                    style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold)),
                              ])),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Container(
                      height: 0.5,
                      width: 150,
                      decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(color: PdfColors.black, width: 0.5),
                      ),
                    ),
                    pw.Row(children: [
                      pw.SizedBox(width: 60),
                      pw.Text('Maintenance',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ]),
                  ]),
            )
          ]),
          pw.SizedBox(height: 20),
          pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.DefaultTextStyle(
                  style: const pw.TextStyle(
                    fontSize: 8,
                  ),
                  child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.max,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 250,
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                  flex: 2,
                                  child: pw.Row(children: [
                                    pw.Text('Installed By:',
                                        style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold)),
                                  ])),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 30),
                        pw.Container(
                          height: 0.5,
                          width: 250,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                color: PdfColors.black, width: 0.5),
                          ),
                        ),
                        pw.Row(
                            mainAxisSize: pw.MainAxisSize.max,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.SizedBox(width: 70),
                              pw.Text('Signature over Printed Name / Date',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ]),
                      ]),
                ),
              ])
        ]);
  }

  pw.Widget _consumersTable(pw.Context context) {
    const tableHeaders = [
      'ACCOUNT NO.',
      'NAME',
      'METER NO.',
      'ADDRESS',
      'ARREARS',
      'SIGNATURE/DATE'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 25,
      cellHeight: 1,
      cellPadding: const pw.EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 5),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
        4: const pw.FlexColumnWidth(2),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: .1, style: pw.BorderStyle.dashed),
        ),
      ),
      headers: List<String>.generate(
          tableHeaders.length, (col) => tableHeaders[col],
          growable: true),
      data: List<List<String>>.generate(
        entries.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => entries[row].getIndex(col),
        ),
      ),
    );
  }

  pw.Widget _collectionTotal(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 25,
      cellHeight: 20,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
        5: const pw.FlexColumnWidth(1),
        6: const pw.FlexColumnWidth(1),
        7: const pw.FlexColumnWidth(1),
        8: const pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      data: [
        ['Reference No:', '387126382716', ' ', '$_subTotal'],
      ],
    );
  }

  pw.Widget _collectionSubTotal(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 25,
      cellHeight: 20,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
        4: const pw.FlexColumnWidth(2),
        5: const pw.FlexColumnWidth(2),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      data: [
        ['Total Consumers: ${entries.length}', '', '', '', '$_subTotal', '']
      ],
    );
  }

  pw.Widget _otherCollections(pw.Context context) {
    const tableHeaders = ['Description', 'Amount'];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 15,
      cellHeight: 1,
      cellPadding: const pw.EdgeInsets.only(top: 2, bottom: 0, left: 5, right: 5),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      headers: List<String>.generate(
          tableHeaders.length, (col) => tableHeaders[col],
          growable: true),
      data: [
        ['MSR - Recon. Fee', '600.00'],
        ['MSR - Recon. Fee', '600.00'],
        ['MSR - Recon. Fee', '600.00']
      ],
    );
  }

  pw.Widget _otherCollectionsSummary(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      cellPadding: const pw.EdgeInsets.only(top: 2, bottom: 0, left: 5, right: 5),
      headerHeight: 15,
      cellHeight: 1,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      data: [
        ['Total', '600.00']
      ],
    );
  }

  pw.Widget _cashBreakdown(pw.Context context) {
    const tableHeaders = ['Denomination', '', 'Pcs', 'Amount'];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 15,
      cellHeight: 1,
      cellPadding: const pw.EdgeInsets.only(top: 2, bottom: 0, left: 5, right: 5),
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(0.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      headers: List<String>.generate(
          tableHeaders.length, (col) => tableHeaders[col],
          growable: true),
      data: [
        ['1000', 'x', '100.00', '100,000.00'],
        ['500', 'x', '8.00', '4,000.00']
      ],
    );
  }

  pw.Widget _cashBreakdownSummary(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 15,
      cellHeight: 1,
      cellPadding: const pw.EdgeInsets.only(top: 2, bottom: 0, left: 5, right: 5),
      cellAlignments: {
        0: pw.Alignment.centerRight,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(0.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      data: [
        ['Total', '', '', '100,000.00'],
      ],
    );
  }

  pw.Widget _zoneBreakdown(pw.Context context) {
    const tableHeaders = ['Zone', 'Bills', 'Amount'];

    final sortedZones = zoneSummaryList.keys.toList()..sort();

    final tableData = sortedZones.map((entry) {
      final int count = zoneSummaryList[entry]['count'];
      final int amount = zoneSummaryList[entry]['amount'];
      return [entry, count.toString(), amount.toString()];
    }).toList();

    return pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.center,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 15,
        cellHeight: 1,
        cellPadding: const pw.EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(0.5),
          1: const pw.FlexColumnWidth(0.5),
          2: const pw.FlexColumnWidth(1)
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col],
            growable: true),
        data: tableData);
  }

  pw.Widget _zoneBreakdownSummary(pw.Context context) {
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.center,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 15,
      cellHeight: 1,
      cellPadding: const pw.EdgeInsets.only(top: 2, bottom: 0, left: 5, right: 5),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(0.5),
        2: const pw.FlexColumnWidth(1)
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      data: [
        ['Total', '65', '100,000.00']
      ],
    );
  }

  pw.Widget _feeTable(pw.Context context) {
    const tableHeaders = [
      'Guarantee Deposit',
      'Registration Fee',
      'SACO Materials',
      'Paid WBOR No',
      'Dated'
    ];

    return pw.Table.fromTextArray(
        border: pw.TableBorder.all(),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 25,
        cellHeight: 20,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
          4: pw.Alignment.center,
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col],
            growable: true),
        data: [
          [' ', ' ', ' ', ' ', ' '],
        ]);
  }

  pw.Widget _receivedTable(pw.Context context) {
    return pw.Table.fromTextArray(
        border: pw.TableBorder.all(),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 25,
        cellHeight: 20,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
          3: pw.Alignment.centerLeft,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(3),
          2: const pw.FlexColumnWidth(2),
          3: const pw.FlexColumnWidth(3),
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        data: [
          ['Received By', ' ', 'Requested By', ' '],
          ['Date', ' ', 'Date', ' '],
        ]);
  }

  pw.Widget _requestTable(pw.Context context) {
    const tableHeaders = [
      'JO REQUEST',
      'PARTICULARS',
    ];

    return pw.Table.fromTextArray(
        border: pw.TableBorder.all(),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 25,
        cellHeight: 20,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(3),
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col],
            growable: true),
        data: [
          ['Reconnection', 'Sample request description'],
        ]);
  }

  pw.Widget _otherInfoTable(pw.Context context) {
    const tableHeaders = [
      'WATER METER',
      'DISCONNECTION DETAILS',
    ];

    return pw.Table.fromTextArray(
        border: pw.TableBorder.all(),
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 25,
        cellHeight: 25,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(3),
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col],
            growable: true),
        data: [
          [
            '[  ] Voluntary   [  ] Involuntary',
            'Date Disconnected:          [  ] Padlock           [  ] Tapping Point'
          ],
          [
            ' ',
            '                                          [  ] Water Meter    [  ] Mainline'
          ]
        ]);
  }

  pw.Widget _remarksTable(pw.Context context) {
    const tableHeaders = [
      'REMARKS',
    ];

    return pw.Table.fromTextArray(
        border: pw.TableBorder.all(),
        headerDecoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
          border: pw.Border.all(
            color: PdfColors.black, // Set the color to black
            width: 0.5, // Set the border width as desired
          ),
        ),
        headerHeight: 25,
        cellHeight: 25,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(3),
        },
        headerStyle: pw.TextStyle(
          color: _baseTextColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: _darkColor,
          fontSize: 8,
        ),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col],
            growable: true),
        data: [
          ['  '],
          ['  '],
        ]);
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Seq',
      'Account No',
      'Name & Address',
      'Type',
      'Meter No',
      'Arrears',
      'Previous',
      'Current'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
        border: pw.Border.all(
          color: PdfColors.black, // Set the color to black
          width: 0.5, // Set the border width as desired
        ),
      ),
      headerHeight: 25,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(5),
        3: const pw.FlexColumnWidth(2),
        4: const pw.FlexColumnWidth(3),
        5: const pw.FlexColumnWidth(2),
        6: const pw.FlexColumnWidth(2),
        7: const pw.FlexColumnWidth(2),
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 8,
      ),
      headers: List<String>.generate(
          tableHeaders.length, (col) => tableHeaders[col],
          growable: true),
      data: List<List<String>>.generate(
        entries.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => entries[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  final numberFormat = NumberFormat('#,##0.00');
  final formatted = numberFormat.format(amount);
  return formatted;
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMd('en_US');
  return format.format(date);
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('MM/dd/yy HH:mm');
  final formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

Map<String, dynamic> zoneSummary(List<dynamic> payments) {
  final zoneData = <String, dynamic>{};

  print(payments);

  for (var payment in payments) {
    final String zone = payment['accountNumber'].substring(0, 2);

    if (!zoneData.containsKey(zone)) {
      // Add the amount to the existing zone
      zoneData[zone] = {'count': 0, 'amount': 0};
    }

    final List<dynamic> bills = payment['bills'];

    num zoneAmount = 0;
    for (dynamic bill in bills) {
      final amount = (payment.containsKey('others'))
          ? bill['amountCharged'] as num?
          : bill['amount'] as num?;
      if (amount != null) {
        zoneAmount += amount;
      }
    }

    // Update zone data
    zoneData[zone]['count'] += bills.length;
    zoneData[zone]['amount'] += zoneAmount;
  }

  return zoneData;
}

class Entry {
  const Entry(
    this.accountNumber,
    this.name,
    this.arrears,
    this.location,
    this.meterNumber,
  );

  final String accountNumber;
  final String name;
  final double arrears;
  final String location;
  final String meterNumber;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return accountNumber;
      case 1:
        return name;
      case 2:
        return meterNumber;
      case 3:
        return location;
      case 4:
        return arrears.toString();
    }
    return '';
  }
}
