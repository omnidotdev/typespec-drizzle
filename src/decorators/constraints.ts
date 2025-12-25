import type {
  DecoratorContext,
  Model,
  ModelProperty,
} from "@typespec/compiler";

import {
  DefaultValueStateKey,
  IndexOptionsStateKey,
  IndexStateKey,
  SqlExpressionStateKey,
  UniqueOptionsStateKey,
  UniqueStateKey,
} from "../state/keys.js";
import { reportDiagnostic } from "../lib.js";

import type { IndexOptions, UniqueOptions } from "../state/accessors.js";

/**
 * Mark a column as unique, or define composite unique constraint on a model.
 */
export const $unique = (
  context: DecoratorContext,
  target: ModelProperty | Model,
  name?: string,
  columns?: string[],
): void => {
  context.program.stateSet(UniqueStateKey).add(target);

  if (name || columns) {
    const options: UniqueOptions = { name, columns };

    context.program.stateMap(UniqueOptionsStateKey).set(target, options);
  }
};

/**
 * Add an index to a column.
 */
export const $index = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: IndexOptions,
): void => {
  context.program.stateSet(IndexStateKey).add(target);

  if (options)
    context.program.stateMap(IndexOptionsStateKey).set(target, options);
};

/**
 * Set a default value for a column.
 */
export const $defaultValue = (
  context: DecoratorContext,
  target: ModelProperty,
  value: string | number | boolean,
): void => {
  if (value === undefined || value === null) {
    reportDiagnostic(context.program, {
      code: "invalid-default-value",
      target,
      format: { value: String(value), type: "unknown" },
    });

    return;
  }

  context.program.stateMap(DefaultValueStateKey).set(target, value);
};

/**
 * Use a raw SQL expression for default or computed values.
 */
export const $sql = (
  context: DecoratorContext,
  target: ModelProperty,
  expression: string,
): void => {
  if (!expression || expression.trim() === "") {
    reportDiagnostic(context.program, {
      code: "invalid-sql-expression",
      target,
      format: { expression },
    });

    return;
  }

  context.program.stateMap(SqlExpressionStateKey).set(target, expression);
};
