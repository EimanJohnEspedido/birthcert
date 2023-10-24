import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data.dart';
import 'dc.dart';

// double credit1 = 0;
// double total0 = 0;
// double total1 = 0;
// double debit1 = 0;
// double _grandTotal = 0;

Future<Uint8List> generateRecievables(
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
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
    },
    {
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
    },
    {
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
    },
    {
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
    },
    {
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
    },
    {
      "refNum": "00-303377",
      "name": "Karyn Cadwallader",
      "totalReceivables": 933.4,
      "current": 853.5,
      "month2": 616.8,
      "month3": 310.4,
      "month4": 874.5,
      "month5_6": 242.2,
      "month7_12": 910.2,
      "year1_2": 475.2,
      "year2_3": 183.6,
      "year3_4": 246.6,
      "year4_5": 303.4,
      "year5Above": 56.9
    },
    {
      "refNum": "00-506244",
      "name": "Tabbitha Nortunen",
      "totalReceivables": 351.6,
      "current": 392.4,
      "month2": 910.4,
      "month3": 416.7,
      "month4": 789.4,
      "month5_6": 57.5,
      "month7_12": 280.6,
      "year1_2": 64.9,
      "year2_3": 588.9,
      "year3_4": 704.2,
      "year4_5": 563.6,
      "year5Above": 256.8
    },
    {
      "refNum": "41-753833",
      "name": "Ervin Headan",
      "totalReceivables": 333.3,
      "current": 389.9,
      "month2": 182.9,
      "month3": 926.6,
      "month4": 707.0,
      "month5_6": 314.7,
      "month7_12": 991.7,
      "year1_2": 956.3,
      "year2_3": 295.6,
      "year3_4": 131.1,
      "year4_5": 59.2,
      "year5Above": 523.2
    },
    {
      "refNum": "88-947385",
      "name": "Emalia Steddall",
      "totalReceivables": 149.9,
      "current": 784.3,
      "month2": 523.5,
      "month3": 845.8,
      "month4": 566.8,
      "month5_6": 458.4,
      "month7_12": 762.5,
      "year1_2": 750.9,
      "year2_3": 492.0,
      "year3_4": 467.4,
      "year4_5": 147.5,
      "year5Above": 138.9
    },
    {
      "refNum": "97-718002",
      "name": "Fredelia Yakobowitz",
      "totalReceivables": 381.8,
      "current": 276.4,
      "month2": 256.0,
      "month3": 348.2,
      "month4": 527.6,
      "month5_6": 294.4,
      "month7_12": 891.0,
      "year1_2": 187.3,
      "year2_3": 505.9,
      "year3_4": 348.5,
      "year4_5": 886.8,
      "year5Above": 19.2
    },
    {
      "refNum": "88-504515",
      "name": "Coralie Meachan",
      "totalReceivables": 702.3,
      "current": 707.8,
      "month2": 334.9,
      "month3": 905.6,
      "month4": 946.5,
      "month5_6": 310.1,
      "month7_12": 509.3,
      "year1_2": 214.2,
      "year2_3": 478.8,
      "year3_4": 910.8,
      "year4_5": 997.6,
      "year5Above": 745.8
    },
    {
      "refNum": "23-408838",
      "name": "Kathi Castles",
      "totalReceivables": 872.0,
      "current": 917.8,
      "month2": 206.4,
      "month3": 595.1,
      "month4": 822.6,
      "month5_6": 928.8,
      "month7_12": 54.9,
      "year1_2": 84.2,
      "year2_3": 879.4,
      "year3_4": 882.9,
      "year4_5": 376.8,
      "year5Above": 27.9
    },
    {
      "refNum": "52-188895",
      "name": "Stacie Lindeman",
      "totalReceivables": 103.2,
      "current": 300.9,
      "month2": 832.3,
      "month3": 473.5,
      "month4": 843.2,
      "month5_6": 132.6,
      "month7_12": 731.4,
      "year1_2": 686.1,
      "year2_3": 484.3,
      "year3_4": 760.6,
      "year4_5": 135.7,
      "year5Above": 198.1
    },
    {
      "refNum": "28-505224",
      "name": "Loise Gerardin",
      "totalReceivables": 232.8,
      "current": 199.0,
      "month2": 915.3,
      "month3": 977.3,
      "month4": 724.6,
      "month5_6": 569.5,
      "month7_12": 949.0,
      "year1_2": 484.3,
      "year2_3": 356.6,
      "year3_4": 584.4,
      "year4_5": 222.4,
      "year5Above": 970.2
    },
    {
      "refNum": "58-227954",
      "name": "Euphemia Gilvear",
      "totalReceivables": 483.8,
      "current": 624.1,
      "month2": 786.0,
      "month3": 49.6,
      "month4": 113.4,
      "month5_6": 873.5,
      "month7_12": 827.9,
      "year1_2": 378.9,
      "year2_3": 533.8,
      "year3_4": 528.1,
      "year4_5": 696.8,
      "year5Above": 271.7
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
    return Clients(
      objSample['refNum'].toString(),
      objSample['name'].toString(),
      objSample['totalReceivables'] as double,
      objSample['current'] as double,
      objSample['month2'] as double,
      objSample['month3'] as double,
      objSample['month4'] as double,
      objSample['month5_6'] as double,
      objSample['month7_12'] as double,
      objSample['year1_2'] as double,
      objSample['year2_3'] as double,
      objSample['year3_4'] as double,
      objSample['year4_5'] as double,
      objSample['year5Above'] as double,
    );
  }).toList();

  final statementOfAccount = Statement(
    client: client,
    refNum: '',
    name: '',
    totalReceivables: 0.0,
    current: 0.0,
    month2: 0.0,
    month3: 0.0,
    month4: 0.0,
    month5_6: 0.0,
    month7_12: 0.0,
    year1_2: 0.0,
    year2_3: 0.0,
    year3_4: 0.0,
    year4_5: 0.0,
    year5Above: 0.0,
    baseColor: PdfColors.white,
    accentColor: PdfColors.black,
  );

  return await statementOfAccount.buildPdf(pageFormat.landscape);
}

