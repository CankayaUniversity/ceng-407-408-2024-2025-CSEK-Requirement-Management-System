import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';

// Bu dosya, Flutter'da Gereksinim Yönetimi Arayüzü sunar.

enum RequirementType { kullanici, sistem, altBaslik }

class Requirement {
  final String title;
  final String id;
  String description;

  Requirement({required this.title, required this.id, required this.description});
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
  List<Requirement> kullaniciGereksinimleri = [];
  List<Requirement> sistemGereksinimleri = [];
  List<Requirement> altBaslikGereksinimleri = [];
  Map<String, List<String>> requirementBaglantilari = {};

  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllRequirements();
  }

  void fetchAllRequirements() async {
    setState(() => isLoading = true);
    try {
      final userReqs = await ApiService.fetchUserRequirements();
      setState(() {
        kullaniciGereksinimleri = userReqs
            .where((item) => item['id'] != null)
            .map<Requirement>((item) => Requirement(
            title: item['title'],
            description: item['description'] ?? '',
            id: item['id']))
            .toList();
      });
    } catch (e) {
      print('Kullanıcı gereksinimleri alınırken hata: $e');
    }

    try {
      final systemReqs = await ApiService.fetchSystemRequirements();
      setState(() {
        sistemGereksinimleri = systemReqs
            .where((item) => item['id'] != null && item['id'].toString().startsWith('SG'))
            .map<Requirement>((item) => Requirement(
            title: item['title'],
            description: item['description'] ?? '',
            id: item['id']))
            .toList();
      });
    } catch (e) {
      print('Sistem gereksinimleri alınırken hata: $e');
    }

    try {
      final subReqs = await ApiService.fetchSubRequirements();
      setState(() {
        altBaslikGereksinimleri = subReqs
            .where((item) => item['id'] != null && item['id'].toString().startsWith('AB'))
            .map<Requirement>((item) => Requirement(
            title: item['title'],
            description: item['description'] ?? '',
            id: item['id']))
            .toList();
      });
    } catch (e) {
      print('Alt başlık gereksinimleri alınırken hata: $e');
    }

    try {
      final headers = await ApiService.fetchHeaders();
      setState(() {
        for (var header in headers) {
          final h = header['header'] ?? '';
          if (!kolonBasliklari.contains(h)) {
            kolonBasliklari.add(h);
            kolonVerileri[h] = List.filled(kullaniciGereksinimleri.length, '', growable: true);
          }
        }
      });
    } catch (e) {
      print('Header bilgileri alınırken hata: $e');
    }

    try {
      final attributes = await ApiService.fetchAttributes();
      setState(() {
        for (var attr in attributes) {
          final h = attr['header']?.toString().trim();
          final rid = attr['userRequirementId']?.toString();
          final val = attr['description']?.toString() ?? '';
          if (h == null || rid == null) continue;
          final index = kullaniciGereksinimleri.indexWhere((r) => r.id == rid);
          if (index == -1) continue;
          kolonVerileri.putIfAbsent(h, () => List.filled(kullaniciGereksinimleri.length, '', growable: true));
          if (!kolonBasliklari.contains(h)) kolonBasliklari.add(h);
          kolonVerileri[h]![index] = val;
        }
      });
    } catch (e) {
      print('Attribute bilgileri alınırken hata: $e');
    }

    setState(() => isLoading = false);
  }

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
    final filteredList = currentList.where((req) => req.description.toLowerCase().contains(searchQuery)).toList();

    return Scaffold(
      appBar: CustomAppBar(
        onModuleSelected: (type) => setState(() => selectedType = type),
        onAddColumn: _showAddColumnDialog,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Ara...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 120),
                for (final kolon in kolonBasliklari)
                  Container(
                    width: 120,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kolon,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: filteredList.length * 2 + 1,
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
                          onPressed: () => _showAddRequirementDialog(insertIndex),
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  );
                } else {
                  final reqIndex = index ~/ 2;
                  final item = filteredList[reqIndex];
                  final originalIndex = kullaniciGereksinimleri.indexWhere((r) => r.id == item.id);

                  return GestureDetector(
                    onSecondaryTapDown: (details) => _showRequirementContextMenu(details.globalPosition, item, originalIndex),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 70,
                            color: Colors.grey[400],
                            alignment: Alignment.center,
                            child: Text(item.title),
                          ),
                          Container(
                            width: 240,
                            padding: const EdgeInsets.all(16.0),
                            child: Tooltip(
                              message: item.description,
                              child: Text(
                                item.description.length > 40
                                    ? item.description.substring(0, 40) + '...'
                                    : item.description,
                              ),
                            ),
                          ),
                          for (final kolon in kolonBasliklari)
                            Container(
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(left: BorderSide(color: Colors.black)),
                              ),
                              child: kolonVerileri[kolon]![originalIndex].isEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _showCellInputDialog(kolon, originalIndex),
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tooltip(
                                  message: kolonVerileri[kolon]![originalIndex],
                                  child: Text(
                                    kolonVerileri[kolon]![originalIndex].length > 40
                                        ? kolonVerileri[kolon]![originalIndex].substring(0, 40) + '...'
                                        : kolonVerileri[kolon]![originalIndex],
                                  ),
                                ),
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
            onPressed: () async {
              if (descriptionInput.trim().isEmpty) return;

              // Backend'e POST at
              bool success = await ApiService.postUserRequirement(
                '$prefix Gereksinimi',
                descriptionInput,
                'frontendUser', // dilersek kullanıcıdan alınabilir
                false, // flag: varsayılan false
              );

              if (success) {
                // Başarılıysa listeyi güncelle
                setState(() {
                  final newId = '$prefix-${currentList.length + 1}';
                  currentList.insert(insertIndex, Requirement(title: newId, description: descriptionInput,id: '0'));
                  for (var kolon in kolonBasliklari) {
                    kolonVerileri[kolon]!.insert(insertIndex, '');
                  }
                });
              } else {
                // Hata durumunda uyarı göster
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veritabanına eklenemedi')),
                );
              }

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
            onPressed: () async {
              setState(() {
                kolonVerileri[kolonAdi]![rowIndex] = cellInput;
              });

              // Backend'e attribute POST at
              final requirement = currentList[rowIndex];
              bool success = await ApiService.postAttribute(
                kolonAdi,
                requirement.id,
                cellInput,
              );

              if (!success) {
                // Hata durumunda kullanıcıya bildir
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hücre değeri veritabanına eklenemedi')),
                );
              }

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
            onPressed: () async {
              if (yeniBaslik.trim().isNotEmpty) {
                // Önce veritabanına gönder
                bool success = await ApiService.postHeader(yeniBaslik.trim());

                if (success) {
                  //Başarılıysa UI'ya ekle
                  setState(() {
                    kolonBasliklari.add(yeniBaslik.trim());
                    kolonVerileri[yeniBaslik.trim()] = List.filled(currentList.length, '', growable: true);
                  });
                } else {
                  // Başarısızsa kullanıcıya bildir
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kolon eklenemedi (backend)')),
                  );
                }
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
      _showBaglantilarDialog(item.title);
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
                title: Text('${target.title} - ${target.description}'),
                onTap: () {
                  setState(() {
                    final sourceId = isFromOtherToThis ? target.title : sourceReq.title;
                    final targetId = isFromOtherToThis ? sourceReq.title : target.title;
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
