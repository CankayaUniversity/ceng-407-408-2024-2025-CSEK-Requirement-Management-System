import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

enum RequirementType {
  kullanici,
  sistem,
  altBaslik,
}

class Requirement {
  final String id;
  String description;

  Requirement({required this.id, required this.description});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RequirementType selectedType = RequirementType.kullanici;

  List<String> kolonBasliklari = [];
  Map<String, List<String>> kolonVerileri = {};

  List<Requirement> kullaniciGereksinimleri = [
    Requirement(id: 'KG-1', description: 'İlk Kullanıcı Gereksiniminin Açıklaması'),
    Requirement(id: 'KG-2', description: 'İkinci Kullanıcı Gereksiniminin Açıklaması'),
    Requirement(id: 'KG-3', description: 'Üçüncü Kullanıcı Gereksiniminin Açıklaması'),
  ];

  List<Requirement> sistemGereksinimleri = [
    Requirement(id: 'SG-1', description: 'İlk Sistem Gereksinimi'),
  ];

  List<Requirement> altBaslikGereksinimleri = [
    Requirement(id: 'AB-1', description: 'İlk Alt Başlık Gereksinimi'),
  ];

  Map<String, List<String>> requirementBaglantilari = {};

  List<Requirement> get currentList {
    switch (selectedType) {
      case RequirementType.kullanici:
        return kullaniciGereksinimleri;
      case RequirementType.sistem:
        return sistemGereksinimleri;
      case RequirementType.altBaslik:
        return altBaslikGereksinimleri;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onModuleSelected: (type) {
          setState(() {
            selectedType = type;
          });
        },
        onAddColumn: _showAddColumnDialog,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 120),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('      ', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              for (final kolon in kolonBasliklari)
                Container(
                  width: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(kolon, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      IconButton(
                        icon: const Icon(Icons.tune, size: 28),
                        onPressed: () {
                          print('Ayar butonuna tıklandı');
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: currentList.length * 2 + 1,
                    itemBuilder: (context, index) {
                      if (index.isEven) {
                        final insertIndex = index ~/ 2;
                        return Row(
                          children: [
                            Container(
                              width: 120,
                              height: 36,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minHeight: 24, minWidth: 24),
                                onPressed: () {
                                  _showAddRequirementDialog(insertIndex);
                                },
                              ),
                            ),
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        );
                      } else {
                        final reqIndex = index ~/ 2;
                        final item = currentList[reqIndex];
                        return GestureDetector(
                          onSecondaryTapDown: (details) {
                            _showRequirementContextMenu(details.globalPosition, item, reqIndex);
                          },
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 70,
                                  color: Colors.grey[400],
                                  alignment: Alignment.center,
                                  child: Text(item.id),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(item.description),
                                  ),
                                ),
                                for (final kolon in kolonBasliklari)
                                  Container(
                                    width: 120,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(left: BorderSide(color: Colors.black)),
                                    ),
                                    child: kolonVerileri[kolon]![reqIndex].isEmpty
                                        ? IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        _showCellInputDialog(kolon, reqIndex);
                                      },
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(kolonVerileri[kolon]![reqIndex]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRequirementDialog(int insertIndex) {
    String descriptionInput = '';
    final prefix = selectedType == RequirementType.kullanici
        ? 'KG'
        : selectedType == RequirementType.sistem
        ? 'SG'
        : 'AB';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Gereksinim Açıklaması'),
        content: TextField(
          onChanged: (value) => descriptionInput = value,
          decoration: const InputDecoration(hintText: 'Gereksinim açıklamasını giriniz'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (descriptionInput.trim().isEmpty) return;
              setState(() {
                final newId = '$prefix-${currentList.length + 1}';
                currentList.insert(insertIndex, Requirement(id: newId, description: descriptionInput));
                for (var kolon in kolonBasliklari) {
                  kolonVerileri[kolon]!.insert(insertIndex, '');
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          )
        ],
      ),
    );
  }

  void _showCellInputDialog(String kolonAdi, int rowIndex) {
    String cellInput = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$kolonAdi için değer girin'),
        content: TextField(
          onChanged: (val) => cellInput = val,
          decoration: const InputDecoration(hintText: 'Hücre değeri'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                kolonVerileri[kolonAdi]![rowIndex] = cellInput;
              });
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showAddColumnDialog() {
    String yeniBaslik = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sütun Başlığı Giriniz:'),
        content: TextField(
          onChanged: (val) => yeniBaslik = val,
          decoration: const InputDecoration(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              if (yeniBaslik.trim().isNotEmpty) {
                setState(() {
                  kolonBasliklari.add(yeniBaslik.trim());
                  kolonVerileri[yeniBaslik.trim()] = List.filled(currentList.length, '', growable: true);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showRequirementContextMenu(Offset position, Requirement item, int index) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: const [
        PopupMenuItem<String>(value: 'bagla', child: Text('Bağla')),
        PopupMenuItem<String>(value: 'duzenle', child: Text('Düzenle')),
        PopupMenuItem<String>(value: 'sil', child: Text('Sil')),
        PopupMenuItem<String>(value: 'baglantilari_goster', child: Text('Bağlantıları Göster')),
      ],
    );

    if (selected == 'bagla') {
      final type = await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
        items: const [
          PopupMenuItem<String>(value: 'nereden', child: Text('Nereden')),
          PopupMenuItem<String>(value: 'nereye', child: Text('Nereye')),
        ],
      );
      if (type != null) {
        _showRequirementSelectionDialog(item, type == 'nereden');
      }
    } else if (selected == 'duzenle') {
      _showEditDescriptionDialog(item);
    } else if (selected == 'sil') {
      setState(() {
        currentList.removeAt(index);
        for (var kolon in kolonBasliklari) {
          kolonVerileri[kolon]!.removeAt(index);
        }
      });
    } else if (selected == 'baglantilari_goster') {
      _showBaglantilarDialog(item.id);
    }
  }

  void _showRequirementSelectionDialog(Requirement sourceReq, bool isFromOtherToThis) {
    List<Requirement> otherList = [];
    switch (selectedType) {
      case RequirementType.kullanici:
        otherList = [...sistemGereksinimleri, ...altBaslikGereksinimleri];
        break;
      case RequirementType.sistem:
        otherList = [...kullaniciGereksinimleri, ...altBaslikGereksinimleri];
        break;
      case RequirementType.altBaslik:
        otherList = [...kullaniciGereksinimleri, ...sistemGereksinimleri];
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bağlanacak Gereksinimi Seç'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: otherList.length,
            itemBuilder: (context, index) {
              final target = otherList[index];
              return ListTile(
                title: Text('${target.id} - ${target.description}'),
                onTap: () {
                  setState(() {
                    final sourceId = isFromOtherToThis ? target.id : sourceReq.id;
                    final targetId = isFromOtherToThis ? sourceReq.id : target.id;
                    requirementBaglantilari.putIfAbsent(sourceId, () => []);
                    if (!requirementBaglantilari[sourceId]!.contains(targetId)) {
                      requirementBaglantilari[sourceId]!.add(targetId);
                    }
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditDescriptionDialog(Requirement item) {
    String updatedDescription = item.description;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Açıklamayı Düzenle'),
        content: TextField(
          controller: TextEditingController(text: item.description),
          onChanged: (val) => updatedDescription = val,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.description = updatedDescription;
              });
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          )
        ],
      ),
    );
  }

  void _showBaglantilarDialog(String sourceId) {
    final targets = requirementBaglantilari[sourceId] ?? [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$sourceId bağlantıları'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: targets.map((e) => Text('→ $e')).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
        ],
      ),
    );
  }
}
