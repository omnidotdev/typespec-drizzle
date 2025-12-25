import "../build/src/index.js";

using TypeSpec.Reflection;

namespace Drizzle;

// table & column decorators

/**
 * Mark a model as a database table.
 *
 * @param options Table configuration options.
 * @example
 * ```tsp
 * @table
 * model User { ... }
 *
 * @table({ name: "users", schema: "auth" })
 * model User { ... }
 * ```
 */
extern dec table(target: Model, options?: valueof TableOptions);

/**
 * Configure column options for a property.
 *
 * @param options Column configuration options.
 * @example
 * ```tsp
 * @column({ name: "user_email" })
 * email: string;
 * ```
 */
extern dec column(target: ModelProperty, options?: valueof ColumnOptions);

/**
 * Map a property to a different column name in the database.
 *
 * Shorthand for @column({ name: "..." }).
 *
 * @param columnName The column name in the database.
 * @example
 * ```tsp
 * @map("created_at")
 * createdAt: utcDateTime;
 * ```
 */
extern dec map(target: ModelProperty, columnName: valueof string);

// primary key & identity decorators

/**
 * Mark a property as the primary key.
 *
 * Can also be used on a Model for composite primary keys.
 *
 * @param name Optional constraint name (for composite keys).
 * @param fields Fields for composite primary key (Model only).
 * @example
 * ```tsp
 * // single primary key
 * @id id: string;
 *
 * // composite primary key on model
 * @id("pk_user_post", #["userId", "postId"])
 * model UserPost { ... }
 * ```
 */
extern dec id(
  target: ModelProperty | Model,
  name?: valueof string,
  fields?: valueof string[]
);

/**
 * Mark a column as auto-incrementing (serial/identity).
 *
 * Generates: .generatedAlwaysAsIdentity().
 *
 * @example
 * ```tsp
 * @id @autoIncrement
 * id: int32;
 * ```
 */
extern dec autoIncrement(target: ModelProperty);

/**
 * Mark a column as UUID type with optional auto-generation.
 *
 * @param options UUID options (defaultRandom for auto-generation).
 * @example
 * ```tsp
 * @id @uuid({ defaultRandom: true })
 * id: string;
 * ```
 */
extern dec uuid(target: ModelProperty, options?: valueof UuidOptions);

// constraint decorators

/**
 * Mark a column as unique.
 *
 * Can be used on Model for composite unique constraints.
 *
 * @param name Optional constraint name.
 * @param columns Column names for composite unique (Model only).
 * @example
 * ```tsp
 * @unique email: string;
 *
 * @unique("uq_email", #["email", "tenantId"])
 * model User { ... }
 * ```
 */
extern dec unique(
  target: ModelProperty | Model,
  name?: valueof string,
  columns?: valueof string[]
);

/**
 * Add an index to a column.
 *
 * @param options Index configuration.
 * @example
 * ```tsp
 * @index({ name: "idx_email" })
 * email: string;
 *
 * @index({ name: "idx_email_lower", expression: "lower(email)" })
 * email: string;
 * ```
 */
extern dec index(target: ModelProperty, options?: valueof IndexOptions);

/**
 * Set a default value for a column.
 *
 * @param value Default value (literal or SQL expression like "now()").
 * @example
 * ```tsp
 * @defaultValue(true)
 * isActive: boolean;
 *
 * @defaultValue("now()")
 * createdAt: utcDateTime;
 * ```
 */
extern dec defaultValue(
  target: ModelProperty,
  value: valueof string | int32 | boolean
);

/**
 * Use a raw SQL expression for default or computed values.
 *
 * @param expression SQL expression.
 * @example
 * ```tsp
 * @sql("gen_random_uuid()")
 * id: string;
 *
 * @sql("CURRENT_TIMESTAMP")
 * createdAt: utcDateTime;
 * ```
 */
extern dec sql(target: ModelProperty, expression: valueof string);

// relationship decorators

/**
 * Define a one-to-one relationship.
 *
 * @param options Relation configuration.
 * @example
 * ```tsp
 * @oneToOne({ fields: #["profileId"], references: #["id"] })
 * profile: Profile;
 * ```
 */
extern dec oneToOne(target: ModelProperty, options?: valueof RelationOptions);

/**
 * Define a one-to-many relationship (this model has many of target).
 *
 * @param options Relation configuration.
 * @example
 * ```tsp
 * @oneToMany
 * posts: Post[];
 * ```
 */
extern dec oneToMany(target: ModelProperty, options?: valueof RelationOptions);

/**
 * Define a many-to-one relationship (this model belongs to target).
 *
 * @param options Relation configuration.
 * @example
 * ```tsp
 * @map("author_id")
 * authorId: string;
 *
 * @manyToOne({ fields: #["authorId"], references: #["id"] })
 * author: User;
 * ```
 */
extern dec manyToOne(target: ModelProperty, options?: valueof RelationOptions);

/**
 * Define a many-to-many relationship via junction table.
 *
 * @param options Relation configuration (through is required).
 * @example
 * ```tsp
 * @manyToMany({ through: "UserGroup" })
 * groups: Group[];
 * ```
 */
extern dec manyToMany(
  target: ModelProperty,
  options: valueof ManyToManyOptions
);

/**
 * Mark a model as a junction/bridge table for many-to-many relationships.
 *
 * @example
 * ```tsp
 * @table @junction
 * model UserGroup {
 *   @id @map("user_id") userId: string;
 *   @id @map("group_id") groupId: string;
 * }
 * ```
 */
extern dec junction(target: Model);

/**
 * Define a flexible relationship (alternative to specific relationship decorators).
 *
 * @param options Relation configuration.
 * @example
 * ```tsp
 * @relation({ fields: #["authorId"], references: #["id"] })
 * author: User;
 * ```
 */
extern dec relation(target: ModelProperty, options?: valueof RelationOptions);

// namespace configuration

/**
 * Configure namespace-level settings.
 *
 * @param options Configuration options.
 * @example
 * ```tsp
 * @config({ schema: "auth", strict: true })
 * namespace Auth;
 * ```
 */
extern dec config(target: Namespace, options: valueof Configuration);
