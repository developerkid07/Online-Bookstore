import { Book } from './book';

export interface OrderRequest {
  customerName: string;
  customerEmail: string;
  bookIds: number[];
}

export interface Order {
  id: number;
  customerName: string;
  customerEmail: string;
  books: Book[];
  total: number;
  createdAt: string;
}
