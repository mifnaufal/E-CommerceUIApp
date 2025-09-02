import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// =======================================================
// HALAMAN UTAMA (HOME PAGE)
// =======================================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita tetap butuh Scaffold di sini untuk AppBar dan layout dasar
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                // Search Widget
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search here...",
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.camera_alt,
                        size: 27,
                        color: Color(0xFF4C53A5),
                      )
                    ],
                  ),
                ),

                // Judul "Categories"
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                const CategoriesWidget(),

                // Judul "Best Selling"
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: const Text(
                    "Best Selling",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                const ItemsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// WIDGET UNTUK APP BAR
// =======================================================
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          const Icon(Icons.sort, size: 30, color: Color(0xFF4C53A5)),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text("DP Shop",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5))),
          ),
          const Spacer(),
          badges.Badge(
            badgeContent:
                const Text('3', style: TextStyle(color: Colors.white)),
            badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red, padding: EdgeInsets.all(7)),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, "/cart"),
              child: const Icon(Icons.shopping_bag_outlined,
                  size: 32, color: Color(0xFF4C53A5)),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// WIDGET UNTUK KATEGORI
// =======================================================
class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        // Kategori khusus "Sandal"
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset("assets/images/carts/9.jpeg", // Path benar
                width: 40,
                height: 40),
            const SizedBox(width: 10),
            const Text("Sandal",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF4C53A5)))
          ]),
        ),
        // Kategori lainnya dari loop
        for (int i = 1; i < 5; i++) // Sesuaikan angka 5 jika gambar lebih banyak
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Image.asset("assets/images/carts/$i.jpeg", // Path benar
                  width: 40,
                  height: 40),
              const SizedBox(width: 10),
              Text("Category ${i}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF4C53A5)))
            ]),
          )
      ]),
    );
  }
}

// =======================================================
// WIDGET UNTUK DAFTAR ITEM
// =======================================================
class ItemsWidget extends StatelessWidget {
  const ItemsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.68,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 1; i < 5; i++) // Sesuaikan angka 5 jika gambar lebih banyak
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text("-50%",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.favorite_border, color: Colors.red)
              ]),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/carts/$i.jpeg", // Path benar
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: const Text("Product Title",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4C53A5),
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text("Write description of product",
                    style: TextStyle(fontSize: 15, color: Color(0xFF4C53A5))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("\$55",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C53A5))),
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        itemBuilder: (context, _) =>
                            const Icon(Icons.favorite, color: Color(0xFF4C53A5)),
                        onRatingUpdate: (index) {},
                      ),
                    ]),
              ),
            ]),
          )
      ],
    );
  }
}