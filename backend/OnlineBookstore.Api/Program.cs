using OnlineBookstore.Api.Data;
using OnlineBookstore.Api.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAngular", policy =>
    {
        policy
            .WithOrigins("http://localhost:4200")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();
app.UseCors("AllowAngular");

var orders = new List<Order>();
var orderId = 1;

app.MapGet("/api/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/api/books", () => Results.Ok(BookCatalog.Items));

app.MapPost("/api/orders", (OrderRequest request) =>
{
    if (string.IsNullOrWhiteSpace(request.CustomerName) || string.IsNullOrWhiteSpace(request.CustomerEmail) || request.BookIds.Count == 0)
    {
        return Results.BadRequest(new { message = "Name, email and at least one book are required." });
    }

    var selectedBooks = BookCatalog.Items.Where(book => request.BookIds.Contains(book.Id)).ToList();

    if (selectedBooks.Count == 0)
    {
        return Results.BadRequest(new { message = "No valid books were selected." });
    }

    var order = new Order(
        Id: orderId++,
        CustomerName: request.CustomerName,
        CustomerEmail: request.CustomerEmail,
        Books: selectedBooks,
        Total: selectedBooks.Sum(book => book.Price),
        CreatedAt: DateTimeOffset.UtcNow
    );

    orders.Add(order);

    return Results.Created($"/api/orders/{order.Id}", order);
});

app.MapGet("/api/orders", () => Results.Ok(orders));

app.Run();
