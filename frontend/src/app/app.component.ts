import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Book } from './models/book';
import { BookstoreApiService } from './services/bookstore-api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {
  books: Book[] = [];
  selectedBookIds: number[] = [];
  customerName = '';
  customerEmail = '';
  statusMessage = '';

  constructor(private readonly api: BookstoreApiService) {}

  ngOnInit(): void {
    this.api.getBooks().subscribe({
      next: (books) => {
        this.books = books;
      },
      error: () => {
        this.statusMessage = 'Unable to load books. Ensure backend is running on :5000.';
      }
    });
  }

  toggleBook(bookId: number, checked: boolean): void {
    if (checked) {
      this.selectedBookIds = [...this.selectedBookIds, bookId];
      return;
    }

    this.selectedBookIds = this.selectedBookIds.filter((id) => id !== bookId);
  }

  get totalPrice(): number {
    return this.books
      .filter((book) => this.selectedBookIds.includes(book.id))
      .reduce((total, book) => total + book.price, 0);
  }

  submitOrder(): void {
    if (!this.customerName || !this.customerEmail || this.selectedBookIds.length === 0) {
      this.statusMessage = 'Please provide name/email and select at least one book.';
      return;
    }

    this.api.placeOrder({
      customerName: this.customerName,
      customerEmail: this.customerEmail,
      bookIds: this.selectedBookIds
    }).subscribe({
      next: (order) => {
        this.statusMessage = `Order #${order.id} placed successfully for $${order.total.toFixed(2)}.`;
        this.selectedBookIds = [];
      },
      error: () => {
        this.statusMessage = 'Order request failed. Check backend logs and try again.';
      }
    });
  }
}
