// namespace for TypeSpec decorator resolution
export const namespace = "Drizzle";

// emitter entry point
export { $onEmit } from "./emitter.js";

// library definition
export { $lib, reportDiagnostic, createDiagnostic } from "./lib.js";

// decorators
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
  $defaultValue,
  $sql,
  $oneToOne,
  $oneToMany,
  $manyToOne,
  $manyToMany,
  $relation,
  $config,
} from "./decorators/index.js";

// state management (for advanced usage)
export * from "./state/index.js";
