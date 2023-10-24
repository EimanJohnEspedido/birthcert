import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:excel/excel.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

Future generateDCRExcel(
    bool save,
    String collectorId,
    String collectorName,
    List<DenominationsRecord> denominations,
    CollectionRemittanceRecord collectionRemittance,
    DateTime collectionDate) async {
  //DateTime now = DateTime.now();
  DateTime now = collectionDate;

  final dailyCollectionDateId = DateFormat('MM-dd-yyyy').format(now);
  final dcRef = FirebaseFirestore.instance.collection('dailyCollections');
  final collectionRecord = await dcRef.doc(dailyCollectionDateId).get();

  double cashOnHand = 0;
  String orFrom = '';
  String orTo = '';
  String referenceNo = collectionRemittance.referenceNumber;
  List<Map<String, dynamic>> accounts = [];

  if (collectionRecord.exists) {
    final collectionData = collectionRecord.data();
    cashOnHand = collectionData!['$collectorId']['cashOnHand'];
    orFrom = collectionData!['$collectorId']['orFrom'];
    orTo = collectionData!['$collectorId']['orTo'];

    collectionRemittance.reference.update({'orFrom': orFrom, 'orTo': orTo});
  }

  final paymentRecords = await FirebaseFirestore.instance
      .collection('paymentRecords')
      .where('ORDate', isEqualTo: getDateOnly(now))
      .where('processedBy', isEqualTo: collectorId)
      .where('cancelled', isEqualTo: false)
      .get();

  if (paymentRecords.docs.isNotEmpty) {
    accounts = paymentRecords.docs.map((docs) => docs.data()).toList();
  }

  // for(var account in accounts.keys) {
  //    return Entry(
  // //   account['sequenceNumber'].toString(),
  // //   '(C) ${account['sequenceNumber']}-${account['accountNumber']}',
  // //   account['accountName'].toString() ,
  // //   account['type'].toString(),
  // //   account['meterNumber'].toString(),
  // //   'Asahi', // Assuming meterBrand is always 'Asahi'
  // //   account['balance'] as double,
  // //   account['previous'] as int,
  // //   '________',
  // // );
  // }

  final report = Report(
      orDate: now,
      entries: accounts,
      collector: collectorName,
      position: 'Teller',
      totalCollection: cashOnHand,
      orFrom: orFrom,
      orTo: orTo,
      paymentEntries: accounts,
      denominations: denominations,
      referenceNumber: referenceNo);

  return await report.buildExcel();
}

class Report {
  Report(
      {required this.orDate,
      required this.collector,
      required this.position,
      required this.entries,
      required this.totalCollection,
      required this.orFrom,
      required this.orTo,
      required this.paymentEntries,
      required this.denominations,
      required this.referenceNumber});

  List entries;
  final DateTime orDate;
  final String collector;
  final String position;
  final String orFrom;
  final String orTo;
  final double totalCollection;

  final dynamic paymentEntries;
  final List<DenominationsRecord> denominations;
  final String referenceNumber;

  double get _subTotal =>
      entries.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _subTotalAmount =>
      entries.map<double>((p) => p.amount).reduce((a, b) => a + b);

  double get _subTotalPenalty =>
      entries.map<double>((p) => p.penalty).reduce((a, b) => a + b);

  double get _subTotalSurcharge =>
      entries.map<double>((p) => p.surcharge).reduce((a, b) => a + b);

  double get _subTotalDiscount =>
      entries.map<double>((p) => p.seniorDiscount).reduce((a, b) => a + b);

  double get _subTotalOthers =>
      entries.map<double>((p) => p.others).reduce((a, b) => a + b);

  List<List<dynamic>> tableData = [];
  List<List<dynamic>> chargesTableData = [];
  List<List<dynamic>> denominationsTableData = [];
  Map<String, dynamic> summaryZones = {};
  Map<String, dynamic> summaryCharges = {};

  String totalBillCount = '0';
  String totalBillAmount = '0.00';
  String totalChargesAmount = '0.00';
  String totalCashBreakdownAmount = '0.00';

  Future<void> buildExcel() async {
    final excel = Excel.createExcel();

    final table = excel['Sheet1'];

    table.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("D1"),
        customValue: '');
    table.merge(CellIndex.indexByString("A3"), CellIndex.indexByString("D3"),
        customValue: '');
    table.merge(CellIndex.indexByString("H1"), CellIndex.indexByString("I1"),
        customValue: '');

