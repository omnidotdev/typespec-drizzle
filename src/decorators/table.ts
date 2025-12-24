import type { DecoratorContext, Model } from "@typespec/compiler";

import {
  JunctionStateKey,
  TableOptionsStateKey,
  TableStateKey,
} from "../state/keys.js";
import { reportDiagnostic } from "../lib.js";

import type { TableOptions } from "../state/accessors.js";

/**
 * Validate identifier name (table name, schema name).
 */
const isValidIdentifier = (name: string): boolean =>
  /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(name);

/**
 * Mark a model as a database table.
 */
export const $table = (
  context: DecoratorContext,
  target: Model,
  options?: TableOptions,
): void => {
  if (options?.name && !isValidIdentifier(options.name)) {
    reportDiagnostic(context.program, {
      code: "invalid-table-name",
      target,
      format: { name: options.name },
    });

    return;
  }

  if (options?.schema && !isValidIdentifier(options.schema)) {
    reportDiagnostic(context.program, {
      code: "invalid-schema-name",
      target,
      format: { name: options.schema },
    });
    return;
  }

  context.program.stateSet(TableStateKey).add(target);

  if (options)
    context.program.stateMap(TableOptionsStateKey).set(target, options);
};

/**
 * Mark a model as a junction/bridge table for many-to-many relationships.
 */
export const $junction = (context: DecoratorContext, target: Model): void => {
  context.program.stateSet(JunctionStateKey).add(target);

  if (!context.program.stateSet(TableStateKey).has(target))
    context.program.stateSet(TableStateKey).add(target);
};