class Statement {
  Statement({
    required this.client,
    required this.refNum,
    required this.name,
    required this.totalReceivables,
    required this.current,
    required this.month2,
    required this.month3,
    required this.month4,
    required this.month5_6,
    required this.month7_12,
    required this.year1_2,
    required this.year2_3,
    required this.year3_4,
    required this.year4_5,
    required this.year5Above,
    required this.accentColor,
    required this.baseColor,
  });

  final List<Clients> client;
  final String refNum;
  final String name;
  final double totalReceivables;
  final double current;
  final double month2;
  final double month3;
  final double month4;
  final double month5_6;
  final double month7_12;
  final double year1_2;
  final double year2_3;
  final double year3_4;
  final double year4_5;
  final double year5Above;
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
        //footer: _buildFooter,
        build: (context) => [
          //_timeHeader(context),
          //_buildHeader1(context),
          //_contentHeader(context),
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
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Column(children: [
            pw.Column(children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 25),
                      pw.Text('Run Date : ${_formatDate(DateTime.now())}',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: (10),
                          )),
                      pw.Text('Run Time : ${_formatTime(DateTime.now())}',
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: (10),
                          ))
                    ]),
                pw.SizedBox(width: 35),
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
                          style: pw.TextStyle(fontSize: 11)),
                    ]),
                pw.SizedBox(width: 60),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Page ${context.pageNumber}/${context.pagesCount}',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.black,
                          )),
                    ]),
              ]),
            ]),
            pw.Column(children: [
              //Header1
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(height: 15),
                                pw.Text('Zone 01',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: (10))),
                                pw.Text('Book 1',
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: (10),
                                    ))
                              ]),
                          pw.SizedBox(width: 15),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(
                                  'AGING OF ACCOUNT RECEIVABLES DETAILS - Water Bill Only',
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.Text('AS OF ${_formatDate(DateTime.now())}',
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: (10),
                                    )),
                                pw.Text('ACTIVE & INACTIVE',
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: (10),
                                    ))
                              ]),
                        ])
                  ])
            ])
          ])
        ]));
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

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
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
  //                   //pw.Text(_formatCurrency(total0)),
  //                 ],
  //               ),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Total Debit:'),
  //                   //pw.Text(_formatCurrency(debit1)),
  //                 ],
  //               ),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text('Total Credit:'),
  //                   //pw.Text(_formatCurrency(credit1)),
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
  //                   //pw.Text(_formatCurrency(_grandTotal)),
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
    const summaryHeaders = [
      'Zone',
      'STATUS',
      'Current + OverDue',
      'Amount',
      'No.',
      '31-60',
      'Amount',
      'No.',
      '61-180',
      'Amount',
      'No.',
      '181-365',
      'Amount',
      'No.',
      '1 Year Up',
      'Amount',
      'No.',
      'Total',
      'Amount',
      'No.',
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
      headerHeight: 25,
      cellHeight: 20,
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
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
        10: pw.Alignment.centerRight,
        11: pw.Alignment.centerRight,
        12: pw.Alignment.centerRight,
        13: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(2.7),
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
        fontSize: 9,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 9,
      ),
      headerCellDecoration: pw.BoxDecoration(
          border: pw.Border(
              bottom: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              left: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              right: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed),
              top: pw.BorderSide(width: 1, style: pw.BorderStyle.dashed))),
      headers: List<String>.generate(
        summaryHeaders.length,
        (col) => summaryHeaders[col],
      ),
      data: List<List<String>>.generate(
        client.length,
        (row) => List<String>.generate(
          summaryHeaders.length,
          (col) => client[row].getIndex(col),
        ),
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
      headerHeight: 25,
      cellHeight: 20,
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
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
        10: pw.Alignment.centerRight,
        11: pw.Alignment.centerRight,
        12: pw.Alignment.centerRight,
        13: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(2.7),
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
        fontSize: 9,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 9,
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

String _formatTime(DateTime date) {
  final format = DateFormat('HH:mm:ss');
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

class Clients {
  const Clients(
    this.refNum,
    this.name,
    this.totalReceivables,
    this.current,
    this.month2,
    this.month3,
    this.month4,
    this.month5_6,
    this.month7_12,
    this.year1_2,
    this.year2_3,
    this.year3_4,
    this.year4_5,
    this.year5Above,
  );

  final String refNum;
  final String name;
  final double totalReceivables;
  final double current;
  final double month2;
  final double month3;
  final double month4;
  final double month5_6;
  final double month7_12;
  final double year1_2;
  final double year2_3;
  final double year3_4;
  final double year4_5;
  final double year5Above;

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
        return month2.toString();
      case 5:
        return month3.toString();
      case 6:
        return month4.toString();
      case 7:
        return month5_6.toString();
      case 8:
        return month7_12.toString();
      case 9:
        return year1_2.toString();
      case 10:
        return year2_3.toString();
      case 11:
        return year3_4.toString();
      case 12:
        return year4_5.toString();
      case 13:
        return year5Above.toString();
    }
    return '';
  }
}
