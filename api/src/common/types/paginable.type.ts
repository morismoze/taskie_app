export interface Paginable<D> {
  items: D[];
  totalPages: number;
  total: number;
}
