import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangkooh/pages/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool pengeluaran = true;
  final AppDb database = AppDb();
  int type = 2;
  TextEditingController categoriNameController = TextEditingController();

  // insert data
  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));

    print(row);
  }

  // get allCategory where type
  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  // update category
  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  // open dialog
  void openDialog(Category? category) {
    if (category != null) {
      categoriNameController.text = category.name;
    }

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
                    controller: categoriNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Nama",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        insert(
                            categoriNameController.text, pengeluaran ? 2 : 1);
                      } else {
                        update(category.id, categoriNameController.text);
                      }

                      category == null
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Berhasil menambahkan data'),
                              ),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Berhasil mengubah data'),
                              ),
                            );
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {});

                      categoriNameController.clear();
                    },
                    child: Text(
                      category == null ? "Simpan" : "Ubah",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
    return SingleChildScrollView(
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
                      type = value ? 2 : 1;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                    onPressed: () {
                      openDialog(null);
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
          ),

          //  menampilkan list data
          FutureBuilder<List<Category>>(
            future: getAllCategory(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // jika ada datanya
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        database.deleteCategoryRepo(
                                            snapshot.data![index].id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Berhasil menghapus data'),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        openDialog(snapshot.data![index]);
                                      },
                                    )
                                  ],
                                ),
                                leading: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: (pengeluaran)
                                        ? Icon(Icons.upload,
                                            color: Colors.redAccent[400])
                                        : Icon(
                                            Icons.download,
                                            color: Colors.greenAccent[400],
                                          )),
                                title: Text(snapshot.data![index].name)),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('Tidak ada data..!!'),
                    );
                  }
                } else {
                  return Center(
                    child: Text('Tidak ada data..!!'),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
