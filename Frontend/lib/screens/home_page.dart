import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';

String username = 'UserName(willBeUpdated)';
enum RequirementType {
  kullanici,
  sistem,
  altBaslik,
  altBaslik1,
  altBaslik2,
  altBaslik3,
}

class Requirement {
  final String title;
  final String id;
  String description;
  String linkId;
  bool flag;
  String createdBy;

  Requirement({required this.title, required this.id, required this.description, required this.linkId, required this.flag, required this.createdBy});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }


  RequirementType selectedType = RequirementType.kullanici;

  List<String> kolonBasliklari = [];
  Map<String, List<String>> kolonVerileri = {};
  List<Requirement> kullaniciGereksinimleri = [];
  List<Requirement> sistemGereksinimleri = [];
  List<Requirement> altBaslikGereksinimleri = [];
  List<Requirement> altBaslik1 = [];
  List<Requirement> altBaslik2 = [];
  List<Requirement> altBaslik3 = [];
  List<Requirement> userAttributes = [];
  List<Requirement> systemAttributes = [];
  List<Requirement> sub1Attributes = [];
  List<Requirement> sub2Attributes = [];
  List<Requirement> sub3Attributes = [];
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
            id: item['id'],
            createdBy: item['createdBy'],
            linkId: '0',
            flag: item['flag']))
            .toList();
      });
    } catch (e) {
      print('Kullanıcı gereksinimleri alınırken hata: $e');
    }

    try {
      final systemReqs = await ApiService.fetchSystemRequirements();
      setState(() {
        sistemGereksinimleri = systemReqs
            .where((item) => item['id'] != null)
            .map<Requirement>((item) => Requirement(
            title: item['title'],
            description: item['description'] ?? '',
            id: item['id'],
            createdBy: item['createdBy'],
            linkId: item['user_req_id'],
            flag: item['flag']))
            .toList();
      });
    } catch (e) {
      print('Sistem gereksinimleri alınırken hata: $e');
    }


    Future<void> fetchCurrentHeaders() async {
      List<dynamic> headers = [];
      try {
        switch (selectedType) {
          case RequirementType.kullanici:
            headers = await ApiService.fetchUserHeaders();
            break;
          case RequirementType.sistem:
            headers = await ApiService.fetchSystemHeaders();
            break;
          case RequirementType.altBaslik1:
            headers = await ApiService.fetchSub1Headers();
            break;
          case RequirementType.altBaslik2:
            headers = await ApiService.fetchSub2Headers();
            break;
          case RequirementType.altBaslik3:
            headers = await ApiService.fetchSub3Headers();
            break;
          default:
            headers = [];
        }

        setState(() {
          kolonBasliklari.clear();
          kolonVerileri.clear();
          for (var header in headers) {
            final h = header['header'] ?? '';
            kolonBasliklari.add(h);
            kolonVerileri[h] = List.filled(currentList.length, '', growable: true);
          }
        });
      } catch (e) {
        print('Header bilgileri alınırken hata: $e');
      }
    }


    Future<void> fetchCurrentAttributes() async {
      try {
        switch (selectedType) {
          case RequirementType.kullanici:
            final attributes = await ApiService.fetchUserAttributes();
            setState(() {
              for (var attr in attributes) {
                final h = attr['header']?.toString().trim();
                final rid = attr['userRequirementId']?.toString();
                final val = attr['description']?.toString() ?? '';
                if (h == null || rid == null) continue;
                final index = currentList.indexWhere((r) => r.id == rid);
                if (index == -1) continue;
                kolonVerileri.putIfAbsent(h, () => List.filled(currentList.length, '', growable: true));
                kolonVerileri[h]![index] = val;
              }
            });
            break;

          case RequirementType.sistem:
            final attributes = await ApiService.fetchSystemAttributes();
            setState(() {
              for (var attr in attributes) {
                final h = attr['header']?.toString().trim();
                final rid = attr['systemRequirementId']?.toString();
                final val = attr['description']?.toString() ?? '';
                if (h == null || rid == null) continue;
                final index = currentList.indexWhere((r) => r.id == rid);
                if (index == -1) continue;
                kolonVerileri.putIfAbsent(h, () => List.filled(currentList.length, '', growable: true));
                kolonVerileri[h]![index] = val;
              }
            });
            break;

          case RequirementType.altBaslik1:
            final attributes = await ApiService.fetchSub1Attributes();
            setState(() {
              for (var attr in attributes) {
                final h = attr['title']?.toString().trim();
                final rid = attr['subsystem1Id']?.toString();
                final val = attr['description']?.toString() ?? '';
                if (h == null || rid == null) continue;
                final index = currentList.indexWhere((r) => r.id == rid);
                if (index == -1) continue;
                kolonVerileri.putIfAbsent(h, () => List.filled(currentList.length, '', growable: true));
                kolonVerileri[h]![index] = val;
              }
            });
            break;

          case RequirementType.altBaslik2:
            final attributes = await ApiService.fetchSub2Attributes();
            setState(() {
              for (var attr in attributes) {
                final h = attr['title']?.toString().trim();
                final rid = attr['subsystem2Id']?.toString();
                final val = attr['description']?.toString() ?? '';
                if (h == null || rid == null) continue;
                final index = currentList.indexWhere((r) => r.id == rid);
                if (index == -1) continue;
                kolonVerileri.putIfAbsent(h, () => List.filled(currentList.length, '', growable: true));
                kolonVerileri[h]![index] = val;
              }
            });
            break;

          case RequirementType.altBaslik3:
            final attributes = await ApiService.fetchSub3Attributes();
            setState(() {
              for (var attr in attributes) {
                final h = attr['title']?.toString().trim();
                final rid = attr['subsystem3Id']?.toString();
                final val = attr['description']?.toString() ?? '';
                if (h == null || rid == null) continue;
                final index = currentList.indexWhere((r) => r.id == rid);
                if (index == -1) continue;
                kolonVerileri.putIfAbsent(h, () => List.filled(currentList.length, '', growable: true));
                kolonVerileri[h]![index] = val;
              }
            });
            break;

          default:
            break;
        }
      } catch (e) {
        print('Attribute bilgileri alınırken hata: $e');
      }
    }


    try {
      final sub1 = await ApiService.fetchSubRequirements1();
      altBaslik1 = sub1.map<Requirement>((item) => Requirement(
          title: item['title'],
          description: item['description'] ?? '',
          id: item['id'],
          createdBy: item['createdBy'],
          linkId: item['systemRequirementId'],
          flag: item['flag'])).toList();
    } catch (_) {}

    try {
      final sub2 = await ApiService.fetchSubRequirements2();
      altBaslik2 = sub2.map<Requirement>((item) => Requirement(
          title: item['title'],
          description: item['description'] ?? '',
          id: item['id'],
          createdBy: item['createdBy'],
          linkId: item['systemRequirementId'],
          flag: item['flag'])).toList();
    } catch (_) {}

    try {
      final sub3 = await ApiService.fetchSubRequirements3();
      altBaslik3 = sub3.map<Requirement>((item) => Requirement(
          title: item['title'],
          description: item['description'] ?? '',
          id: item['id'],
          createdBy: item['createdBy'],
          linkId: item['systemRequirementId'],
          flag: item['flag'])).toList();
    } catch (_) {}

    await fetchCurrentHeaders();
    await fetchCurrentAttributes();

    setState(() => isLoading = false);
  }

  List<Requirement> get currentList {
    switch (selectedType) {
      case RequirementType.kullanici:
        return kullaniciGereksinimleri;
      case RequirementType.sistem:
        return sistemGereksinimleri;
      case RequirementType.altBaslik1:
        return altBaslik1;
      case RequirementType.altBaslik2:
        return altBaslik2;
      case RequirementType.altBaslik3:
        return altBaslik3;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = currentList.where((req) => req.description.toLowerCase().contains(searchQuery)).toList();

    return Scaffold(
      appBar: CustomAppBar(
        onModuleSelected: (type) {
          setState(() {
            selectedType = type;
          });
          fetchAllRequirements();
        },
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
            child: Row(
              children: [
                const SizedBox(width: 240),
                const SizedBox(width: 120),
                for (final kolon in kolonBasliklari)
                  GestureDetector(
                    onSecondaryTapDown: (details) =>
                        _showColumnContextMenu(details.globalPosition, kolon),
                    child: Container(
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
                  final originalIndex = currentList.indexWhere((r) => r.id == item.id);


                  return GestureDetector(
                    onSecondaryTapDown: (details) => _showRequirementContextMenu(details.globalPosition, item, originalIndex),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalController,
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
                              message: item.createdBy,
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
    String? selectedLinkId;
    String prefix = selectedType == RequirementType.kullanici
        ? 'KG'
        : selectedType == RequirementType.sistem
        ? 'SG'
        : selectedType == RequirementType.altBaslik1
        ? 'DG'
        : selectedType == RequirementType.altBaslik2
        ? 'YG'
        : selectedType == RequirementType.altBaslik3
        ? 'GG'
        : 'XX';

    // Üst gereksinim seçenekleri
    List<Requirement> upperRequirements = [];
    if (selectedType == RequirementType.sistem) {
      upperRequirements = kullaniciGereksinimleri;
    } else if (selectedType == RequirementType.altBaslik1 ||
        selectedType == RequirementType.altBaslik2 ||
        selectedType == RequirementType.altBaslik3) {
      upperRequirements = sistemGereksinimleri;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Gereksinim Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => descriptionInput = value,
              decoration: const InputDecoration(
                hintText: 'Gereksinim açıklamasını giriniz',
              ),
            ),
            if (upperRequirements.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Bağlayıcı Gereksinim Seçiniz',
                  border: OutlineInputBorder(),
                ),
                items: upperRequirements.map((req) {
                  return DropdownMenuItem<String>(
                    value: req.id,
                    child: Text(req.title),
                  );
                }).toList(),
                onChanged: (val) {
                  selectedLinkId = val;
                },
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              if (descriptionInput.trim().isEmpty) return;

              bool success = false;
              final newId = '$prefix-${currentList.length + 1}';

              switch (selectedType) {
                case RequirementType.kullanici:
                  success = await ApiService.postUserRequirement(newId, descriptionInput, username, false);
                  break;
                case RequirementType.sistem:
                  if (selectedLinkId == null) return;
                  success = await ApiService.postSystemRequirement(newId, descriptionInput, username, false, selectedLinkId!);
                  break;
                case RequirementType.altBaslik1:
                  if (selectedLinkId == null) return;
                  success = await ApiService.postSub1Requirement(newId, descriptionInput, username, false, selectedLinkId!);
                  break;
                case RequirementType.altBaslik2:
                  if (selectedLinkId == null) return;
                  success = await ApiService.postSub2Requirement(newId, descriptionInput, username, false, selectedLinkId!);
                  break;
                case RequirementType.altBaslik3:
                  if (selectedLinkId == null) return;
                  success = await ApiService.postSub3Requirement(newId, descriptionInput, username, false, selectedLinkId!);
                  break;
                default:
                  success = false;
              }

              if (success) {
                setState(() {
                  currentList.insert(insertIndex, Requirement(
                    title: newId,
                    description: descriptionInput,
                    id: newId,
                    linkId: selectedLinkId ?? '0',
                    flag: false,
                    createdBy: username,
                  ));
                  for (var kolon in kolonBasliklari) {
                    kolonVerileri[kolon]!.insert(insertIndex, '');
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veritabanına eklenemedi')),
                );
              }

              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
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

              final requirement = currentList[rowIndex];
              bool success = false;

              switch (selectedType) {
                case RequirementType.kullanici:
                  success = await ApiService.postUserAttribute(kolonAdi, requirement.id, cellInput);
                  break;
                case RequirementType.sistem:
                  success = await ApiService.postSystemAttribute(kolonAdi, requirement.id, cellInput);
                  break;
                case RequirementType.altBaslik1:
                  success = await ApiService.postSub1Attribute(kolonAdi, requirement.id, cellInput);
                  break;
                case RequirementType.altBaslik2:
                  success = await ApiService.postSub2Attribute(kolonAdi, requirement.id, cellInput);
                  break;
                case RequirementType.altBaslik3:
                  success = await ApiService.postSub3Attribute(kolonAdi, requirement.id, cellInput);
                  break;
                default:
                  success = false;
              }

              if (!success) {
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
                bool success = false;
                switch (selectedType) {
                  case RequirementType.kullanici:
                    success = await ApiService.postUserHeader(yeniBaslik.trim());
                    break;
                  case RequirementType.sistem:
                    success = await ApiService.postSystemHeader(yeniBaslik.trim());
                    break;
                  case RequirementType.altBaslik1:
                    success = await ApiService.postSub1Header(yeniBaslik.trim());
                    break;
                  case RequirementType.altBaslik2:
                    success = await ApiService.postSub2Header(yeniBaslik.trim());
                    break;
                  case RequirementType.altBaslik3:
                    success = await ApiService.postSub3Header(yeniBaslik.trim());
                    break;
                  default:
                    success = false;
                }


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
      final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Onay'),
            content: Text('"${item.title}" gereksinimini silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil')),
            ],
          ),
      );
      if (confirmed == true) {
        bool success = false;

        switch (selectedType) {
          case RequirementType.kullanici:
            success = await ApiService.deleteUserRequirement(item.id);
            break;
          case RequirementType.sistem:
            success = await ApiService.deleteSystemRequirement(item.id);
            break;
          case RequirementType.altBaslik1:
            success = await ApiService.deleteSub1Requirement(item.id);
            break;
          case RequirementType.altBaslik2:
            success = await ApiService.deleteSub2Requirement(item.id);
            break;
          case RequirementType.altBaslik3:
            success = await ApiService.deleteSub3Requirement(item.id);
            break;
          default:
            success = false;
        }

        if (success) {
          setState(() {
            currentList.removeAt(index);
            for (var kolon in kolonBasliklari) {
              kolonVerileri[kolon]!.removeAt(index);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gereksinim silinemedi')),
          );
        }
      }
    } else if (selected == 'baglantilari_goster') {
      _showBaglantilarDialog(item.title);
    }
  }

  void _showRequirementSelectionDialog(Requirement sourceReq, bool isFromOtherToThis) {
    List<Requirement> otherList = [];
    switch (selectedType) {
      case RequirementType.kullanici:
        otherList = [
          ...sistemGereksinimleri,
          ...altBaslik1,
          ...altBaslik2,
          ...altBaslik3,
        ];
        break;
      case RequirementType.sistem:
        otherList = [
          ...kullaniciGereksinimleri,
          ...altBaslik1,
          ...altBaslik2,
          ...altBaslik3,
        ];
        break;
      case RequirementType.altBaslik1:
      case RequirementType.altBaslik2:
      case RequirementType.altBaslik3:
        otherList = [
          ...kullaniciGereksinimleri,
          ...sistemGereksinimleri,
        ];
        break;
      default:
        otherList = [];
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
            onPressed: () async {
              bool success = false;

              if (selectedType == RequirementType.kullanici) {
                success = await ApiService.updateUserRequirement(
                  item.id,
                  item.title,
                  updatedDescription,
                  username,
                  true,
                );
              }
              else if(selectedType == RequirementType.sistem) {
                success = await ApiService.updateSystemRequirement(
                  item.id,
                  item.title,
                  updatedDescription,
                  username,
                  true,
                  item.linkId,
                );
              }
              else if(selectedType == RequirementType.altBaslik1) {
                success = await ApiService.updateSub1Requirement(
                  item.id,
                  item.title,
                  updatedDescription,
                  username,
                  true,
                  item.linkId,
                );
              }
              else if(selectedType == RequirementType.altBaslik2) {
                success = await ApiService.updateSub2Requirement(
                  item.id,
                  item.title,
                  updatedDescription,
                  username,
                  true,
                  item.linkId,
                );
              }
              else if(selectedType == RequirementType.altBaslik3) {
                success = await ApiService.updateSub3Requirement(
                  item.id,
                  item.title,
                  updatedDescription,
                  username,
                  true,
                  item.linkId);
              }

              if (success) {
                setState(() {
                  item.description = updatedDescription;
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Güncelleme başarısız')),
                );
              }
            },
            child: const Text('Kaydet'),
          )
        ],
      ),
    );
  }

  void _showBaglantilarDialog(String selectedTitle) {
    Requirement findRequirementByTitle(String title) {
      return [
        ...kullaniciGereksinimleri,
        ...sistemGereksinimleri,
        ...altBaslik1,
        ...altBaslik2,
        ...altBaslik3,
      ].firstWhere((r) => r.title == title);
    }

    Widget buildChain(List<Requirement> chain) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < chain.length; i++) ...[
            Text('${chain[i].title} : ${chain[i].description}', style: const TextStyle(fontSize: 14)),
            if (i != chain.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('↓', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ]
        ],
      );
    }

    List<Requirement> chain = [];
    final current = findRequirementByTitle(selectedTitle);
    chain.add(current);

    // Sistem gereksinimi ise → Kullanıcı gereksinimine git
    if (sistemGereksinimleri.contains(current)) {
      final parent = kullaniciGereksinimleri.firstWhere((r) => r.id == current.linkId, orElse: () => Requirement(title: '(Bilinmiyor)', id: '', description: 'Bağlantı yok', linkId: '', flag: false, createdBy: ''));
      chain.insert(0, parent);
    }

    // Alt başlık ise → Sistem → Kullanıcı
    if (altBaslik1.contains(current) || altBaslik2.contains(current) || altBaslik3.contains(current)) {
      final system = sistemGereksinimleri.firstWhere((r) => r.id == current.linkId, orElse: () => Requirement(title: '(Bilinmiyor)', id: '', description: 'Sistem bağlantısı yok', linkId: '', flag: false, createdBy: ''));
      chain.insert(0, system);
      final user = kullaniciGereksinimleri.firstWhere((r) => r.id == system.linkId, orElse: () => Requirement(title: '(Bilinmiyor)', id: '', description: 'Kullanıcı bağlantısı yok', linkId: '', flag: false, createdBy: ''));
      chain.insert(0, user);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$selectedTitle Bağlantı Zinciri'),
        content: SingleChildScrollView(child: buildChain(chain)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
        ],
      ),
    );
  }


  void _showColumnContextMenu(Offset position, String kolonAdi) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: const [
        PopupMenuItem<String>(value: 'sil', child: Text('Sütunu Sil')),
      ],
    );

    if (selected == 'sil') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Onay'),
          content: Text('"$kolonAdi" sütununu silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil')),
          ],
        ),
      );

      if (confirmed == true) {
        bool success = false;

        switch (selectedType) {
          case RequirementType.kullanici:
            success = await ApiService.deleteUserHeader(kolonAdi);
            break;
          case RequirementType.sistem:
            success = await ApiService.deleteSystemHeader(kolonAdi);
            break;
          case RequirementType.altBaslik1:
            success = await ApiService.deleteSub1Header(kolonAdi);
            break;
          case RequirementType.altBaslik2:
            success = await ApiService.deleteSub2Header(kolonAdi);
            break;
          case RequirementType.altBaslik3:
            success = await ApiService.deleteSub3Header(kolonAdi);
            break;
          default:
            success = false;
        }

        if (success) {
          setState(() {
            kolonBasliklari.remove(kolonAdi);
            kolonVerileri.remove(kolonAdi);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sütun silinemedi (backend)')),
          );
        }
      }
    }
  }


}


