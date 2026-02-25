import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Book } from '../models/book';
import { Order, OrderRequest } from '../models/order';

@Injectable({ providedIn: 'root' })
export class BookstoreApiService {
  private readonly apiBase = '/api';

  constructor(private readonly http: HttpClient) {}

  getBooks(): Observable<Book[]> {
    return this.http.get<Book[]>(`${this.apiBase}/books`);
  }

  placeOrder(payload: OrderRequest): Observable<Order> {
    return this.http.post<Order>(`${this.apiBase}/orders`, payload);
  }
}
