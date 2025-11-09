/// Represents needed abstraction for a case when a value
/// can be undefined/null/concrete.
class ValuePatch<T> {
  const ValuePatch(this.value);

  final T value;
}