    // Set the title and center it
    table.cell(CellIndex.indexByString("A1"))
      ..value = "TAAL WATER DISTRICT"
      ..cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
        bold: true,
        fontSize: 10,
      );
    table.cell(CellIndex.indexByString("A2"))
      ..value = "CALLE V. ILLUSTRE, COR. CALLE C. SANCHEZ. TAAL, BATANGAS"
      ..cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
        bold: false,
        fontSize: 9,
      );

    table.cell(CellIndex.indexByString("H1"))
      ..value = "CONSOLIDATED DAILY COLLECTION"
      ..cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
        bold: true,
        fontSize: 10,
      );
    table.cell(CellIndex.indexByString("H2")).value = "Date";
    table.cell(CellIndex.indexByString("I2")).value =
        '${formatDateTime(DateTime.now())}';

    table.cell(CellIndex.indexByString("A5")).value = "Date";
    table.cell(CellIndex.indexByString("B5")).value =
        "${_formatMmDdYy(orDate)}";

    table.cell(CellIndex.indexByString("A6")).value = "Collector";
    table.cell(CellIndex.indexByString("B6")).value = '$collector';

    table.cell(CellIndex.indexByString("A7")).value = "O.R. Range";
    table.cell(CellIndex.indexByString("B7")).value = '$orFrom-$orTo';

    table.cell(CellIndex.indexByString("H5")).value = "Cash Collection";
    table.cell(CellIndex.indexByString("I5")).value = totalCollection;

    table.cell(CellIndex.indexByString("H6")).value = "Check Collection";
    table.cell(CellIndex.indexByString("I6")).value = '';

    table.cell(CellIndex.indexByString("H7")).value = "Total";
    table.cell(CellIndex.indexByString("I7")).value = totalCollection;

    List<String> dataList = [
      'O.R. Number',
      'Account No',
      'Consumer Name',
      'Total Amount',
      'CY Arrears',
      'CY Pen',
      'Surcharge',
      'Senior Discount',
      'Others'
    ];
    table.insertRowIterables(dataList, 8, startingColumn: 0);

    summaryZones = zoneSummary(paymentEntries);
    summaryCharges = chargesSummary(paymentEntries);
    int i = 0;
    for (var account in entries) {
      table.cell(CellIndex.indexByString("A${i + 9}")).value =
          account['ORNumber'].toString();
      table.cell(CellIndex.indexByString("B${i + 9}")).value =
          account["accountNumber"].toString();
      table.cell(CellIndex.indexByString("C${i + 9}")).value =
          account['accountName'].toString();
      table.cell(CellIndex.indexByString("D${i + 9}")).value =
          (account.containsKey('others'))
              ? account['others'] as num
              : account['paidAmount'] as num? ?? '';
      table.cell(CellIndex.indexByString("E${i + 9}")).value =
          (account.containsKey('others'))
              ? 0
              : account['billAmount'] as num? ?? '';
      table.cell(CellIndex.indexByString("F${i + 9}")).value =
          (account.containsKey('others'))
              ? ''
              : account['penalty'] as num? ?? '';
      table.cell(CellIndex.indexByString("G${i + 9}")).value =
          (account.containsKey('others'))
              ? 0
              : account['surcharge'] as num? ?? '';
      table.cell(CellIndex.indexByString("H${i + 9}")).value =
          (account.containsKey('others'))
              ? 0
              : account['discount'] as num? ?? '';
      table.cell(CellIndex.indexByString("I${i + 9}")).value =
          (account.containsKey('others')) ? account['others'] as num : '';
      i++;
    }

    // _logo = await rootBundle.loadString('assets/twd_logo.svg');
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');
    // twdLogo = pw.MemoryImage(
    //   (await rootBundle.load('assets/images/TWD_Logo.png'))
    //       .buffer
    //       .asUint8List(),
    // );

    List<dynamic> sortedZones = summaryZones.keys.toList()..sort();
    int totalCount = 0;
    Decimal totalAmount = Decimal.parse('0');
    Decimal totalCharges = Decimal.parse('0');
    Decimal totalCashAmount = Decimal.parse('0');

    tableData = sortedZones.map((entry) {
      int count = summaryZones[entry]['count'];
      Decimal amount = Decimal.parse(summaryZones[entry]['amount'].toString());

      totalCount += count;
      totalAmount += amount;
      return [
        entry,
        count.toString(),
        _formatCurrency(amount.round(scale: 2).toDouble())
      ] as List<dynamic>;
    }).toList();

    chargesTableData = summaryCharges.entries.map((entry) {
      String chargeName = entry.value['name'];
      Decimal amount = Decimal.parse(entry.value['amount'].toString());
      totalCharges += amount;
      return [chargeName, _formatCurrency(amount.round(scale: 2).toDouble())]
          as List<dynamic>;
    }).toList();

    denominationsTableData = denominations.map((entry) {
      Decimal amount = Decimal.parse(entry.total.toString());

      totalCashAmount += amount;
      return [
        entry.name,
        'x',
        entry.count.toString(),
        _formatCurrency(amount.round(scale: 2).toDouble())
      ] as List<dynamic>;
    }).toList();

    totalChargesAmount =
        _formatCurrency(totalCharges.round(scale: 2).toDouble());

    totalBillCount = totalCount.toString();
    totalBillAmount = _formatCurrency(totalAmount.round(scale: 2).toDouble());

    totalCashBreakdownAmount =
        _formatCurrency(totalCashAmount.round(scale: 2).toDouble());

    var fileBytes =
        excel.save(fileName: 'DailyCollection-$collector-$orDate.xlsx');
  }
}

