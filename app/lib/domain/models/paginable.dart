class Paginable<D> {
  Paginable({
    required this.items,
    required this.totalPages,
    required this.total,
  });

  final List<D> items;
  final int totalPages;
  final int total;

  Paginable.clone(Paginable<D> toClone)
    : this(
        items: List.from(toClone.items),
        total: toClone.total,
        totalPages: toClone.totalPages,
      );
}
