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

This emitter allows you to define your database schema using TypeSpec's type-safe language with specialized decorators and automatically generate Drizzle ORM schema files, enabling a single source of truth for your database schema definitions alongside other artifacts.

## Features

- Generate Drizzle schema definitions from TypeSpec models
- Decorator-based configuration for database-specific concerns
- Support for table customization, constraints, and relationships
- Primary keys, unique constraints, indexes, and default values
- One-to-one, one-to-many, and many-to-many relationships
- Junction table support for many-to-many relationships
- Schema namespacing and custom table/column names
- Type-safe database schema generation
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

2. Define your models in TypeSpec with decorators:

```typespec
import "@omnidotdev/typespec-drizzle";

@table({ name: "users" })
model User {
  @id
  id: string;

  @unique
  email: string;

  name: string;

  @default("now()")
  createdAt: utcDateTime;
}

@table({ name: "posts" })
model Post {
  @id
  id: string;

  title: string;
  content: string;

  @manyToOne({
    foreignKey: "authorId",
    references: "id",
  })
  authorId: string;

  @default("now()")
  createdAt: utcDateTime;
}
```

3. Add a `tspconfig.yaml` file:

```yaml
emit:
  - "@omnidotdev/typespec-drizzle"
  - "@typespec/json-schema"
options:
  "@omnidotdev/typespec-drizzle":
    outputDir: "./tsp-output"
```

4. Run the TypeSpec compiler:

```sh
tsp compile .
```

The emitter will generate Drizzle schema files in the output directory, plus JSON schemas for your models.

## Decorators

### Table Decorators

#### `@table(options?)`

Mark a model as a database table.

```typespec
@table({ name: "custom_users", schema: "auth" })
model User {
  // ...
}
```

**Options:**

- `name?: string` - Custom table name (defaults to model name in lowercase)
- `schema?: string` - Database schema name

#### `@junction`

Mark a model as a junction table for many-to-many relationships.

```typespec
@junction
@table({ name: "user_roles" })
model UserRole {
  @manyToOne({ foreignKey: "userId", references: "id" })
  userId: string;

  @manyToOne({ foreignKey: "roleId", references: "id" })
  roleId: string;
}
```

### Column Decorators

#### `@column(options?)`

Configure column-specific options.

```typespec
@column({ name: "user_email" })
email: string;
```

**Options:**

- `name?: string` - Custom column name (defaults to property name)

#### `@id`

Mark a property as the primary key.

```typespec
@id
id: string;
```

#### `@autoIncrement`

Mark a numeric primary key as auto-incrementing.

```typespec
@id
@autoIncrement
id: int64;
```

#### `@default(value)`

Set a default value for a column.

```typespec
@default("'active'")
status: string;

@default("now()")
createdAt: utcDateTime;

@default("0")
count: int32;

@default("false")
isActive: boolean;
```

#### `@unique(name?)`

Add a unique constraint to a column.

```typespec
@unique("unique_email")
email: string;

@unique  // Uses default constraint name
username: string;
```

#### `@index(name?)`

Add an index to a column.

```typespec
@index("idx_created_at")
createdAt: utcDateTime;

@index  // Uses default index name
title: string;
```

### Relationship Decorators

#### `@oneToOne(options?)`

Define a one-to-one relationship.

```typespec
@oneToOne({ foreignKey: "profileId", references: "id" })
profileId: string;
```

#### `@oneToMany(options?)`

Define a one-to-many relationship.

```typespec
@oneToMany({ foreignKey: "categoryId", references: "id" })
posts: Post[];
```

#### `@manyToOne(options?)`

Define a many-to-one relationship.

```typespec
@manyToOne({ foreignKey: "authorId", references: "id" })
authorId: string;
```

#### `@manyToMany(options)`

Define a many-to-many relationship.

```typespec
@manyToMany({ through: "post_tags" })
tags: Tag[];
```

**Relationship Options:**

- `foreignKey?: string` - Name of the foreign key field
- `references?: string` - Field in the target table (defaults to "id")
- `through?: string` - Junction table name (required for many-to-many)

## Examples

### Complete Blog Schema

```typespec
import "@omnidotdev/typespec-drizzle";

@table({ name: "users" })
model User {
  @id
  id: string;

  @unique
  @index("idx_username")
  username: string;

  @unique
  @index("idx_email")
  email: string;

  @default("now()")
  createdAt: utcDateTime;
}

@table({ name: "categories" })
model Category {
  @id
  id: string;

  @unique
  name: string;

  @manyToOne({ foreignKey: "parentId", references: "id" })
  parentId?: string;
}

@table({ name: "posts" })
model Post {
  @id
  id: string;

  title: string;
  content: string;

  @manyToOne({ foreignKey: "authorId", references: "id" })
  authorId: string;

  @manyToOne({ foreignKey: "categoryId", references: "id" })
  categoryId?: string;

  @manyToMany({ through: "post_tags" })
  tags: Tag[];

  @default("now()")
  createdAt: utcDateTime;
}

@table({ name: "tags" })
model Tag {
  @id
  id: string;

  @unique
  name: string;

  @default("now()")
  createdAt: utcDateTime;
}

@junction
@table({ name: "post_tags" })
model PostTag {
  @id
  id: string;

  @manyToOne({ foreignKey: "postId", references: "id" })
  postId: string;

  @manyToOne({ foreignKey: "tagId", references: "id" })
  tagId: string;

  @default("now()")
  createdAt: utcDateTime;
}
```

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
