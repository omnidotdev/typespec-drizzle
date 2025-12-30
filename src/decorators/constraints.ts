import type {
  DecoratorContext,
  Model,
  ModelProperty,
} from "@typespec/compiler";

import {
  IndexOptionsStateKey,
  IndexStateKey,
  UniqueOptionsStateKey,
  UniqueStateKey,
} from "../state/keys.js";

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
