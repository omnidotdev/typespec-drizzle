import type { DecoratorContext, ModelProperty } from "@typespec/compiler";

import {
  ColumnOptionsStateKey,
  ColumnStateKey,
  MapStateKey,
} from "../state/keys.js";
import { reportDiagnostic } from "../lib.js";

import type { ColumnOptions } from "../state/accessors.js";

/**
 * Validate column name.
 */
const isValidColumnName = (name: string): boolean =>
  /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(name);

/**
 * Configure column options for a property.
 */
export const $column = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: ColumnOptions,
): void => {
  if (options?.name && !isValidColumnName(options.name)) {
    reportDiagnostic(context.program, {
      code: "invalid-column-name",
      target,
      format: { name: options.name },
    });

    return;
  }

  context.program.stateSet(ColumnStateKey).add(target);

  if (options)
    context.program.stateMap(ColumnOptionsStateKey).set(target, options);
};

/**
 * Map a property to a different column name in the database.
 */
export const $map = (
  context: DecoratorContext,
  target: ModelProperty,
  columnName: string,
): void => {
  if (!isValidColumnName(columnName)) {
    reportDiagnostic(context.program, {
      code: "invalid-column-name",
      target,
      format: { name: columnName },
    });

    return;
  }

  context.program.stateMap(MapStateKey).set(target, columnName);
};
