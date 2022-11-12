import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool pengeluaran = true;

  // open dialog
  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    pengeluaran ? 'Tambah Pengeluaran' : 'Tambah Pemasukan',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: pengeluaran ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nama",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text("Simpan", style: GoogleFonts.montserrat())),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: pengeluaran,
                  onChanged: (bool value) {
                    setState(() {
                      pengeluaran = value;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                    onPressed: () {
                      openDialog();
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: pengeluaran
                    ? Icon(
                        Icons.upload,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                title: Text(
                  'Sedekah',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    const SizedBox(width: 10),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
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
                leading: pengeluaran
                    ? Icon(
                        Icons.upload,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.download,
                        color: Colors.green,
                      ),
                title: Text(
                  'Sedekah',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    const SizedBox(width: 10),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
