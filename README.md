# HexaGen

**The Architecture Guardian for Phoenix: Build clean ecosystems, not spaghetti code.**

HexaGen is a standardized Hexagonal Architecture scaffolding tool that extends the default Phoenix generators. It enforces a strict separation of concerns using the Ports and Adapters pattern, ensuring your business logic remains pure and entirely decoupled from technical details like databases or external APIs.

## Why HexaGen?

Standard Phoenix contexts often grow organically, inevitably mixing Ecto logic, web presentation, and business rules into tightly coupled monoliths. HexaGen prevents this by enforcing a directory structure that follows SOLID principles out of the box.

More than just a generator, HexaGen is a strict architectural guardian. By automating infrastructure, tests, and monitoring—and strictly decoupling the domain from the web layer—HexaGen allows development teams to **save up to 40% of setup and refactoring time**, letting developers focus exclusively on what matters: the core business rules.

### The Architecture

![Hexagonal Architecture Diagram](https://mermaid.ink/img/pako:eNptkEELwjAMhf_KkrM79S8IexmCDstO6mEupWvXonOn0_F_N9vBoXfJyXv5khdUay0YmE-47YAr-mAVAs-68vTIs_l6-7_Z_H_Z0m82v2z_K5uD_mUr_GZfX-W28vPAtA-7O7W-oF-m7fUu_W7-u5_6W_q797O2P-C379v-0m6q_9vP7h_2e9p_6rfP_029n_qbc_8F3vEBBZ97xw)

## Features

- Domain Layer: Pure Elixir structs representing business entities.
- Application Layer: Isolated Use Cases (one module per action) and Ports (contracts).
- Infrastructure Layer: Technical implementations (Ecto adapters) that can be easily swapped.
- Dependency Injection: Dynamic adapter injection using Elixir configuration.
- Built-in Mocking: Pre-configured setup for Mox for fast unit tests.
- High Code Coverage: Extensively tested for reliability.
- One Core, Multiple Skins: Write your business logic once and seamlessly generate API (JSON), traditional Web (HTML), or real-time (LiveView) interfaces on top of it without rewriting a single domain rule.
- Centralized Error Handler: Forget about mapping {:error, reason} in every controller. HexaGen includes an intelligent error handler that automatically translates domain errors into the correct HTTP status codes.
- Mox-Zero-Config TDD: Out-of-the-box native Dependency Injection. HexaGen automatically injects Mox definitions into your test_helper.exs, removing the friction of configuring mocks so you can test at high speed.

## Getting Started

### 1. Installation

Add hexagen to your mix.exs:

```elixir
def deps do
  [
    {:hexagen, "~> 0.1.0", only: :dev}
  ]
end
```

### 2. Setup

Run the setup task to prepare the project folders:

```bash
mix hexagen.setup
```

### 3. Generate a Hexagonal Context

```bash
mix hexagen.gen.context Accounts User users name:string age:integer
```

### 4. Generate Web Layers

```bash
mix hexagen.gen.html Accounts User users name:string
mix hexagen.gen.json Accounts User users name:string
mix hexagen.gen.live Accounts User users name:string
```

## SOLID Compliance

- S: Single Responsibility - One module per Use Case.
- O: Open/Closed - Add new adapters without touching business logic.
- L: Liskov Substitution - Swap implementations via Behaviours.
- I: Interface Segregation - Clean Ports define exact requirements.
- D: Dependency Inversion - High-level logic depends on abstract Ports.

## Contributing

Contributions are welcome. If you have suggestions for improving the scaffolding or adding new adapters, please open an issue or pull request.
