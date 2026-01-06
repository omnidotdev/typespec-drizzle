import { ConfigStateKey } from "../state/keys.js";

import type { DecoratorContext, Namespace } from "@typespec/compiler";
import type { Configuration } from "../state/accessors.js";

/**
 * Configure namespace-level settings.
 */
export const $config = (
  context: DecoratorContext,
  target: Namespace,
  options: Configuration,
): void => {
  context.program.stateMap(ConfigStateKey).set(target, options);
};
