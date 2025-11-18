# TypeSpec Drizzle Emitter

<div align="center">
  <img src="/assets/logo.png" width="150" />

[Join Omni community on Discord](https://discord.gg/omnidotdev)

[![version](https://img.shields.io/github/v/release/omnidotdev/typespec-drizzle?sort=semver)](https://github.com/omnidotdev/typespec-drizzle/releases)
[![build](https://img.shields.io/github/actions/workflow/status/omnidotdev/typespec-drizzle/release.yml)](https://github.com/omnidotdev/typespec-drizzle/actions/workflows/release.yml)
[![license: MIT](https://img.shields.io/github/license/omnidotdev/typespec-drizzle)](https://github.com/omnidotdev/typespec-drizzle/blob/master/LICENSE.md)

</div>

A [TypeSpec](https://typespec.io) emitter that generates [Drizzle ORM](https://orm.drizzle.team) schema definitions and types from TypeSpec specifications. Learn about TypeSpec emitters [here](https://typespec.io/docs/extending-typespec/emitters-basics).

> [!IMPORTANT]
> **Project Status:** 🚧 This project is **brand new**. Use at your own risk.

## Overview

This emitter allows you to define your database schema using TypeSpec's type-safe language and automatically generate Drizzle ORM schema files, enabling a single source of truth for your database schema definitions alongside other artifacts.

## Features

- Generate Drizzle schema definitions from TypeSpec models
- Type-safe database schema generation
- Support for common database types and constraints
- Integration with TypeSpec's existing ecosystem

## Installation

```sh
bun add -D @omnidotdev/typespec-drizzle
```

## Usage

### Basic Usage

1. Add the emitter to your TypeSpec configuration (`tspconfig.yaml`):

```yaml
emit:
  - "@omnidotdev/typespec-drizzle"
```

2. Define your models in TypeSpec:

```typespec
import "@omnidotdev/typespec-drizzle";

model User {
  id: string;
  email: string;
  name: string;
  createdAt: utcDateTime;
}

model Post {
  id: string;
  title: string;
  content: string;
  authorId: string;
  publishedAt?: utcDateTime;
}
```

3. Run the TypeSpec compiler:

```sh
tsp compile .
```

The emitter will generate Drizzle schema files in the output directory.

## Getting Started

### Local Development

Use [Tilt](https://tilt.dev) for a unified development experience:

```sh
tilt up
```

or manually install and build:

```sh
bun install
bun run build # or `bun run build:watch`
```

Tests can be run with `bun test`.

## Contributing

See Omni's [contributing docs](https://docs.omni.dev/contributing/overview).

## License

The code in this repository is licensed under MIT, &copy; Omni LLC. See [LICENSE.md](LICENSE.md) for more information.
