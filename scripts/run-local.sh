#!/usr/bin/env bash
set -euo pipefail

if ! command -v dotnet >/dev/null 2>&1; then
  echo "dotnet SDK is not installed. Install .NET 8 SDK first." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is not installed. Install Node.js + npm first." >&2
  exit 1
fi

pushd backend/OnlineBookstore.Api >/dev/null
dotnet restore
dotnet run --urls http://localhost:5000 &
BACKEND_PID=$!
popd >/dev/null

cleanup() {
  kill "$BACKEND_PID" 2>/dev/null || true
}
trap cleanup EXIT

pushd frontend >/dev/null
npm install
npm start
popd >/dev/null
