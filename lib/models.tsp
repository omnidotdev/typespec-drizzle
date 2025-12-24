namespace Drizzle;

/**
 * Options for the @table decorator
 */
model TableOptions {
  /** Custom table name in the database */
  name?: string;

  /** PostgreSQL schema name (e.g., "public", "auth") */
  schema?: string;
}

/**
 * Options for the @column decorator
 */
model ColumnOptions {
  /** Custom column name in the database */
  name?: string;
}

/**
 * Options for the @uuid decorator
 */
model UuidOptions {
  /** Generate a random UUID as default value */
  defaultRandom?: boolean;
}

/**
 * Options for the @index decorator
 */
model IndexOptions {
  /** Custom index name */
  name?: string;

  /** SQL expression for computed index (e.g., "lower(email)") */
  expression?: string;
}

/** Foreign key action for ON DELETE / ON UPDATE */
alias ForeignKeyAction =
  | "cascade"
  | "restrict"
  | "set null"
  | "set default"
  | "no action";

/**
 * Options for relationship decorators
 */
model RelationOptions {
  /** Relation name for disambiguation */
  name?: string;

  /** Foreign key field(s) on this model */
  fields?: string | string[];

  /** Referenced field(s) on the target model */
  references?: string | string[];

  /** Action to take when referenced row is deleted */
  onDelete?: ForeignKeyAction;

  /** Action to take when referenced row is updated */
  onUpdate?: ForeignKeyAction;
}

/**
 * Options for @manyToMany decorator (requires junction table)
 */
model ManyToManyOptions {
  /** Name of the junction/bridge table model (required) */
  through: string;

  /** Relation name for disambiguation */
  name?: string;

  /** Foreign key field on junction table pointing to this model */
  foreignKey?: string;

  /** Foreign key field on junction table pointing to target model */
  references?: string;

  /** Action to take when referenced row is deleted */
  onDelete?: ForeignKeyAction;

  /** Action to take when referenced row is updated */
  onUpdate?: ForeignKeyAction;
}

/**
 * Composite primary key options (used on Model)
 */
model CompositeIdOptions {
  /** Constraint name for the composite primary key */
  name?: string;

  /** Fields that make up the composite primary key */
  fields: string[];
}

/**
 * Namespace-level configuration
 */
model Configuration {
  /** PostgreSQL schema name for all tables in this namespace */
  schema?: string;

  /** Enable strict mode for validation */
  strict?: boolean;
}
