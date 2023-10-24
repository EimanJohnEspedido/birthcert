import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'data.dart';
import 'examples/calendar.dart';
import 'examples/certificate.dart';
import 'examples/dc.dart';
import 'examples/document.dart';
import 'examples/invoice.dart';
import 'examples/report.dart';
import 'examples/resume.dart';
import 'examples/statement.dart';
import 'examples/recievables.dart';

const examples = <Example>[
  Example('RÉSUMÉ', 'statement.dart', generateSOA),
  Example('DOCUMENT', 'document.dart', generateDocument),
  Example('INVOICE', 'invoice.dart', generateInvoice),
  Example('REPORT', 'report.dart', generateReport),
  Example('CALENDAR', 'calendar.dart', generateCalendar),
  Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
  Example('DISCONNECTION', 'dc.dart', generateDisconnection, true),
  Example('STATEMENT OF ACCOUNT', 'statement.dart', generateSOA, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
