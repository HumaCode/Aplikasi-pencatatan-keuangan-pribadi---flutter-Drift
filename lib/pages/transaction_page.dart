import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangkooh/pages/models/database.dart';
import 'package:uangkooh/pages/models/transaction_with_category.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({
    super.key,
    this.transactionWithCategory,
  });

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

  // Menampilkan data transaksi
  void updateTransaction(TransactionWithCategory transactionWithCategory) {
    jumlahController.text =
        transactionWithCategory.transaction.amount.toString();
    deskripsiController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat("yyyy-MM-dd")
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;

    type == 2 ? pengeluaran = true : pengeluaran = false;
    selectedCategory = transactionWithCategory.category;
  }

  // update transaksi
  Future update(int transactionId, int amount, int categoryId,
      DateTime transactionDate, String nameDetail) async {
    return await database.updateTransactionRepo(
      transactionId,
      amount,
      categoryId,
      transactionDate,
      nameDetail,
    );
  }

  @override
  void initState() {
    // jika mengirim parameter maka jalankan function update
    if (widget.transactionWithCategory != null) {
      updateTransaction(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
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
                          selectedCategory = selectedCategory == null
                              ? snapshot.data!.first
                              : selectedCategory;
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
                            child: Text(
                              'Data kosong',
                              style: GoogleFonts.montserrat(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: Text(
                            'Tidak ada data',
                            style: GoogleFonts.montserrat(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
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
                  onPressed: () async {
                    // print(jumlahController.text);
                    // print(dateController.text);
                    // print(deskripsiController.text);
                    widget.transactionWithCategory == null
                        ? await insert(
                            int.parse(jumlahController.text),
                            DateTime.parse(dateController.text),
                            deskripsiController.text,
                            selectedCategory!.id,
                          )
                        : await update(
                            widget.transactionWithCategory!.transaction.id,
                            int.parse(jumlahController.text),
                            selectedCategory!.id,
                            DateTime.parse(dateController.text),
                            deskripsiController.text,
                          );

                    Navigator.pop(context, true);
                    // setState(() {});
                    widget.transactionWithCategory == null
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil menambah transaksi'),
                            ),
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil mengubah transaksi'),
                            ),
                          );
                  },
                  child: Text(
                    widget.transactionWithCategory == null
                        ? 'Simpan Data'
                        : 'Ubah Data',
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
