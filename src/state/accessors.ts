import type {
  Model,
  ModelProperty,
  Namespace,
  Program,
} from "@typespec/compiler";

import {
  AutoIncrementStateKey,
  ColumnOptionsStateKey,
  CompositeIdStateKey,
  ConfigStateKey,
  DefaultValueStateKey,
  IndexOptionsStateKey,
  IndexStateKey,
  JunctionStateKey,
  ManyToManyStateKey,
  ManyToOneStateKey,
  MapStateKey,
  OneToManyStateKey,
  OneToOneStateKey,
  PrimaryKeyStateKey,
  RelationOptionsStateKey,
  RelationStateKey,
  SqlExpressionStateKey,
  TableOptionsStateKey,
  TableStateKey,
  UniqueOptionsStateKey,
  UniqueStateKey,
  UuidOptionsStateKey,
  UuidStateKey,
} from "./keys.js";

// type definitions

export interface TableOptions {
  name?: string;
  schema?: string;
}

export interface ColumnOptions {
  name?: string;
}

export interface UuidOptions {
  defaultRandom?: boolean;
}

export interface IndexOptions {
  name?: string;
  expression?: string;
}

export interface UniqueOptions {
  name?: string;
  columns?: string[];
}

/**
 * Foreign key action for ON DELETE / ON UPDATE.
 */
export type ForeignKeyAction =
  | "cascade"
  | "restrict"
  | "set null"
  | "set default"
  | "no action";

export interface RelationOptions {
  name?: string;
  fields?: string | string[];
  references?: string | string[];
  onDelete?: ForeignKeyAction;
  onUpdate?: ForeignKeyAction;
}

export interface ManyToManyOptions extends RelationOptions {
  through: string;
  foreignKey?: string;
}

export interface CompositeIdOptions {
  name?: string;
  fields: string[];
}

export interface Configuration {
  schema?: string;
  strict?: boolean;
}

// table & column accessors

/**
 * Check if a model is marked as a table.
 */
export const isTable = (program: Program, model: Model): boolean =>
  program.stateSet(TableStateKey).has(model);

/**
 * Get table options for a model.
 */
export const getTableOptions = (
  program: Program,
  model: Model,
): TableOptions | undefined =>
  program.stateMap(TableOptionsStateKey).get(model) as TableOptions | undefined;

/**
 * Get the table name for a model.
 */
export const getTableName = (program: Program, model: Model): string => {
  const options = getTableOptions(program, model);

  return options?.name ?? model.name.toLowerCase();
};

/**
 * Get the schema name for a model.
 */
export const getTableSchema = (
  program: Program,
  model: Model,
): string | undefined => {
  const options = getTableOptions(program, model);

  return options?.schema;
};

/**
 * Get column options for a property.
 */
export const getColumnOptions = (
  program: Program,
  property: ModelProperty,
): ColumnOptions | undefined =>
  program.stateMap(ColumnOptionsStateKey).get(property) as
    | ColumnOptions
    | undefined;

/**
 * Get the column name for a property.
 */
export const getColumnName = (
  program: Program,
  property: ModelProperty,
): string => {
  const mappedName = program.stateMap(MapStateKey).get(property) as
    | string
    | undefined;

  if (mappedName) return mappedName;

  const columnOptions = getColumnOptions(program, property);

  if (columnOptions?.name) return columnOptions.name;

  return property.name;
};

// primary key & identity accessors

/**
 * Check if a property is marked as a primary key.
 */
export const isPrimaryKey = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(PrimaryKeyStateKey).has(property);

/**
 * Get composite primary key options for a model.
 */
export const getCompositeId = (
  program: Program,
  model: Model,
): CompositeIdOptions | undefined =>
  program.stateMap(CompositeIdStateKey).get(model) as
    | CompositeIdOptions
    | undefined;

/**
 * Check if a property is marked as auto-increment.
 */
export const isAutoIncrement = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(AutoIncrementStateKey).has(property);

/**
 * Check if a property is marked as UUID.
 */
export const isUuid = (program: Program, property: ModelProperty): boolean =>
  program.stateSet(UuidStateKey).has(property);

/**
 * Get UUID options for a property.
 */
export const getUuidOptions = (
  program: Program,
  property: ModelProperty,
): UuidOptions | undefined =>
  program.stateMap(UuidOptionsStateKey).get(property) as
    | UuidOptions
    | undefined;

// constraint accessors

/**
 * Check if a property or model is marked as unique.
 */
export const isUnique = (
  program: Program,
  target: ModelProperty | Model,
): boolean => program.stateSet(UniqueStateKey).has(target);

/**
 * Get unique constraint options.
 */
export const getUniqueOptions = (
  program: Program,
  target: ModelProperty | Model,
): UniqueOptions | undefined =>
  program.stateMap(UniqueOptionsStateKey).get(target) as
    | UniqueOptions
    | undefined;

/**
 * Check if a property is indexed.
 */
export const isIndexed = (program: Program, property: ModelProperty): boolean =>
  program.stateSet(IndexStateKey).has(property);

/**
 * Get index options for a property.
 */
export const getIndexOptions = (
  program: Program,
  property: ModelProperty,
): IndexOptions | undefined =>
  program.stateMap(IndexOptionsStateKey).get(property) as
    | IndexOptions
    | undefined;

/**
 * Get the default value for a property.
 */
export const getDefaultValue = (
  program: Program,
  property: ModelProperty,
): string | number | boolean | undefined =>
  program.stateMap(DefaultValueStateKey).get(property) as
    | string
    | number
    | boolean
    | undefined;

/**
 * Get the SQL expression for a property.
 */
export const getSqlExpression = (
  program: Program,
  property: ModelProperty,
): string | undefined =>
  program.stateMap(SqlExpressionStateKey).get(property) as string | undefined;

// relationship accessors

/**
 * Check if a property has a one-to-one relationship.
 */
export const isOneToOne = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(OneToOneStateKey).has(property);

/**
 * Check if a property has a one-to-many relationship.
 */
export const isOneToMany = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(OneToManyStateKey).has(property);

/**
 * Check if a property has a many-to-one relationship.
 */
export const isManyToOne = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(ManyToOneStateKey).has(property);

/**
 * Check if a property has a many-to-many relationship.
 */
export const isManyToMany = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(ManyToManyStateKey).has(property);

/**
 * Get relation options for a property.
 */
export const getRelationOptions = (
  program: Program,
  property: ModelProperty,
): RelationOptions | ManyToManyOptions | undefined =>
  program.stateMap(RelationOptionsStateKey).get(property) as
    | RelationOptions
    | ManyToManyOptions
    | undefined;

/**
 * Check if a model is a junction table.
 */
export const isJunction = (program: Program, model: Model): boolean =>
  program.stateSet(JunctionStateKey).has(model);

/**
 * Check if a property has a generic relation.
 */
export const hasRelation = (
  program: Program,
  property: ModelProperty,
): boolean => program.stateSet(RelationStateKey).has(property);

// namespace configuration accessors

/**
 * Get configuration for a namespace.
 */
export const getConfig = (
  program: Program,
  namespace: Namespace,
): Configuration | undefined =>
  program.stateMap(ConfigStateKey).get(namespace) as Configuration | undefined;

/**
 * Get configuration for a namespace, walking up the namespace hierarchy.
 */
export const getNamespaceConfig = (
  program: Program,
  namespace: Namespace | undefined,
): Configuration | undefined => {
  if (!namespace) return undefined;

  const config = getConfig(program, namespace);

  if (config) return config;

  if (namespace.namespace)
    return getNamespaceConfig(program, namespace.namespace);

  return undefined;
};
