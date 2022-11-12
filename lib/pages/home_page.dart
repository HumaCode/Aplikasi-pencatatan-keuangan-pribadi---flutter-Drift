import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pemasukan",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Rp. 2.000.000.00",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.upload,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pengeluaran",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Rp. 2.000.00",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            // transaksi teks
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Transaksi',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // list transaksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text('Rp. 2.000.00'),
                  subtitle: Text('Makan Siang'),
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.upload,
                      color: Colors.red,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete),
                      const SizedBox(width: 10),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 10,
                child: ListTile(
                  title: Text('Rp. 2.000.00'),
                  subtitle: Text('Ngamen'),
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.download,
                      color: Colors.green,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete),
                      const SizedBox(width: 10),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
