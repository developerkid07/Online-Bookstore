#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

log() { printf '[bootstrap] %s\n' "$*"; }
warn() { printf '[bootstrap][warn] %s\n' "$*" >&2; }

configure_proxy_if_present() {
  local proxy="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-}}}}"
  if [[ -n "$proxy" ]]; then
    log "Configuring npm proxy from environment"
    npm config set proxy "$proxy" >/dev/null 2>&1 || true
    npm config set https-proxy "$proxy" >/dev/null 2>&1 || true
  fi
}

install_dotnet_sdk() {
  if need_cmd dotnet; then
    log "dotnet already installed: $(dotnet --version)"
    return
  fi

  log "dotnet not found, attempting install"

  if need_cmd apt-get; then
    set +e
    apt-get update -y && apt-get install -y dotnet-sdk-8.0
    local apt_status=$?
    set -e
    if [[ $apt_status -eq 0 ]] && need_cmd dotnet; then
      log "Installed dotnet via apt"
      return
    fi
    warn "apt installation failed; falling back to dotnet-install script"
  fi

  mkdir -p "$HOME/.dotnet"
  curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
  bash /tmp/dotnet-install.sh --channel 8.0 --install-dir "$HOME/.dotnet"
  export PATH="$HOME/.dotnet:$PATH"

  if ! need_cmd dotnet; then
    warn "dotnet installation failed"
    exit 1
  fi

  log "Installed dotnet via dotnet-install script: $(dotnet --version)"
}

install_node_if_missing() {
  if need_cmd node && need_cmd npm; then
    log "node already installed: $(node --version), npm: $(npm --version | tail -n1)"
    return
  fi

  log "node/npm missing, attempting apt install"
  apt-get update -y
  apt-get install -y nodejs npm

  if ! need_cmd npm; then
    warn "npm installation failed"
    exit 1
  fi
}

run_local_stack() {
  cd "$ROOT_DIR"
  configure_proxy_if_present

  log "Restoring backend dependencies"
  (cd backend/OnlineBookstore.Api && dotnet restore)

  log "Starting backend on http://localhost:5000"
  (cd backend/OnlineBookstore.Api && dotnet run --urls http://localhost:5000) &
  BACKEND_PID=$!

  cleanup() {
    kill "$BACKEND_PID" 2>/dev/null || true
  }
  trap cleanup EXIT

  log "Installing frontend dependencies"
  (cd frontend && npm install)

  log "Starting frontend on http://localhost:4200"
  (cd frontend && npm start)
}

install_dotnet_sdk
install_node_if_missing
run_local_stack
