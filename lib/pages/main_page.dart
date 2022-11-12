import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangkooh/pages/category_page.dart';
import 'package:uangkooh/pages/home_page.dart';
import 'package:uangkooh/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _childern = [
    HomePage(),
    CategoryPage(),
  ];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              backButton: false,
              accent: Colors.green,
              locale: 'id',
              onDateChanged: (value) => print(value),
              firstDate: DateTime.now().subtract(Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 39,
                  horizontal: 16,
                ),
                child: Text(
                  'Kategori',
                  style: GoogleFonts.montserrat(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              preferredSize: Size.fromHeight(100),
            ),

      // body
      body: _childern[currentIndex],

      // floating button
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => TransactionPage()))
                .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom navigation
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                onTapTapped(0);
              },
              icon: const Icon(Icons.home),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                onTapTapped(1);
              },
              icon: const Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }
}
