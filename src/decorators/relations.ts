import type { DecoratorContext, ModelProperty } from "@typespec/compiler";

import {
  ManyToManyStateKey,
  ManyToOneStateKey,
  OneToManyStateKey,
  OneToOneStateKey,
  RelationOptionsStateKey,
  RelationStateKey,
} from "../state/keys.js";
import { reportDiagnostic } from "../lib.js";

import type { ManyToManyOptions, RelationOptions } from "../state/accessors.js";

/**
 * Define a one-to-one relationship.
 */
export const $oneToOne = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: RelationOptions,
): void => {
  context.program.stateSet(OneToOneStateKey).add(target);

  if (options)
    context.program.stateMap(RelationOptionsStateKey).set(target, options);
};

/**
 * Define a one-to-many relationship (this model has many of target).
 */
export const $oneToMany = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: RelationOptions,
): void => {
  context.program.stateSet(OneToManyStateKey).add(target);

  if (options)
    context.program.stateMap(RelationOptionsStateKey).set(target, options);
};

/**
 * Define a many-to-one relationship (this model belongs to target).
 */
export const $manyToOne = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: RelationOptions,
): void => {
  context.program.stateSet(ManyToOneStateKey).add(target);

  if (options)
    context.program.stateMap(RelationOptionsStateKey).set(target, options);
};

/**
 * Define a many-to-many relationship via junction table.
 */
export const $manyToMany = (
  context: DecoratorContext,
  target: ModelProperty,
  options: ManyToManyOptions,
): void => {
  if (!options?.through) {
    reportDiagnostic(context.program, {
      code: "invalid-relation-config",
      target,
      format: {
        message: "many-to-many relationships require a 'through' table",
      },
    });

    return;
  }

  context.program.stateSet(ManyToManyStateKey).add(target);

  context.program.stateMap(RelationOptionsStateKey).set(target, options);
};

/**
 * Define a flexible relationship (alternative to specific relationship decorators).
 */
export const $relation = (
  context: DecoratorContext,
  target: ModelProperty,
  options?: RelationOptions,
): void => {
  context.program.stateSet(RelationStateKey).add(target);

  if (options)
    context.program.stateMap(RelationOptionsStateKey).set(target, options);
};
