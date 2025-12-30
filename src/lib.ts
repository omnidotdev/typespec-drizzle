import { createTypeSpecLibrary, paramMessage } from "@typespec/compiler";

/**
 * TypeSpec library definition.
 */
export const $lib = createTypeSpecLibrary({
  name: "@omnidotdev/typespec-drizzle",
  diagnostics: {
    // table & schema
    "invalid-table-name": {
      severity: "error",
      messages: {
        default: paramMessage`Table name must be a valid identifier, got '${"name"}'`,
      },
    },
    "invalid-schema-name": {
      severity: "error",
      messages: {
        default: paramMessage`Schema name must be a valid identifier, got '${"name"}'`,
      },
    },

    // column
    "invalid-column-name": {
      severity: "error",
      messages: {
        default: paramMessage`Column name must be a valid identifier, got '${"name"}'`,
      },
    },

    // relations
    "invalid-relation-config": {
      severity: "error",
      messages: {
        default: paramMessage`Invalid relation configuration: ${"message"}`,
      },
    },

    // warnings
    "missing-primary-key": {
      severity: "warning",
      messages: {
        default: "Model should have a primary key field marked with @id",
      },
    },
  },
});

export const { reportDiagnostic, createDiagnostic } = $lib;

// re-export all decorators
export {
  $table,
  $junction,
  $column,
  $map,
  $id,
  $autoIncrement,
  $uuid,
  $unique,
  $index,
  $oneToOne,
  $oneToMany,
  $manyToOne,
  $manyToMany,
  $relation,
  $config,
} from "./decorators/index.js";

// re-export state accessors for use in emitter
export * from "./state/index.js";
