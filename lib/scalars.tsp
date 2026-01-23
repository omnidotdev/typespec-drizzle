namespace Drizzle;

/**
 * Current timestamp scalar for database defaults.
 *
 * Use as a default value to generate `.defaultNow()` in Drizzle.
 *
 * @example
 * ```tsp
 * @table
 * model User {
 *   createdAt: utcDateTime = Drizzle.Defaults.currentTimestamp;
 *   updatedAt: utcDateTime = Drizzle.Defaults.currentTimestamp;
 * }
 * ```
 */
scalar currentTimestamp extends utcDateTime {
  init create();
}

/**
 * UUIDv4 (random) scalar for database defaults.
 *
 * Use as a default value to generate `.defaultRandom()` in Drizzle.
 * Uses PostgreSQL's `gen_random_uuid()` function.
 *
 * @example
 * ```tsp
 * @table
 * model User {
 *   @id
 *   id: string = Drizzle.Defaults.uuidv4;
 * }
 * ```
 */
scalar uuidv4 extends string {
  init create();
}

/**
 * UUIDv7 (time-ordered) scalar for database defaults.
 *
 * Use as a default value to generate `.default(sql\`uuidv7()\`)` in Drizzle.
 * Requires PostgreSQL 18+ for native support.
 *
 * UUIDv7 combines a timestamp prefix with random bits, providing both
 * uniqueness and chronological ordering for better index performance.
 *
 * @example
 * ```tsp
 * @table
 * model User {
 *   @id
 *   id: string = Drizzle.Defaults.uuidv7;
 * }
 * ```
 */
scalar uuidv7 extends string {
  init create();
}

/**
 * Pre-defined default values for common database patterns.
 */
namespace Defaults {
  /** Current timestamp default - emits `.defaultNow()` */
  const currentTimestamp: Drizzle.currentTimestamp = Drizzle.currentTimestamp.create(
  );

  /** UUIDv4 (random) default - emits `.defaultRandom()` */
  const uuidv4: Drizzle.uuidv4 = Drizzle.uuidv4.create();

  /** UUIDv7 (time-ordered) default - emits `.default(sql\`uuidv7()\`)` (PostgreSQL 18+) */
  const uuidv7: Drizzle.uuidv7 = Drizzle.uuidv7.create();
}
