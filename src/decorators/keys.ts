import {
  AutoIncrementStateKey,
  CompositeIdStateKey,
  PrimaryKeyStateKey,
  UuidStateKey,
} from "../state/keys.js";

import type {
  DecoratorContext,
  Model,
  ModelProperty,
} from "@typespec/compiler";
import type { CompositeIdOptions } from "../state/accessors.js";

/**
 * Mark a property as the primary key, or define composite primary key on a model.
 */
export const $id = (
  context: DecoratorContext,
  target: ModelProperty | Model,
  name?: string,
  fields?: string[],
): void => {
  if (target.kind === "ModelProperty") {
    context.program.stateSet(PrimaryKeyStateKey).add(target);
    return;
  }

  if (target.kind === "Model") {
    if (!fields || fields.length === 0) return;

    const compositeOptions: CompositeIdOptions = { name, fields };

    context.program.stateMap(CompositeIdStateKey).set(target, compositeOptions);
  }
};

/**
 * Mark a column as auto-incrementing (serial/identity).
 */
export const $autoIncrement = (
  context: DecoratorContext,
  target: ModelProperty,
): void => {
  context.program.stateSet(AutoIncrementStateKey).add(target);
};

/**
 * Mark a column as UUID type.
 */
export const $uuid = (
  context: DecoratorContext,
  target: ModelProperty,
): void => {
  context.program.stateSet(UuidStateKey).add(target);
};
