import 'dart:collection';

class LRUCache<K, V> {
  LRUCache({required this.maxSize});

  final int maxSize;

  final LinkedHashMap<K, V> _cache = LinkedHashMap();

  V? get(K key) {
    final value = _cache[key];
    if (value != null) {
      _cache.remove(key);
      _cache[key] = value;
    }
    return value;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      // Update existing - remove and re-add to move to end
      _cache.remove(key);
    }
    if (_cache.length >= maxSize) {
      // Remove least recently used (first item)
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }
}
