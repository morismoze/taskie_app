class Paginable<D> {
  Paginable({
    required this.items,
    required this.totalPages,
    required this.total,
  });

  final List<D> items;
  final int totalPages;
  final int total;

  /// This is used on task creation - to show newly created task
  /// no matter the limit and current page items length - those new fields
  /// will be always shown on the top of the list in the UI no matter
  /// the current filters.
  /// Following immutability, creates new instance.
  Paginable<D> addItem(D item) {
    return Paginable<D>(
      items: [...items, item],
      total: total + 1,
      totalPages: totalPages == 0 ? 1 : totalPages,
    );
  }
}
