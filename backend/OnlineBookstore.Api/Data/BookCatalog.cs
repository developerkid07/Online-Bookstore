using OnlineBookstore.Api.Models;

namespace OnlineBookstore.Api.Data;

public static class BookCatalog
{
    public static readonly IReadOnlyList<Book> Items =
    [
        new(1, "The Pragmatic Programmer", "Andrew Hunt", "Classic tips for modern software craftsmanship.", 42.99m, "assets/pragmatic-programmer.jpg"),
        new(2, "Clean Code", "Robert C. Martin", "A handbook of agile software craftsmanship.", 37.50m, "assets/clean-code.jpg"),
        new(3, "Domain-Driven Design", "Eric Evans", "Tackling complexity in the heart of software.", 49.00m, "assets/ddd.jpg"),
        new(4, "Designing Data-Intensive Applications", "Martin Kleppmann", "Reliable, scalable and maintainable systems.", 54.99m, "assets/ddia.jpg")
    ];
}
