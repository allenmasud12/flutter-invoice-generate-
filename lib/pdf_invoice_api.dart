import 'dart:io';
import 'package:flutter/services.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class PdfInvoiceApi {
  static Future<File> generate(PdfColor color, pw.Font fontFamily) async {
    final pdf = pw.Document();

    final tableHeaders = [
      'Description',
      'Unit Price',
      'Total',
    ];

    final tableData = [
      ['Basic rent', '10000.00', '10000.00'],
      ['Service', '3000.00', '5000.00'],
      ['Water', '700.00', '700.00'],
      ['GAS', '950.00', '950.00'],
      ['Electric', '1205.00', '1205.00'],
      ['Internet', '900.00', '900.00'],
      ['Perking', '1500.00', '1500.00'],
    ];

    // Load the Play Store icon image as an asset
    final playStoreIcon = pw.MemoryImage(
      (await rootBundle.load('assets/play-store.png')).buffer.asUint8List(),
    );

    // Define customer data
    final customers = [
      {
        'name': 'Allen Masud',
        'flatNo': 'LA-01',
        'mobile': '+8801690186441',
        'qrCodeData': 'Invoice ID: 12345, Tenant: Allen Masud',
      },
      {
        'name': 'John Doe',
        'flatNo': 'LA-02',
        'mobile': '+8801790186442',
        'qrCodeData': 'Invoice ID: 67890, Tenant: John Doe',
      },
      {
        'name': 'Jane Smith',
        'flatNo': 'LA-03',
        'mobile': '+8801890186443',
        'qrCodeData': 'Invoice ID: 54321, Tenant: Jane Smith',
      },
    ];

    // Loop through each customer and generate an invoice for them
    for (var customer in customers) {
      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        'beFair House',
                        style: pw.TextStyle(
                          fontSize: 17.0,
                          fontWeight: pw.FontWeight.bold,
                          color: color,
                          font: fontFamily,
                        ),
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Mobile: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
                          ),
                          pw.Text(
                            "+8801564585256",
                            style: pw.TextStyle(color: color, font: fontFamily),
                          ),
                        ],
                      ),
                      pw.Text(
                        'Mirpur, Dhaka',
                        style: pw.TextStyle(
                          fontSize: 15.0,
                          color: color,
                          font: fontFamily,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 100),
                  pw.Container(
                    width: 80,
                    height: 80,
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: customer['qrCodeData']!,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Divider(),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),

              // Customer Details
              pw.Row(
                children: [
                  pw.Text(
                    'Tenant Name: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
                  ),
                  pw.Text(
                    customer['name']!,
                    style: pw.TextStyle(color: color, font: fontFamily),
                  ),
                ],
              ),
              pw.SizedBox(height: 3 * PdfPageFormat.mm),
              pw.Row(
                children: [
                  pw.Text(
                    'Flat No: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
                  ),
                  pw.Text(
                    customer['flatNo']!,
                    style: pw.TextStyle(color: color, font: fontFamily),
                  ),
                ],
              ),
              pw.SizedBox(height: 3 * PdfPageFormat.mm),
              pw.Row(
                children: [
                  pw.Text(
                    'Mobile Number: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
                  ),
                  pw.Text(
                    customer['mobile']!,
                    style: pw.TextStyle(color: color, font: fontFamily),
                  ),
                ],
              ),
              pw.SizedBox(height: 5 * PdfPageFormat.mm),

              // PDF Table Create
              pw.Table.fromTextArray(
                headers: tableHeaders,
                data: tableData,
                border: null,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30.0,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                },
              ),
              pw.Divider(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Row(
                  children: [
                    pw.Spacer(flex: 6),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  'Net total',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: color,
                                    font: fontFamily,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '150005.00',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: color,
                                  font: fontFamily,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 2 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                          pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                          pw.Container(height: 1, color: PdfColors.grey400),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          footer: (context) {
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Safe Home by beFair',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
                ),
                pw.Image(playStoreIcon, width: 30, height: 30),
              ],
            );
          },
        ),
      );
    }

    return FileHandleApi.saveDocument(name: 'my_invoices.pdf', pdf: pdf);
  }
}

