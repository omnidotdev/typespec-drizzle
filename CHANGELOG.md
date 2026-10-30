# @omnidotdev/typespec-drizzle

## 0.2.1

### Patch Changes

- [#18](https://github.com/omnidotdev/typespec-drizzle/pull/18) [`01bfc41`](https://github.com/omnidotdev/typespec-drizzle/commit/01bfc4130238cc91350a298014b167fa72475fed) Thanks [@coopbri](https://github.com/coopbri)! - fix: declare ts-pattern as a runtime dependency and stop emitting library types

  `ts-pattern` was only a devDependency, so the published package shipped no runtime dependencies and failed to load with `Cannot find package 'ts-pattern'` when installed standalone. It is now a regular dependency.

  The built-in type filter only excluded the exact `TypeSpec` namespace, so library types nested in sub-namespaces (e.g. `TypeSpec.Http`) leaked into the generated schema as spurious enums and tables. The filter now walks the namespace ancestry, so only the user's own types are emitted.

## 0.2.0

### Minor Changes

- [#4](https://github.com/omnidotdev/typespec-drizzle/pull/4) [`82c2c67`](https://github.com/omnidotdev/typespec-drizzle/commit/82c2c67aa77342cf89abdc1278990e82dd5aa177) Thanks [@coopbri](https://github.com/coopbri)! - Migrate to native TypeSpec scalar defaults. Add `Defaults.uuidv4`, `Defaults.uuidv7`, and `Defaults.currentTimestamp` scalars for setting default values on model properties. Remove custom `@default*` decorators in favor of native TypeSpec default syntax.

## 0.1.0

### Minor Changes

- [#2](https://github.com/omnidotdev/typespec-drizzle/pull/2) [`7e10896`](https://github.com/omnidotdev/typespec-drizzle/commit/7e10896e33fee01c283a063ad59d251c8536f881) Thanks [@coopbri](https://github.com/coopbri)! - Initial release with Postgres support
