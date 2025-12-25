/**
 * Symbol-based state keys for decorator metadata storage.
 *
 * Each decorator stores its data in the TypeSpec program state using these keys.
 * Using Symbol.for() ensures symbols are shared across module boundaries,
 * which is required for TypeSpec testing and when the library is loaded
 * through different import paths.
 */

// table & column
export const TableStateKey = Symbol.for("@omnidotdev/typespec-drizzle:table");
export const TableOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:table-options",
);
export const ColumnStateKey = Symbol.for("@omnidotdev/typespec-drizzle:column");
export const ColumnOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:column-options",
);
export const MapStateKey = Symbol.for("@omnidotdev/typespec-drizzle:map");

// primary key & identity
export const PrimaryKeyStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:primary-key",
);
export const CompositeIdStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:composite-id",
);
export const AutoIncrementStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:auto-increment",
);
export const UuidStateKey = Symbol.for("@omnidotdev/typespec-drizzle:uuid");
export const UuidOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:uuid-options",
);

// constraints
export const UniqueStateKey = Symbol.for("@omnidotdev/typespec-drizzle:unique");
export const UniqueOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:unique-options",
);
export const IndexStateKey = Symbol.for("@omnidotdev/typespec-drizzle:index");
export const IndexOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:index-options",
);
export const DefaultValueStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:default-value",
);
export const SqlExpressionStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:sql-expression",
);

// relationships
export const OneToOneStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:one-to-one",
);
export const OneToManyStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:one-to-many",
);
export const ManyToOneStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:many-to-one",
);
export const ManyToManyStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:many-to-many",
);
export const RelationOptionsStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:relation-options",
);
export const JunctionStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:junction",
);
export const RelationStateKey = Symbol.for(
  "@omnidotdev/typespec-drizzle:relation",
);

// namespace configuration
export const ConfigStateKey = Symbol.for("@omnidotdev/typespec-drizzle:config");

/**
 * All state keys grouped by category.
 */
export const StateKeys = {
  // table & column
  table: TableStateKey,
  tableOptions: TableOptionsStateKey,
  column: ColumnStateKey,
  columnOptions: ColumnOptionsStateKey,
  map: MapStateKey,

  // primary key & identity
  primaryKey: PrimaryKeyStateKey,
  compositeId: CompositeIdStateKey,
  autoIncrement: AutoIncrementStateKey,
  uuid: UuidStateKey,
  uuidOptions: UuidOptionsStateKey,

  // constraints
  unique: UniqueStateKey,
  uniqueOptions: UniqueOptionsStateKey,
  index: IndexStateKey,
  indexOptions: IndexOptionsStateKey,
  defaultValue: DefaultValueStateKey,
  sqlExpression: SqlExpressionStateKey,

  // relationships
  oneToOne: OneToOneStateKey,
  oneToMany: OneToManyStateKey,
  manyToOne: ManyToOneStateKey,
  manyToMany: ManyToManyStateKey,
  relationOptions: RelationOptionsStateKey,
  junction: JunctionStateKey,
  relation: RelationStateKey,

  // namespace configuration
  config: ConfigStateKey,
} as const;

export type StateKeyName = keyof typeof StateKeys;
