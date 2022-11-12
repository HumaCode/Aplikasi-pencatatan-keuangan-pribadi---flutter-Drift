import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangkooh/pages/models/database.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDb database = AppDb();
  bool pengeluaran = true;
  late int type;
  List<String> list = ['Makan', 'Transport', 'Judi Online'];
  Category? selectedCategory;

  late String dropdownValue = list.first;
  TextEditingController dateController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  // insert transaksi
  Future insert(
      int jumlah, DateTime date, String nameDeskripsi, int categoryId) async {
    DateTime now = DateTime.now();
    await database.into(database.transactions).insertReturning(
          TransactionsCompanion.insert(
            name: nameDeskripsi,
            category_id: categoryId,
            transaction_date: date,
            amount: jumlah,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  // get allCategory where type
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  @override
  void initState() {
    type = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Switch(
                    value: pengeluaran,
                    onChanged: (bool value) {
                      setState(() {
                        pengeluaran = value;
                        type = pengeluaran ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  Text(
                    pengeluaran ? 'Pengeluaran' : 'Pemasukan',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: pengeluaran ? Colors.red : Colors.green,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Jumlah',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Kategori',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              FutureBuilder<List<Category>>(
                  future: getAllCategory(type),
                  builder: (context, snapshot) {
                    // menunggu / loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          selectedCategory = snapshot.data!.first;
                          // print(snapshot.data);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<Category>(
                                value: selectedCategory == null
                                    ? snapshot.data!.first
                                    : selectedCategory,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_downward),
                                items: snapshot.data!.map((Category item) {
                                  return DropdownMenuItem<Category>(
                                    value: item,
                                    child: Text(item.name),
                                  );
                                }).toList(),
                                onChanged: (Category? value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                }),
                          );
                        } else {
                          return Center(
                            child: Text('Data kosong'),
                          );
                        }
                      } else {
                        return Center(
                          child: Text('Tidak ada data'),
                        );
                      }
                    }
                  }),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2099));

                    if (pickedDate != null) {
                      String formatDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      dateController.text = formatDate;
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: deskripsiController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Deskripsi',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // print(jumlahController.text);
                    // print(dateController.text);
                    // print(deskripsiController.text);
                    insert(
                      int.parse(jumlahController.text),
                      DateTime.parse(dateController.text),
                      deskripsiController.text,
                      selectedCategory!.id,
                    );
                  },
                  child: Text(
                    'Simpan Data',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
