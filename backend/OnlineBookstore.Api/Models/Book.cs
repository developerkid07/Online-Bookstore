namespace OnlineBookstore.Api.Models;

public sealed record Book(int Id, string Title, string Author, string Description, decimal Price, string ImageUrl);
