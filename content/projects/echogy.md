---
title: "Echogy"
date: 2024-10-07
tags: ["Go", "SSH", "Proxy", "TUI"]
image: "https://opengraph.githubassets.com/1/echogy-io/echogy"
github: "https://github.com/echogy-io/echogy"
summary: "轻量级且高效的 SSH 反向代理工具，具有精美的终端用户界面 (TUI)"
---

# Echogy

A lightweight and efficient SSH reverse proxy tool implemented in Go, featuring a beautiful Terminal User Interface (TUI).

{{< linkcard
  url="https://github.com/echogy-io/echogy"
  title="Echogy - GitHub"
  description="A lightweight and efficient SSH reverse proxy tool"
  image="https://opengraph.githubassets.com/1/echogy-io/echogy"
  site="github.com"
>}}

## Features

### Terminal User Interface (TUI)

- Modern and responsive terminal interface
- SSH session management
- Real-time connection status monitoring
- User-friendly interface for managing SSH connections

### Core Features

- SSH reverse proxy functionality
- Multiple concurrent SSH connections support
- TCP port forwarding
- Secure session management
- Built-in logging system

## Quick Start

1. **Clone the repository**:

```bash
git clone https://github.com/echogy-io/echogy.git
cd echogy
```

2. **Install dependencies**:

```bash
go mod download
```

3. **Configure your settings** in `config.json`:

```json
{
  "addr": ":443",
  "ssh_addr": ":22",
  "domain": "your-domain.com",
  "idle_timeout": 300,
  "key": "YOUR_SSH_KEY"
}
```

4. **Build and run**:

```bash
make build
./echogy
```

## Project Structure

```
.
├── cmd/           # Command line tools
├── logger/        # Logging framework
├── tui/          # Terminal User Interface components
├── pprof/        # Performance profiling
├── echogy.go     # Core SSH implementation
├── conn.go       # Connection management
├── facade.go     # Facade pattern implementation
├── forward.go    # Port forwarding logic
└── util.go       # Utility functions
```

### Key Components

- **SSH Server**: Handles SSH connections and session management
- **Forward Proxy**: Manages TCP port forwarding
- **TUI**: Provides an interactive terminal interface
- **Logger**: Structured logging with multiple output formats

## Configuration

### SSH Key Setup

```bash
ssh-keygen -b 2048 -f echogy_rsa
# Copy the private key content to config.json
```

### Domain Configuration

```bash
# DNS A records
A your-domain.com YOUR_SERVER_IP
A *.your-domain.com YOUR_SERVER_IP
```

## License

This project is licensed under the BSD-3-Clause License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
