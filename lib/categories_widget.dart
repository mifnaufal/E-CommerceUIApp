import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Kategori khusus untuk gambar 9.jpeg (Sandal)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Menggunakan gambar 9.jpeg
                Image.asset(
                  "assets/images/carts/9.jpeg", // Pastikan path dan ekstensi benar
                  width: 40,
                  height: 40,
                ),
                const Text(
                  "Sandal", // Teks tetap ada di samping gambar
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF4C53A5),
                  ),
                )
              ],
            ),
          ),
          // Kategori-kategori lainnya (jika ada, menggunakan i.png)
          for (int i = 1; i < 8; i++) // Anda bisa menyesuaikan angka 8 ini
            // Pastikan tidak ada duplikasi 'Sandal' jika 9.jpeg juga ada di 1-8
            if (i != 9) // Hindari duplikasi jika 9.jpeg juga termasuk dalam loop 1-8
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/carts/$i.jpeg", // Asumsi ekstensi .jpeg untuk semua
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      "Category $i", // Contoh nama kategori lainnya
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF4C53A5),
                      ),
                    )
                  ],
                ),
              ),
        ],
      ),
    );
  }
}