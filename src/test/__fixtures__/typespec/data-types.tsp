// Data types fixture - Testing various TypeSpec types mapped to Drizzle columns
namespace DataTypes;

/** Model demonstrating various scalar types */
model DataTypeExample {
  /** String/text field */
  id: string;

  /** Text field with different name */
  description: string;

  /** Integer field */
  count: int32;

  /** Large integer field */
  bigNumber: int64;

  /** Boolean field */
  isActive: boolean;

  /** Decimal/float field */
  price: float64;

  /** DateTime field */
  createdAt: utcDateTime;

  /** Optional datetime field */
  updatedAt?: utcDateTime;

  /** Optional string field */
  nickname?: string;

  /** Optional boolean field */
  isVerified?: boolean;

  /** Optional integer field */
  score?: int32;
}

/** Model with arrays and records */
model CollectionTypes {
  /** Primary key */
  id: string;

  /** Array of strings (should be stored as JSON or text) */
  tags: string[];

  /** Array of numbers */
  scores: int32[];

  /** Record/map type (should be stored as JSON) */
  metadata: Record<string>;

  /** Complex nested structure */
  settings: Record<unknown>;
}

/** Model with various timestamp scenarios */
model TimestampExample {
  /** Primary key */
  id: string;

  /** Required timestamp */
  createdAt: utcDateTime;

  /** Optional timestamp */
  deletedAt?: utcDateTime;

  /** Updated timestamp (should get defaultNow) */
  updatedAt: utcDateTime;

  /** Published timestamp */
  publishedAt?: utcDateTime;

  /** Archived timestamp */
  archivedAt?: utcDateTime;
}

/** Model with different string scenarios */
model StringVariations {
  /** Primary key */
  id: string;

  /** Regular text field */
  title: string;

  /** Long text field */
  content: string;

  /** Short identifier */
  code: string;

  /** Email field (still text in Drizzle) */
  email: string;

  /** URL field */
  website?: string;

  /** JSON-like string field */
  jsonData?: string;
}

/** Model with numeric variations */
model NumericTypes {
  /** Primary key */
  id: string;

  /** Small integer */
  smallInt: int32;

  /** Large integer */
  bigInt: int64;

  /** Decimal number */
  price: float64;

  /** Percentage (decimal) */
  percentage: float64;

  /** Optional numeric fields */
  weight?: float64;

  quantity?: int32;
}
