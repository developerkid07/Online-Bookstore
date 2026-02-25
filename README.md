# Online Bookstore (Angular + ASP.NET Core)

This repository contains a full-stack online bookstore application:

- **Frontend:** Angular standalone application (`frontend/`)
- **Backend:** ASP.NET Core Minimal API (`backend/OnlineBookstore.Api/`)

## Features

- Browse a seeded bookstore catalog
- Select books and calculate order total
- Submit orders with customer name and email
- In-memory backend order storage with order history endpoint


## One-command bootstrap + run

If your machine does not already have all dependencies, run:

```bash
./scripts/bootstrap-and-run.sh
```

This script attempts to:

1. Install .NET 8 SDK (via `apt` then `dotnet-install.sh` fallback)
2. Ensure Node.js + npm are available
3. Restore backend dependencies and start API on `:5000`
4. Install frontend dependencies and start Angular dev server on `:4200`

> Note: In locked-down/proxied environments where apt/npm/curl are blocked by policy, dependency downloads will fail. In that case run this script on a machine with access to Ubuntu/NuGet/npm registries.

## Run option A: local toolchains

### Prerequisites

- .NET SDK 8+
- Node.js 22+ and npm

### Start both apps

```bash
./scripts/run-local.sh
```

Or manually:

```bash
cd backend/OnlineBookstore.Api
dotnet run --urls http://localhost:5000
```

```bash
cd frontend
npm install
npm start
```

## Run option B: Docker Compose hosting

### Prerequisites

- Docker Engine + Compose plugin

### Build and run

```bash
docker compose up --build
```

- Frontend: `http://localhost:4200`
- Backend API: `http://localhost:5000/api`
- Frontend calls backend through `/api` (Nginx reverse proxy in Docker)

## API endpoints

- `GET /api/health`
- `GET /api/books`
- `POST /api/orders`
- `GET /api/orders`

### Sample order payload

```json
{
  "customerName": "Ada Lovelace",
  "customerEmail": "ada@example.com",
  "bookIds": [1, 3]
}
```

## Hosting notes for restricted environments

If the environment blocks package registries or runtime downloads, containers and app dependencies cannot be installed at runtime. In such cases, use an environment with access to NuGet, npm, and Docker image registries.
