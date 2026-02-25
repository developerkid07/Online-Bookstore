namespace OnlineBookstore.Api.Models;

public sealed record OrderRequest(string CustomerName, string CustomerEmail, List<int> BookIds);

public sealed record Order(int Id, string CustomerName, string CustomerEmail, List<Book> Books, decimal Total, DateTimeOffset CreatedAt);
