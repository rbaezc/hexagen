# Changelog

All notable changes to this project will be documented in this file.

## [0.1.6] - 2026-05-29

### Added
- CodeGraph Static Analysis engine under `Hexagen.CodeGraph.Indexer` slice.
- Concurrent codebase scanning utilizing Elixir's AST parser (`Code.string_to_quoted/2`).
- Relational database schema with dynamic SQLite persistence in Ecto.
- Dynamic Repo setup and automatic, programmatic DDL table initialization.
- Batch upserts (`insert_all`) optimized for SQLite databases.
- Multi-alias expansion, nested module name prefixes, and relative `__MODULE__` namespace resolution in parser AST traverser.
- Mix task `mix hexagen.codegraph -i` to scan and index codebase to `codegraph.db`.
- Extensive unit test suite achieving green passes.

## [0.1.0] - 2026-04-23

### Added
- Hexagonal context generator (`mix hexagen.gen.context`).
- HTML, JSON, and LiveView orchestrator generators.
- SOLID-compliant folder structure setup (`mix hexagen.setup`).
- Dependency injection support via Application configuration.
- Automatic Mox mock generation and test boilerplate.
- Standardized error handling module (`Hexagen.ErrorHandler`).
- GitHub Actions CI workflow.
- 98% test coverage.
