import 'package:flutter/material.dart';
import '../screens/home_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(RequirementType) onModuleSelected;
  final VoidCallback onAddColumn;

  const CustomAppBar({super.key, required this.onModuleSelected, required this.onAddColumn});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[700],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Modül Seç butonu
          PopupMenuButton<RequirementType>(
            onSelected: onModuleSelected,
            color: Colors.white,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: RequirementType.kullanici,
                child: Text('Kullanıcı Gereksinimleri'),
              ),
              PopupMenuItem(
                value: RequirementType.sistem,
                child: Text('Sistem Gereksinimleri'),
              ),
              PopupMenuItem(
                value: RequirementType.altBaslik,
                child: Text('Alt Başlık Gereksinimleri'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                'Modül Seç',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),


          // Yeni Kolon
          ElevatedButton(
            onPressed: onAddColumn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              minimumSize: const Size(120, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Yeni Kolon'),
          ),

          // Baseline
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              minimumSize: const Size(120, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Baseline'),
          ),

          // Değişimler
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              minimumSize: const Size(120, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Değişimler'),
          ),

          // Dışa Aktar
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              minimumSize: const Size(120, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Dışa Aktar'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
