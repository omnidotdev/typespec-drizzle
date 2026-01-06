// namespace for TypeSpec decorator resolution
export const namespace = "Drizzle";

// decorators
export {
  $autoIncrement,
  $column,
  $config,
  $id,
  $index,
  $junction,
  $manyToMany,
  $manyToOne,
  $map,
  $oneToMany,
  $oneToOne,
  $relation,
  $table,
  $unique,
  $uuid,
} from "./decorators/index.js";
// emitter entry point
export { $onEmit } from "./emitter.js";
// library definition
export { $lib, createDiagnostic, reportDiagnostic } from "./lib.js";
// state management (for advanced usage)
export * from "./state/index.js";