String _formatCurrency(double amount) {
  NumberFormat numberFormat = NumberFormat('#,##0.00');
  final formatted = numberFormat.format(amount);
  return '${formatted}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

String _formatMmDdYy(DateTime date) {
  final format = DateFormat('MM/dd/yyyy');
  return format.format(date);
}

String _formatDateFilename(DateTime date) {
  final format = DateFormat('MM-dd-yyyy');
  return format.format(date);
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('MMMM d, h:mm a');
  final formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

Map<String, dynamic> zoneSummary(List<dynamic> payments) {
  Map<String, dynamic> zoneData = {};
  Map<String, dynamic> chargesData = {};

  for (var payment in payments) {
    String zone = payment['accountNumber'].substring(0, 2);

    if (!zoneData.containsKey(zone)) {
      // Add the amount to the existing zone
      zoneData[zone] = {'count': 0, 'amount': 0.00};
    }

    List<dynamic> bills = payment['bills'];

    Decimal zoneAmount = Decimal.parse('0');
    Decimal chargeAmount = Decimal.parse('0');
    for (dynamic bill in bills) {
      Decimal amount = (payment.containsKey('others'))
          ? Decimal.parse(bill['amountPaid'].toString())
          : Decimal.parse(bill['paidAmount'].toString());

      zoneAmount += amount.round(scale: 2);

      if (bill.containsKey('chargeCode')) {
        String chargeCode = bill['chargeCode'];
        if (!chargesData.containsKey(chargeCode)) {
          chargesData[chargeCode] = {
            //'name': '${resolveChargeName(chargeCode)}',
            'amount': 0
          };
        }

        Decimal amountPaid = Decimal.parse(bill['amountPaid'].toString());
        chargesData[chargeCode]['amount'] +=
            amountPaid.round(scale: 2).toDouble();
      }
    }

    // Update zone data
    zoneData[zone]['count'] += bills.length;
    zoneData[zone]['amount'] += zoneAmount.round(scale: 2).toDouble();
  }

  return zoneData;
}

Map<String, dynamic> chargesSummary(List<dynamic> payments) {
  Map<String, dynamic> chargesData = {};

  for (var payment in payments) {
    List<dynamic> bills = payment['bills'];

    Decimal chargeAmount = Decimal.parse('0');
    for (dynamic bill in bills) {
      if (bill.containsKey('chargeCode')) {
        String chargeCode = bill['chargeCode'];
        if (!chargesData.containsKey(chargeCode)) {
          chargesData[chargeCode] = {
            //'name': '${resolveChargeName(chargeCode)}',
            'amount': 0.00
          };
        }

        Decimal amountPaid = Decimal.parse(bill['amountPaid'].toString());
        chargesData[chargeCode]['amount'] +=
            amountPaid.round(scale: 2).toDouble();
      }
    }
  }

  return chargesData;
}

// String resolveChargeName(String chargeCode) {
//   if (FFAppState().chargeTypeName.containsKey(chargeCode)) {
//     // Category name exists in the cache
//     return FFAppState().chargeTypeName[chargeCode];
//   } else {
//     return "Unknown";
//   }
// }