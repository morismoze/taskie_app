class Paginable<D> {
  Paginable({required this.items, required int totalPages, required int total})
    // [total] and [totalPages] can be changed when item is added to or removed from [items]
    : _total = total,
      _totalPages = totalPages;

  final List<D> items;

  int _totalPages;
  // ignore: unnecessary_getters_setters
  int get totalPages => _totalPages;
  set totalPages(int value) => _totalPages = value;

  int _total;
  // ignore: unnecessary_getters_setters
  int get total => _total;
  set total(int value) => _total = value;

  Paginable.clone(Paginable<D> toClone)
    : this(
        items: List.from(toClone.items),
        total: toClone.total,
        totalPages: toClone.totalPages,
      );

  Map<String, dynamic> toMap(Map<String, dynamic> Function(D item) toItemMap) =>
      {
        'items': items.map(toItemMap).toList(),
        'total': total,
        'totalPages': totalPages,
      };

  factory Paginable.fromMap(
    Map<dynamic, dynamic> map, {
    required D Function(Map<dynamic, dynamic> itemMap) fromItemMap,
  }) {
    final itemsRaw = map['items'];
    final list = (itemsRaw is List) ? itemsRaw : const [];

    final items = list
        .map((e) => fromItemMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList();

    final total = (map['total'] as num?)?.toInt() ?? items.length;
    final totalPages = (map['totalPages'] as num?)?.toInt() ?? 1;

    return Paginable<D>(items: items, total: total, totalPages: totalPages);
  }
}
