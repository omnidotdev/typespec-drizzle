// table & column
export { $table, $junction } from "./table.js";
export { $column, $map } from "./column.js";

// primary key & identity
export { $id, $autoIncrement, $uuid } from "./keys.js";

// constraints
export { $unique, $index, $defaultValue, $sql } from "./constraints.js";

// relationships
export {
  $oneToOne,
  $oneToMany,
  $manyToOne,
  $manyToMany,
  $relation,
} from "./relations.js";

// namespace configuration
export { $config } from "./config.js";
